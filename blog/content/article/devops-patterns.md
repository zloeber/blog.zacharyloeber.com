---
title: "DevOps Patterns"
author: "Zachary Loeber"
date: 2020-04-13T11:33:38-06:00
categories:
  - DevOps
  - Pipeline
  - Kubernetes
tags:
  - devops
  - kubernetes
  - pipeline
featuredImage: "/images/blog/shady_hacker.png"
Permalink: _/blog/2020/4/13/devops-patterns/_/
draft: false
---

Many standard DevOps patterns are well known at this point. Advances in technology, cloud computing, and workload orchestration in IT have heralded a new generation of DevOps engineer and tooling to meet modern business challenges. In this article we are going to attempt to surface and give name to a few patterns as it relates to the emerging realm of pipelines as code, declarative deployments, multi-cloud, and more.

<!--more-->

## Introduction

On a daily basis DevOps practitioners are wading through vendors, terminology, platforms, cloud services, and nomenclature of an ever shifting industry. DevOps encapsulates the idea of continual improvement and constant learning so it is no surprise that patterns and practices which work well and those that do not surface pretty quickly. Some patterns that have proven to accelerate software delivery and improve product quality include;

- Build once, deploy many times
- Immutable infrastructure as code
- Eliminating outside dependencies
- Version control everything
- Well defined git branching models

As your experience base grows in DevOps you will start to understand how things are supposed to be done versus how they are actually being done. You will come to realize that there are few environments that follow all of the DevOps best practices and that there are fuzzy lines almost everywhere. We will not rehash the fundamentals of what CI/CD are, nor will we cover the pantheon of DevOps known best practices and patterns in this article. Instead we will attempt to codify some terminology around the fuzzier areas of DevOps to help put terms to the patterns we are seeing every day.

> That which is old becomes new again. Or so they say. Many topics in this article are not new patterns but recycled ideas of things that have worked in this or other industries for quite a while.

## What is a DevOps Pattern?

For the sake of this discussion, a pattern is a solution or set of solutions working together with the goal of supporting or driving DevOps within an organization. Not all patterns are DevOps specific, and some may not even be considered DevOps best practice. Different requirements, team makeup, and organization culture usually demand different types of solution patterns. 

There are certain deployment pipelines which one might construct for Lambdas or Azure Functions that may not be used in a Kubernetes deployment. There are pipelines that may be constructed and used for an open source project that would never equate to an enterprise class platform as service project. Deploying a micro-monolith is not the same as deploying an actual microservice architecture. Generally, these are a matter of preference and maturity level of both the developers and the DevOps teams but it is good to be aware of the differences between one or more ways of accomplishing the same tasks.

Before going over some patterns, we should first cover an important precursor definition.

## Pipeline Complexity

I have now worked with multiple development teams to help layout their DevOps strategies and formulate solutions to execute them. The common element for all of these engagements has been that the amount of time to ramp up solutions was heavily dependent upon the pipeline complexity. I've put together an arbitrary complexity chart that can help visualize how the complexity can quickly ramp up based on the additive requirements for the DevOps pipelines being created. From left to right, each defined task is additive upon the prior task which increases the resulting pipeline complexity accordingly.

{{< figure src="/images/devops-pipeline-complexity-scale.png" alt="Pipeline complexity scale" >}}

> The listed tasks are realistically arbitrary. If your artifact is a bundled from multiple distinct repositories nestled in sub-folders of unique branches that need to be custom compiled and bundled with specific libraries and made to work with glue and prayers in a docker container that has to use an undocumented base image then creating the artifact may actually be the most complex part of a pipeline!

A number of the patterns covered here directly relate to the pipeline complexity in some manner.

## Pattern: Cradle Infrastructure

This is when one deploys and configures a baseline environment using a separate process than the code being deployed into the environment. The base environment infrastructure essentially 'cradles' the workload deployments. This division of work can be at multiple points within an infrastructure and can be nested multiple levels deep. There tends to be a natural split between the network/system operators and the developers wherein the operators will deploy and help operate any number of target environments as a platform for the developers to target with their code delivery pipelines.

