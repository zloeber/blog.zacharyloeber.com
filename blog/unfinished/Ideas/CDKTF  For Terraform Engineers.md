
## Introduction

I've long been on the everything as code bandwagon with Terraform being at the top of my list of tools used specifically for infrastructure deployments.

When CDKTF came along I thought it would be a niche use case and be harder to support. But I've finally gotten my hands a bit dirty with infrastructure as (real) code via CDKTF and TypeScript and learned a few things I'm going to share in this article. This will be a quick tour of the technology and how one might migrate to using CDKTF for an existing Terraform project.

**TLDR** I'm surprised to find that I mostly like the experience of cramming declarative Terraform manifests into imperative code. It is still limited and adds overhead to your provisioning processes. I also didn't realize any time savings or readability gains.

---
## Why Use a CDK?

A "cloud development kit" is essentially a wrapper library for a handful of infrastructure as code based deployment tools. It exists as a more developer friendly interface to idempotent infrastructure deployment tools that devops practitioners have been wielding for some time now.

Some popular CDKs include;

| **Name**      | **Description**                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | **Supported Languages**                                                    | **URL**                                                                                                                                                                                                                                                                                                             |
| --- | --- | --- | --- |
| **CDKTF**     | **CDK for Terraform** allows developers to define cloud infrastructure using familiar programming languages, providing access to the Terraform ecosystem without needing to learn HashiCorp Configuration Language (HCL). | TypeScript, Python, Java, C#, Go                                           | [HashiCorp CDKTF](https://developer.hashicorp.com/terraform/cdktf) |
| **CDK8s**     | **CDK for Kubernetes** is a framework for defining Kubernetes applications using procedural programming languages, synthesizing standard Kubernetes manifests (JSON/YAML)     | TypeScript, JavaScript, Python, Java, Go | [cdk8s.io](https://cdk8s.io) |
| **AWS CDK**   | The AWS Cloud Development Kit (CDK) allows developers to define cloud infrastructure in code. It provides support for multiple programming languages, making it versatile for various development needs. Produces CloudFormation manifets.                                                                                                                                                                                                                                                                            | TypeScript, JavaScript, Python, Java, C#, Go                               | [AWS CDK](https://docs.aws.amazon.com/cdk/v2/guide/ref-cli-cmd-list.html)                                                                                                                                          |

They all share a common heritage stemming from the [AWS CDK](https://aws.amazon.com/cdk) and a TypeScript library used to generate many of the bindings.

> **Azure? Google?**  They have not found a need to release a dedicated CDK. You can always use the CDKTF and their Terraform Providers though!

## CDKTF and Terraform Differences

Both CDKTF and traditional Terraform do the exact same thing in the end. Here is a list of some differences between the two that you may wish to consider.

| **Characteristics**     | **CDKTF**                                             | **Terraform HCL**                                                                                                     |
| ----------------------- | ----------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| **Definition Language** | TypeScript, Python, Java, C#, DotNet                  | Human-readable HCL (HashiCorp Configuration Language)                                                                 |
| **Learning Curve**      | Steeper due to programming language requirements      | Gentler due to declarative and simple syntax                                                                          |
| **Reusability**         | Code reuse through modules and classes                | Module reuse through separate files and directories                                                                   |
| **State Management**    | Handles state through Terraform state files           | Handles state through Terraform state files                                                                           |
| **Resource Support**    | Supports all Terraform providers and modules          | Supports all Terraform providers and modules                                                                          |
| **Type Safety**         | Statically typed for type safety                      | Dynamically typed, type safety through third-party tools                                                              |
| **Integration**         | Seamless integration with existing CDKTF applications | Integrates well with other HashiCorp tools (Consul, Nomad, Vault)                                                     |
| **Testing**             | Unit testing capabilities through Jest or Pytest      | ~~Unit testing through third-party tools (Terratest, Kitchen-Terraform)~~<br>Native unit testing with recent versions |
| **Debugging**           | Log-level debugging and step-through debugging        | Output and log command for debugging                                                                                  |
| **Community**           | Growing CDKTF community support                       | Large, established Terraform community support                                                                        |

## CDKTF Drawbacks

> My personal take is that you must first remember that the CDK approach does not allow you to escape the many necessary flaws of the foundational declarative language it is replacing. 

CDKTF will **NOT**:
- Make a massive deployment with lots of state run faster
- Eliminate the need for review of the state diffs before production deployments
- Escape any of the known restrictions of Terraform itself. 
- Eliminate the need for well designed CICD pipelines
- Eliminate complexity (arguably)
 
In the end, you are just generating terraform plan files and playing tricks with state using another language.

Another drawback (depending on who you are) is that your deployment pipelines will need to include NodeJS, your language of choice, and a Terraform binary at bare minimum. I have this issue licked with [mise](https://mise.jdx.dev) personally. But just beware that there is no avoiding the nodejs part regardless of the language you are planning on using to interface with cdktf.

The workflow is a little obscene actually:

![CDKTF Workflow](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/0hct4cljba3ooe8jh7fj.png)

If you are using another language like Python, just add another block for your language above the TypeScript one. Even if I have the technical details wrong here, the fact remains the same that you will need to have NodeJS and npm installed and running for your project regardless of your language bindings used.

## CDKTF Benefits

Why might you choose to do your next project via CDKTF? 

**Novelty** It adds the idea of stacks and allows for a fresh take on module management. It feels like you are playing tricks with Terrafirn state even though I know I'm only doing so within the confines of what terraform allows.

**Code Alignment** If you code the infrastructure in the same programming language as the teams you are supporting you will likely immediately be liked by all.


> **Cool Trick** The `cdktf synth --hcl` command will generate terraform from your code which may help you isolate unwanted behaviors. Just remember to delete the generated `*.hcl` files within `.cdktf.out/` before attempting to do the deployment!

## Migrating from Terraform

The example project for this article can be found [at GitHub](https://github.com/zloeber/cdktf-for-tf-engineers). 
- The main branch is a terraform based deployment.
- The `cdktf` branch is the migrated version of the same deployment.

What follows is a general path taken to do the most basic of migrations without really doing much to adhere to best practices or be a shining example of TypeScript.

### Getting Ready

First setup NodeJS in the project to install and use a version that is supported (not the latest, that failed for me).

```sh
eval "$(mise activate bash)" # If not already in PATH

# Need an older version of NodeJS per https://github.com/hashicorp/terraform-cdk/issues/3641
mise use node@20

# install the cli globally to run it outside of the project itself
npm install -g cdktf-cli@latest

# create a new empty project folder
#  then start a new cdktf project there based on our terraform project
mkdir -p ./infrastructure/environments/local-cdktf
pushd ./infrastructure/environments/local-cdktf
cdktf init \
  --template=typecript \
  --project-name local-cdktf \
  --local \
  --from-terraform-project ./infrastructure/environments/local
popd
```

At this point I ran into some conversion issues. It duplicated some imports into the resulting `main.ts` file that needed to be removed. Also had to add the `App` import from cdktf.

Additionally, the generated `package.json` file did not include a deploy or destroy task so I added them.

> **TIP 1** You can use `npx` to run npm in the context of your project's `package.json` file to run project local cached binaries.

> **TIP 2** Any of the `scripts` section of package.json can be run in a similar manner as a makefile or taskfile as well (ie. `npm run get`)

At this point you will need to pull down any terraform providers and modules being used. These are defined in the project local `cdktf.json` manifest. You can add or remove providers using the cdktf cli (ie. `cdktf provider add hashicorp/helm`).

The order of operations to ensure you get everything you need to synthesize the terraform and run through a full deploy is as follows:

![CDKTF Deployment Process](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/dq7zt30hpdtcqqftcac8.png)

| Action        | Is Like           | Description                                                            |
| ------------- | ----------------- | ---------------------------------------------------------------------- |
| `cdk get`     | `terraform init`  | Generate bindings for providers and modules in the `./.gen` folder     |
| `cdk synth`   | NA                | Generate the final terraform that will be processed (defaults to json) |
| `cdk diff`    | `terraform plan`  | Optionally generate a difference plan                                  |
| `cdk deploy`  | Terraform apply   | Deploy it                                                              |
| `cdk destroy` | terraform destroy | Blow it all away                                                       |

You can view what terraform actually gets generated in HCL as well using `cdk synth --hcl`. All synthesized code ends up in the local `cdktf.out` folder.

> **WARNING** If you synth the hcl manifests ensure you delete them from cdktf.out when done. Otherwise when synth runs your terraform will be duplicated in both hcl and json and fail!

If you are up for it you can run through the full deploy and destroy lifecycle at this point.

```bash
pushd infrastructure/environments/local-cdktf
npm run get
npm run synth
npm run deploy
popd
```

If you got this far good. You also may have noticed that there are not 1 but two entrypoints for my terraform. I've got the clusters being created then afterwards we process each target environment cluster's initial argocd deployment and per-cluster ssh key generation.

If you look at the cdktf documentation there is the notion of a 'stack' that is inherited from cloudformation-land. These run individually either sequentially or in parallel (default). Lets see if we can turn `infrastructure/environments/local/cluster1` into its own stack within the existing `local-cdktf` we just created.

To do this we need to define the conversion as a stack and manually ensure the various providers it uses are listed.

```bash
# This is what I started with, don't run this and overwrite unless you want to start from scratch!
pushd infrastructure/environments/local-cdktf
../../../scripts/merge-convert.sh ../local/cluster1 | cdktf convert --language typescript --stack --provider hashicorp/kubernetes --provider hashicorp/helm > clusterconfig.ts
popd
```

The autogenerated `clusterconfig.ts` file will create a stack object called`MyConvertedCode` that we will change to `ClusterConfig`. We also need to add in referenced terraform modules to `cdktf.json`. It should look like this when done:

```json
{
  "language": "typescript",
  "app": "npx ts-node main.ts",
  "projectId": "b0d8b84d-514e-4b09-8e5b-b837ac428411",
  "sendCrashReports": "false",
  "terraformProviders": [
    "hashicorp/kubernetes",
    "hashicorp/helm",
    "tehcyx/kind@0.7.0"
  ],
  "terraformModules": [
    "../../modules/k8s-kind-cluster",
    "../../modules/self-signed-cert"
  ],
  "context": {}
}
```

> **Important** Providers that have an official hashicorp cdktf package will end up in the `package.json` file. Anything else will land in the `cdktf.json` file to be sourced into the `.gen` folder with the get stage.

The next question is if we want to use the cdktf version of the providers or use the automatically generated bindings from the terraform version of the providers (in `./.gen`)?

In our case both the kubernetes and helm providers have cdktf native versions. For this migration I'm simply going to keep the terraform auto-generated module bindings. If this were a big upgrade you'd have to revisit this file to use the official cdktf provider library.

### Multiple Stacks

After importing the (mostly) auto-generated stack for the cluster configuration via `import { ClusterStack } from "./cluster1";` we instantiate a new instance of it in `main.ts` (after our other stack).  The synth process will generate Terraform for each stack in its own folder as you may expect from an entirely separate Terraform project pipeline. In our case, we end up with two stacks, infrastructure and cluster1.

```typescript
const app = new App();
new BootstrapStack(app, "infrastructure");
new Cluster1Stack(app, "cluster1");
app.synth();
```

You can synthesize the terraform now if you want to review things. Or you can just deploy all the defined stacks (use glob patterns with single quotes to do them all, `--parallelism=1` to ensure they run sequentially).

```bash
pushd infrastructure/environments/local-cdktf
npm install
cdktf get
cdktf synth
cdktf deploy --parallelism=1 '*'
popd
```

At this point I ran into errors. Using terraform wrapped constructs such as variables doesn't support certain interpolation formats in strings and otherwise is just a pain to deal with. So I removed them entirely from the both stacks in favor of sending along a list of properties.

Also, the multiple stack synth happens via a common entrypoint (`main.ts`) so I made a `config.json` file that I then dumped all the collective `.tfvar` data for both stacks into. 

> **NOTE** I'm using a bunch of relative paths for state, keys, and kube config files to float them to the root of the project in one location. (This feels wrong so it probably is, production stuff like this would go right into a vault or secrets management solution).

```json
{
  "env": "local",
  "argocd_namespace": "argocd",
  "argocd_version": "stable",
  "infrastructure": {
    "state": "../../../../../../secrets/local/infra_state"
  },
  "cluster1": {
    "state": "../../../../../../secrets/local/cluster1_state",
    "kubeconfig": "../../../../../../secrets/local/cluster1_config",
    "helm_values": "./cluster1/config.yml",
    "secrets_path": "../../../../../../secrets/local"
  }
}
```

This then should allow you to run through a full multi-stack deployment to create the start of your argocd kube cluster deployment using [kind](https://kind.sigs.k8s.io/) on your local workstation. The generated ssh keys and cluster config will be dumped to `./secrets/local`

Test out Kubernetes has the ArgoCD deployments:

```bash
export KUBECONFIG=./secrets/local/cluster1_config
kubectl get deployments.apps --all-namespace
```

If you are all done blow it all away with `cdktf destroy '*'`.

## Conclusion

There are a ton of improvements that can be made to this but the gist of the flow to get from Terraform to CDKTF should be in place. I chose TypeScript because that is the original target language for the bindings. But you can go with a number of other languages of course. The process would not be much different.

As for my take on the technology, I do like that more fully realized variable handling and logic can be done in an imperative manner. Stacks are also a nice way to automatically segment state. 

Just keep in mind that you cannot break the rules of Terraform itself (like adding iteration to provider definitions or taking actions on unresolved data sources or any number of things you already hate about it). I also like using an object oriented approach to looking at my infrastructure requirements. But don't think that it makes anything more 'clear' to understand. Also, It is nice to spin up variables anywhere without needing `local {}` blocks all over the place (or one block very far away from the actual usage of the variable). 

For more information on CDKTF and all of its features hit up [the official site](https://developer.hashicorp.com/terraform/cdktf).

I'm curious what others think of the rise of CDKs for infrastructure deployments. Are you using any CDKs in your workflows? Have any big wins or epic failures when using them?

