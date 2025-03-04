---
title: "Ado Keyvault Linked Var Groups"
author: "Zachary Loeber"
date: 2020-01-04T11:00:13-06:00
categories:
  - devops
  - azure
  - script
tags: 
  - devops
  - Azure Devops
  - Bash
  - KeyVault
featuredImage: "/images/blog/circuit.jpg"
---
Azure DevOps keyvault linked variable groups are not easy to automate but it can be done.

<!--more-->

## Introduction

As of late I've been working quite a bit with Azure Devops. It is a powerful platform with a dearth of possibilities but I quickly hit the ceiling of the platform's capabilities. It suffers from a common automation platform deficiency, the ability to automate the platform itself (automating the automation platform as it were). This is not uncommon and I've seen the same issues with Jenkins (props to Jenkins Job Builder for a very clever solution to some of these restrictions).

There has been some progress with a preview az cli extension aptly named 'devops'. If you are a little adept with Bash you can use the az cli to create and manage variable groups but you cannot create keyvault linked variable groups (or if you can, I don't see how). Luckily, like most modern PaaS solutions, Azure DevOps is capable of being automated further than you may think if you are willing ot dive into json templates and their REST API. Oh, you will still need that extension:

```bash
az extension add --name azure-devops
```

## Set the Stage

Automating this thing has more moving parts that I'm comfortable with but usually that's how 'hacks' go right? So to automate this with some security in place you need a ton of variables and secrets including....

Firstly we need an authorized service endpoint already created within Azure Devops. This should be tied to an SPN which can access the keyvault secrets via access policies. I personally use terraform to generate these and then assign them appropriate policies to only the resources it requires. I use another automation script/hack to create these service connections in ADO.

> I like to use per stage/team SPNs for service connections. This usually takes the form of STAGE_TEAM and ties back to an AKS cluster, so I can use the connection for deployment pipelines as well as grant the cluster rights to ACR, key vault policies, and so on right from terraform with the native azurerm provider.

You will also need A key vault populated with the following secrets that will need to have been granted access to ADO to create libraries (variable groups). In the script I provide I assume it is in the same key vault being linked to.

- ADOUSER (ADO Username)
- ADOPAT (Personal Access Token)

We also need some environment variables for less secret things. You will see later that I keep these in an .envrc file on a per team basis. Here are the basic ones which are required for this exercize.

```bash
AZ_SUBSCRIPTION=<subscription name>
AZ_SUBSCRIPTION_ID=<subscription id>
ADO_ORG=<ADO Org Name>
ADO_PROJECT=<ADO Project Name>
KEYVAULTNAME=<Key Vault to link ADO Group with>
SC_NAME=<service connection name>
```

Finally, we also need

- Azure CLI
- Azure CLI devops extension
- Permission to create library resources in Azure DevOps
- Fortitude, lots of that. 

Finally you will need a json template file for the variable group which I'll describe next.

## The JSON Template

In order to create a keyvault linked variable group you will need to setup a template json file and submit it to the ADO API via an HTTP POST. Easy peasy. I've done the reverse engineering bits for you on this one. Here is a json file for a variable group called 'SuperSecret' that links to a keyvault called SuperSecretVault and syncs the 'AIRFLOWFERNETKEY' and 'KUBESECRET' vault secrets. One could easily construct this automatically based on an existing key vault and some python I'd think.

```
{
  "authorized": true,
  "description": "SuperSecret Variable Group (SuperSecretVault)",
  "name": "SuperSecret",
  "type": "AzureKeyVault",
  "variableGroupProjectReferences": [
    {
      "projectReference": {
        "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
        "name": "MyADOProject"
      },
      "name": "SuperSecret",
      "description": "SuperSecret Variable Group (SuperSecretVault)"
    }
  ],
  "providerData": {
    "serviceEndpointId": "${service_endpoint_id}",
    "vault": "SuperSecretVault"
  },
  "variables": {
    "AIRFLOWFERNETKEY": {
      "enabled": true,
      "contentType": "",
      "value": null,
      "isSecret": true
    },
    "KUBESECRET": {
      "enabled": true,
      "contentType": "",
      "value": null,
      "isSecret": true
    },
  }
}
```

Shall we tokenize this? Okay,

```
{
  "authorized": true,
  "description": "${description}",
  "name": "${name}",
  "type": "AzureKeyVault",
  "variableGroupProjectReferences": [
    {
      "projectReference": {
        "id": "${project_id}",
        "name": "${project_name}"
      },
      "name": "${name}",
      "description": "${description}"
    }
  ],
  "providerData": {
    "serviceEndpointId": "${service_endpoint_id}",
    "vault": "${vault_name}"
  },
  "variables": {
    "AIRFLOWFERNETKEY": {
      "enabled": true,
      "contentType": "",
      "value": null,
      "isSecret": true
    },
    "KUBESECRET": {
      "enabled": true,
      "contentType": "",
      "value": null,
      "isSecret": true
    },
  }
}
```

With this at hand we can then work our magic.

## The Script

I put together a script which tokenizes our json file and submits it to Azure DevOps via curl. I used old school envsubst to keep it somewhat more portable.

```bash
#!/bin/bash
SC_NAME=${SC_NAME:-"Service Connection Name"}
KEYVAULTNAME=${KEYVAULTNAME:-"keyvault"}
AZ_SUBSCRIPTION=${AZ_SUBSCRIPTION:-"Azure Subscription"}
AZ_SUBSCRIPTION_ID=${AZ_SUBSCRIPTION_ID:-"Azure Subscription ID"}
ADO_ORG=${ADO_ORG:-"https://dev.azure.com/myorgname"}
ADO_PROJECT=${ADO_PROJECT:-"MyProject"}
SECRET_TEMPLATE=${SECRET_TEMPLATE:-"./secret-var-group.tpl"}

echo "STAGE: ${STAGE}"
echo "TEAM: ${TEAM}"
echo "AZ_SUBSCRIPTION: ${AZ_SUBSCRIPTION}"
echo "ENVRC: $ENVRC"
echo "KEYVAULTNAME: ${KEYVAULTNAME}"
echo "ADO_ORG: ${ADO_ORG}"
echo "ADO_PROJECT: ${ADO_PROJECT}"
echo "SECRET_TEMPLATE: ${SECRET_TEMPLATE}"
echo "SC_NAME: ${SC_NAME}"

## We pull this from our super secret keyvault
export ADO_USER="$(az keyvault secret show --name ADOUSER --vault-name $KEYVAULTNAME --subscription "$AZ_SUBSCRIPTION" --query value -o tsv)"
export ADO_PAT="$(az keyvault secret show --name ADOPAT --vault-name $KEYVAULTNAME --subscription "$AZ_SUBSCRIPTION" --query value -o tsv)"

get_ado_connection () {
  thiscon=`az devops service-endpoint list \
    --detect false \
    --subscription "$AZ_SUBSCRIPTION_ID" \
    --organization "$ADO_ORG" \
    --project "$ADO_PROJECT" \
    -o table | grep $1 | head -n1 | awk '{print $1;}'`
  echo "$thiscon"
}

get_ado_vargroup () {
  group=`az pipelines variable-group list \
    --detect false \
    --subscription "$AZ_SUBSCRIPTION_ID" \
    --organization "$ADO_ORG" \
    --project "$ADO_PROJECT" \
    -o table | grep $1 | head -n1 | awk '{print $1;}'`
  echo "$group"
}

remove_ado_vargroup () {
  echo "Attempting to remove vargroup id $1"
  if [ ! -z "$1" ]; then
    az pipelines variable-group delete \
      --group-id "$1" \
      --detect false \
      --subscription "$AZ_SUBSCRIPTION_ID" \
      --organization "$ADO_ORG" \
      --project "$ADO_PROJECT" \
      -y 2> /dev/null
  fi;
}

get_ado_project_id () {
  id=`az devops project show \
    --project $1 \
    --detect false \
    --subscription "$AZ_SUBSCRIPTION_ID" \
    --organization "$ADO_ORG" \
    -o table | head -n1 | awk '{print $1;}'`
  echo "$id"
}

echo "Retrieving ${SC_NAME} service endpoint id first..."
export service_endpoint_id=`get_ado_connection ${SC_NAME}`
export vault_name=$KEYVAULTNAME
export name=${SC_NAME}_secrets
export description="${SC_NAME} (linked to ${KEYVAULTNAME})"
export project="${ADO_PROJECT}"
export project_id=`get_ado_project_id ${ADO_PROJECT}` 

## If we have our service endpoint id we are good to go
if  [ ! -z "$service_endpoint_id" ]; then
  echo "ID for token replacement - ${SC_NAME} = $service_endpoint_id"
  DEPLOYVARS='$service_endpoint_id:$vault_name:$name:$description:$project:$project_id'
  envsubst "$DEPLOYVARS"< "${SECRET_TEMPLATE}" >/tmp/$(basename ${SECRET_TEMPLATE}).out
  vargroup=`get_ado_vargroup ${name}`
  if [[ ! -z "$vargroup" ]]; then 
    echo "Removing old keyvault linked variable group ${name} ($vargroup)"
    echo "proceed?"
    read
    remove_ado_vargroup $vargroup
  fi
  curl -X POST \
    --user "${ADO_USER}:${ADO_PAT}" \
    -H "Content-Type: application/json" \
    -d @${SECRET_TEMPLATE}.out \
    "${ADO_ORG}/${ADO_PROJECT}/_apis/distributedtask/variablegroups?api-version=6.0-preview.2"
fi
```

## Conclusion

Well that kinda was a stinker 'eh? The moment this is published I'm willing to bet the az cli extension gets updated with some new subcommand to create these things. Tis the way of our industry right?