With the advent of the cloud and infrastructure as code it is possible to slice and dice resources up any number of ways. This is further complicated with Kubernetes hitting the scene. As Kubernetes is simply a platform for workload provisioning, it may not be uncommon to see a pipeline for carving out a base environment with shared elements at one corporate infrastructure level, another pipeline for deploying Kubernetes clusters at another operations level, then finally the pipelines for pushing project workloads into the clusters.

This is not a new pattern but one worth putting a name to as the difference in how much effort one spends on a DevOps pipeline can vary greatly on where this split in responsibility lies. This also maybe considered an anti-pattern as it tends to lead to more complex solutions around configuration management and typically makes for additional pipelines to manage.

If the cradle infrastructure and workload delivery are not both on pipelines then there is a dichotomy between teams which make for a good opportunity to cross-train and work together to level up both teams.

Here is a simplified illustration of what a cradle infrastructure might look like if a pipeline is only responsible for deploying the code base as an app into a pre-built Kubernetes namespace.

{{< figure src="/images/devops-cradle-infra.png" caption="Cradle infrastructure for a Kubernetes app deployment" alt="Cradle infrastructure for a Kubernetes deployment" >}}

The pipeline in this example need only build and deliver the built artifact to a namespace within an existing Kubernetes cluster. This could also have been an existing web app or service like Heroku.

> This should not be confused with the 'split infrastructure' pattern.

## Pattern: Split Infrastructure

This pattern is similar to that of the Cradle Infrastructure in that it divides the total surface area for infrastructure deployment among multiple teams. The difference is that more responsibility for the infrastructure creation falls more to the DevOps pipelines. Essentially the baseline infrastructure is at a higher level wherein there may only be some general networks and policies configured as guidelines for further infrastructure as code to be deployed in downstream pipelines. Alongside the baseline infrastructure, privileged accounts will be delegated rights to further deploy within their cut of the organization's cloud or data center.

Here is an illustration for how a split infrastructure may look.

{{< figure src="/images/devops-split-infra.png" caption="Split infrastructure for a Kubernetes deployment" alt="Cradle infrastructure for a Kubernetes deployment" >}}

The big difference in this case is that both the Kubernetes cluster and the app delivery will now be part of the same pipeline. If you refer back to the pipeline complexity chart, it can be seen that the more responsibility falls to the pipeline for deploying its own underlying infrastructure the more complex things become. This goes all the way up to deploying entire environments which are typically done with multiple pipelines and fairly complex Infrastructure as code manifests.

> Careful planning and consideration on how the teams operate and how they collaborate should be done when designing a split infrastructure.

## Pattern: OpsDev

This is the practice of allowing developers to operate and code directly against an environment infrastructure for a project. Often this is done to 'get things working' in a development environment first, wherein a pipeline will later be crafted for further releases into other environments. In the OpsDev pattern, it is typical to see your developers using IDEs to connect to and deploy code right from their workstations into Kubernetes clusters or cloud services. A good deal of OpsDev tools are emerging to help skill up development efforts for cloud native computing against Kuberentes. This runs the gambit of feature/functionality.

> This is not the same as using modern programming languages to allow developers to construct their own infrastructure as part of their deployment. Using Pulumi or SaltStack, or even using straight boto3 Python modules to build out any kind of infrastructure as real code is covered in the next pattern.

