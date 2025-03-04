---
title: "Azure Devops Automated Variable Groups"
author: "Zachary Loeber"
date: 2020-03-23T11:33:38-06:00
categories:
  - Azure
  - DevOps
  - Pipeline
tags:
  - blog
  - azure
  - devops
  - pipeline
  - bash
  - yaml
featuredImage: "/images/blog/backlit_keyboard.jpg"
url: "/blog/2020/3/23/ado_automated_variable_groups/"
draft: false
---

In this article I'll cover how one can automate creating and updating ADO libraries (aka. variable groups) using pipeline as code.

<!--more-->

## Introduction

In [a prior post](https://zacharyloeber.com/2020/01/ado-keyvault-linked-var-groups/) I covered the somewhat painful automation of Azure DevOps keyvault linked variable groups. In this post I'll do the same for updating regular variable groups (aka. ADO 'Libraries'). Azure DevOps Libraries are groups of variables which can be exceedingly useful in your pipelines. Unfortunately, they tend to be manually updated and tinkered with outside of version control. Deploying variable groups from a pipeline helps ensure all aspects of my deployments are under version control.

## How To Do It

It would be much easier to use a terraform provider to do such things but the only one out there for ADO [is so beta that you'd have to compile it yourself to use it](https://github.com/microsoft/terraform-provider-azuredevops). So we are left with bash scripts and prayers again. No worries, that's the stuff pipelines are made of right?

On the surface the script to accomplish this task is pretty easy. Use one azure cli command to create the variable group and populate it with all of its variables. 

```bash
# Login
az login --service-principal \
  --username "${SPNAPPID}" \
  --password "${SPNSECRET}" \
  --tenant "${TENANTID}"

# Add the cli extension
az extension add --name azure-devops

# Profit!
az pipelines variable-group create \
  --name "$name" \
  --authorize true \
  --detect false \
  --subscription "$AZSUB" \
  --organization "$ADO_ORG" \
  --project "$ADO_PROJECT" \
  --variables "${arr[@]}"
```

Clear as mud right? It will make more sense in context of an pipeline, promise.

## The Pipeline

The pipeline code I will use consumes a file with a simple key pair value list. This is commonly known as a `.env` file.

```bash
MYVAR=somevalue1
MYVAR2=somevalue2
```

I use this format because it is easy to create, update, and consume in other scripts (like Makefiles). This also is easy to review and keep in version control. To use the file, just read it into a bash array and wrap it in some other script logic. The final pipeline code is a template for a job to be used in other pipeline stages with little effort.

```bash
## ado-variable-group.yml
# Use az cli to update or create an ADO variable group like a crazy person
# sourceFile is a generic .env file with entries in VAR=VALUE format.

parameters:
  sourceFile: ''
  groupName: ''
  overwrite: 'true'
  adoProject: ''
  adoOrg: ''
  adoUser: ''
  adoPAT: ''

steps:
- bash: |
    export ADO_USER=${ADOUSER}
    export ADO_PAT=${ADOPAT}
    export AZURE_DEVOPS_EXT_PAT=${ADOPAT}
    if [ ! -e "$SOURCEFILE" ]; then
        echo "Without the SOURCEFILE file we are at a loss what to do :("
        exit 1
    fi
    AZSUB=$(az account show --output tsv --query id)
    if [ -z "$AZSUB" ]; then
      echo "Unable to determine current Azure subscription!"
      exit 1
    fi
    echo "Sourcing variables: $SOURCEFILE"
    myvalues=()
    while IFS= read -r line; do
        var=`echo $line | tr -d '"'`
        myvalues+=("$var")
    done < "${SOURCEFILE}"

    set -a
    . "${SOURCEFILE}"
    set +a

    echo "AZSUB: ${AZSUB}"
    echo "ADO_USER: ${ADO_USER}"
    echo "ADO_PAT: ${ADO_PAT}"
    echo "ADO_ORG: ${ADO_ORG}"
    echo "ADO_PROJECT: ${ADO_PROJECT}"
    get_ado_vargroup () {
      group=`az pipelines variable-group list \
        --detect false \
        --subscription "$AZSUB" \
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
          --subscription "$AZSUB" \
          --organization "$ADO_ORG" \
          --project "$ADO_PROJECT" \
          -y 2> /dev/null
      fi;
    }
    add_ado_vargroup () {
      if [ ! -z "$1" ]; then
        local name="$1"
        shift
        local arr=("$@")
        echo "Attempting to add vargroup - $name"
        echo "  Variables = $arr"
        az pipelines variable-group create \
          --name "$name" \
          --authorize true \
          --detect false \
          --subscription "$AZSUB" \
          --organization "$ADO_ORG" \
          --project "$ADO_PROJECT" \
          --variables "${arr[@]}"
      fi;
    }
    vargroup=`get_ado_vargroup ${GROUPNAME}`
    if [ ! -z "$vargroup" ]; then
      if [ "$OVERWRITE" = true ]; then
        echo "Removing ADO variable group ${GROUPNAME} ($vargroup)"
        remove_ado_vargroup $vargroup
      else
        echo "Variable already exists and OVERWRITE = ${OVERWRITE}"
        exit 1
      fi
    fi
    add_ado_vargroup ${GROUPNAME} "${myvalues[@]}"
    
  displayName: 'ADO Var Group - ${{ parameters.groupName }}'
  env:
    SOURCEFILE: '${{ parameters.sourceFile }}'
    GROUPNAME: '${{ parameters.groupName }}'
    OVERWRITE: '${{ parameters.overwrite }}'
    ADO_ORG: '${{ parameters.adoOrg }}'
    ADO_PROJECT: '${{ parameters.adoProject }}'
    ADOUSER: '${{ parameters.adoUser }}'
    ADOPAT: '${{ parameters.adoPAT }}'
```

If you are paying attention, you can see that we actually source in the source env file which is not strictly necessary.

```bash
    set -a
    . "${SOURCEFILE}"
    set +a
```

This may or may not be what you want depending on your requirements but it does allow for some pipeline trickery. For instance, it can be useful to include deployment specific information within the env file that can then be used later in the same pipeline. So you could, in theory, include the ADO_ORG, ADO_PROJECT, GROUPNAME, AZSUB, and more within this file and use it later in the script to reduce your pipeline code and parameters quite a bit.

## Requirements

In order to run the commands in the pipeline code you will need to have an existing keyvault linked variable group (I call mine `cicd_secrets`)with some secrets already in place. These are:

- clientid
- clientsecret
- tenantid
- ADOUSER
- ADOPAT

The clientid/clientsecret/tenantid are mainly just to login to the subscription, I use my terraform spn just to be certain. The ADOUSER and ADOPAT are a bit of a bummer as you need to precreate one manually with your own account. You can create this PAT with the following permissions:

- Variable Groups - Read, create, & manage
- Service Connections - Read, query, & manage (optional)

I'll cover in another post the automation of service connections via pipeline as code. I'll leave it up to you if you want to include this permission in your PAT but it is technically optional for this excercise.

> **NOTE** ADO PATs are the preferred method for automating ADO via cli. These are called `personal` access tokens for a reason, they are not able to be scoped at a project level and so you are required to create them with your own account! Be kind to future owners of this process and well document that fact so that when your account gets deactivated a new PAT can be generated and the appropriate key vault secrets updated.

## Usage

As the pipeline is reusable template code, you would need to place it into your own repo and reference it in your calling pipeline.

```bash
name: ado-var-group-sync
trigger:
  batch: true
  branches:
    include:
    - master
  paths:
    include:
    - config/*

pr: none

resources:
  repositories:
    - repository: platform
      type: git
      name: MyProject/pipelinecode
      ref: refs/heads/master

stages:
- stage: ADO_Sync
  displayName: 'Update ADO'
  jobs:
  - job: Update_ADO
    pool:
      vmImage: ubuntu-latest
    variables:
    - group: cicd_secrets

    steps:
    - bash: |
        az login --service-principal \
          --username "${SPNAPPID}" \
          --password "${SPNSECRET}" \
          --tenant "${TENANTID}"
        az extension add --name azure-devops
      displayName: "Initialize"
      env:
        TENANTID: "$(tenantid)"
        SPNAPPID: "$(clientid)"
        SPNSECRET: "$(clientsecret)"

    # Variable Group Update
    - template: job/ado-variable-group.yml@platform
      parameters:
        sourceFile: 'config/vargroup.env'
        groupName: 'pipeline_parameters'
        overwrite: 'true'
        adoProject: 'MyProject'
        adoOrg: 'https://dev.azure.com/myADOorg'
        adoUser: $(ADOUSER)
        adoPAT: $(ADOPAT)
```

This example would trigger on the master branch of a repo only when files within the 'config' folder are updated. This is where one would want to drop the source env file and this pipeline code yaml file.

> **NOTE** This example assumes that your ADO org is `myADOorg` and that the project `MyProject` in ADO hosts the repository `pipelinecode` which includes the template pipeline as code shown in the prior section. This also assumes the required variables mentioned earlier are in the keyvault linked variable group called `cicd_secrets`.

## Pipeline Code Reuse

I highly recommend you start doing this for all of your pipeline code as it will make things far easier to support and expand upon down the line. My personal preference is to store the code within folders that describe the component part that the template should be used within. For example, the following folders might be present in your pipeline as code library:

- multistage
- build
- deploy
- job

You get the picture. The nice thing about this format is that you can see immediately what the code is used for within your pipelines when calling the template: `- template: job/ado-variable-group.yml@platform`

## Conclusion

For a while I was on the fence on if I should even be using these ADO libraries in my pipelines as they tend to get updated outside of version control. Not anymore though. With this pipeline code I can now put the configuration itself into version control and have PR approved updates along with the rest of the code that gets deployed. Pairing this kind of variable group maintenence with a well thought out naming convention, pipeline as code shared library, and per-environment deployment git repositories can be a powerful combo worth looking into.

All of the code in this article and any other Azure Devops related work I've done is [currently in github](https://github.com/zloeber/azure-pipeline-library).