Some tool that can facilitate OpsDev include [Skaffold](https://skaffold.dev/), [Draft](https://draft.sh/), [Garden](https://garden.io/), [Tilt.dev](https://tilt.dev), [VS Code + Plugins](https://github.com/microsoft/vscode-azurefunctions). Anything that can remotely connect to and change a target resource or push a deployment on the fly can fall into this category.

When OpsDev is being practiced without appropriate DevOps involvement devlopers tend to find their work needs to be refactored to function in the context of a proper devops pipeline. This isn't always a bad thing. If you are simply vetting out solutions and have a single development environment then OpsDev gets solutions vetted out sooner. But OpsDev should never be practiced in a production environment.

The difference between OpsDev being done well and beind done dangerously is the boundary line of permissions set for deployment environments. If you maintain strict policies around how code is delivered to your important environments then OpsDev can be an enormously valuable tool for the inner-loop of your development strategy.

## Pattern: Infrastructure as Real Code

This is when a 'real' programming language like TypeScript, Python, or similar is used to define and construct the target deployment infrastructure in an imperative manner instead of via declarative manifests. Pulumi is the immediate example of a tool that allows for multiple real language bindings to be used that can be used to define and create the infrastructure. SaltStack would be considered another.

**Positives**
- In the right hands this can be a very powerful way to go from project ideation to reality very quickly
- This can, in theory, greatly simplify deployment pipelines

**Negatives**
- A more highly specialized skill set is required to support the pipelines for such a deployment.
- More room for abuse in practices if not carefully monitored (hard coded secrets or other parameters for instance)
- Very new way of doing things, as such it is technically less battle tested

## Pattern: Pipeline Independence

This is the practice of authoring pipeline as code to be run within the CI/CD platform first but in a way that it can also be run locally from a workstation. This enables additional lateral movement and options in the event that the pipeline platform is unavailable or needs to be changed out. This almost always requires additional effort to implement but doing this extra work allows for future flexibility and can force the pipeline authoring to be done in a more composable manner.

> I like to call this 'dual-pipelining' as, in some cases, can be double the amount of work to maintain!

An example of pipeline independence would be including a Makefile which can be used to drive all tasks that your github workflow pipelines may otherwise perform automatically. A fairly complete example of pipeline independence can be picked apart in this [Go hello-world-pipeline repo](https://github.com/zloeber/hello-world-pipeline).


## Pattern: Declarative Infrastructure as Code

When you use a declarative language to define and build your infrastructure. The ubiquitous example of such a pattern would be Hashicorp's Terraform. Terraform has its own language (HCL) for defining target infrastructure deployments in a mostly human readable format. Typically, when referring to infrastructure as code (aka. IaC) this is what is meant.

**Positives**

- This is a relatively common method of deploying immutable infrastructure and has been battle tested
- There are more rigid guidelines and rules in place around the language structure which can lead to fewer mistakes
- In the right hands this can also be a relatively quick way to go from project ideation to reality in a rapid manner
- You can maintain a consistent known state at all times by applying the declarative code base on a regular schedule

**Negatives**

- The tightly defined rules can severely restrict or prevent keeping a DRY (Don't Repeat Yourself) code base
- You need to know all of your infrastructure elements and keep it maintained with a backend known state
- The declarative way of coding is often an operations team skill that require additional resources beyond the core development team to implement
- The code is driven by third party providers which can vary in quality
- The tightly defined rules can often lead to shortcuts being implemented which reduce the overall value of using declarative code to begin with

There is also progress being made on enabling Kubernetes to build out infrastructure natively using its declarative manifests and [Open Service Broker](https://www.openservicebrokerapi.org/) integrations.

## Pattern: ConfigOps

ConfigOps, like any *Ops, starts with a git repository. In that repository is a structured set of files or directories for configuration of a project that is then delivered via pipelines to seed and maintain configuration for other pipelines in the project.

If you are using Azure DevOps this would be like keeping several env var files within a repo that, when updated via a PR, trigger's a pipeline that then updates variable groups used in other pipelines. If you are using Hashicorp's Consul for configuration management you might use [gonsul](https://github.com/miniclip/gonsul) to do similar pull request approved updates of key pair values into a Consul back-end.

> ConfigOps can be done within the app source repository or can be done in an independent git repository. The net result is the same, an audit-able trail of changes for configuration elements used in your project pipelines. 

# Conclusion

These are some patterns that I've noticed and feel should have terms of their own. Are there any other DevOps or related IT patterns that deserve their own name? Please feel free to contribute [to the repo I've started to catalog devops patterns](https://github.com/zloeber/devops-patterns).

A big thanks goes to [Andrew Roth](http://github.com/rothandrew) for providing valuable feedback for this article. He is a well of knowledge and an all around good guy.