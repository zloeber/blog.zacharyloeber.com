---
title: "2021 - IT Industry Predictions"
author: "Zachary Loeber"
date: 2020-12-15T10:27:05-05:00
categories:
  - devops
  - Kubernetes
tags: 
  - devops
  - terraform
  - Kubernetes
  - containers
  - prediction
  - automation
  - declarative configuration
  - everything as code
featuredImage: "/images/banners/banner-virtual-phone-750x250.jpg"
Permalink: _/blog/2020/12/2021-it-industry-predictions/_/
draft: false
---
Wild speculations on hot trends to follow in information technology for 2021 and beyond.

<!--more-->

## Preface

It has been too long since I released an article. So I decided to employ machine learning and AI technologies to answer the question of why I, Zachary Loeber, regularly fall into such writing lulls. 

First I collected all the data for every article I ever wrote over the last decade along with the collected data for the publish dates that includes weather patterns, my job at the time, the phase of the moon, and general economic information and normalized it into JSON. Using TensorFlow, I constructed a model to deterministically evaluate if, under similar outside factors, I would want to write a blog for the world to consume. I then setup a workflow to run this model for a 1000 years of future blogging through a pipeline that feeds into a declaratively constructed Kubernetes cluster in the cloud. 

The data produced from this experiment told me that I will almost always go into authoring hibernation when I start a new and challenging project. I suspect that is because all of my energies are mostly diverted to the new or interesting challenge.

![](/images/crazy_data_scientist.jpg)

Ok, so absolutely none of that happened. Still, if I wanted to do all of this work, I know that it could be done. This excites me tremendously as a thought exercise but mildly scares me as an effort I'd actually like to undertake (nevermind if I 'should' undertake it). Why would a hardened IT veteran like myself fear any IT task? Further in this article I'll answer this question. Before that, allow me color the rest of this article with my worldview of information technology and try to explain why I'm so passionate about the work I do. Jump right into the [first prediction](#be-declarative-or-go-home) if you don't care about my feelings.

Information technology has always been ripe with opportunity for those willing to embrace and wield it to their advantage. In fact, information technology itself is a very open and true art form. Every race, gender, and nationality you can think of has geeks, hackers, and engineers that work diligently to maintain and further grow the scope of their trade and further the reaches of IT in our daily lives. I've worked with brilliant IT folks of all walks of life, genders, sexual preferences, races, ages, and tattoo counts (yes face tattoos as well). None of the physical traits or life choices of a geek matters because we are generally all working with technology to solve problems. Networking protocols, programming languages, and everything in between are agnostic of people's individual nuances or externalities. This is made more interesting by the fact that much of our extended IT community are faceless nobodies online.

> **NOTE** Of course there ARE external factors of bias and misogyny to be found in any industry. Let us not be so naive as to believe IT is immune from such garbage. I'd like to believe that, by and large, the community works hard to ferret out the bad actors.

The IT industry also serves as an economic equalizer for those who are given the opportunity to learn it. Often 're-skilling' an employee from the dwindling blue-collar workforce means learning automation, programming, security, or other skills intertwined with technology. This is great news! We welcome all those with the desire to always be learning and growing aboard the unicorn ride that is IT! Better yet, the road to IT mastery has never had more lanes than right now. One can take online courses to learn micro-services, devops, cloud architecture and more, often at nominal or no cost to the learner. While not everyone will have the determination and means to become a doctor or lawyer, there is little stopping the intrepid folk out there from becoming adept enough at technology to make a good career from their efforts.

I have always had high hopes for technology because of these reasons. With that said, I've got some predictions that are so deeply affected by my personal experiences that they will almost certainly be a wild guesses at best. Shall we continue then?

## Be Declarative or Go Home

Kubernetes has taught us how to have a love/hate relationship with YAML. Kubernetes also gave many practitioners a taste of declarative configuration at a level never before experienced. With a few human readable manifests, one can deploy entire stacks of technology in short order. But this declarative thinking is still in its infancy for application configuration tasks across many other areas of IT.

Going back to my introduction, why would I, a self proclaimed automation engineer and devops geek, be scared to setup a complex solution to vet out some technical idea? Because it will take quite a bit of effort to do anything beyond the mundane tasks. I'd need to use several skills I already possess, some I do not (yet), and then time to put all the pieces together for a reliable and repeatable end to end deployment. If I were to take on a task like this, I'd always choose a declaratively configured solution over an imperative ones when picking the component parts. Choosing between two applications that accomplish the exact same task, I'd always choose the one with a declarative configuration instead of clickty-clicking around some web interface or diving into confusing config files.

![](/images/i_declaratively_configure_things.jpg)

 Apps which are easier to configure in an automated manner will ALWAYS win in a cloud-first generation. This is because they are faster to vet out, faster to implement, and therefore faster to use in your workflows. I believe more and more IT professionals will follow this mindset as they are slowly weened into the use of a declarative API driven state engine like Kubernetes.

So my first prediction is that online SaaS providers and stand-alone software vendors without declarative configuration systems for consumers will find that they are missing out on business revenue and sales because of it. To meet this demand at the SaaS level, I predict there will be more focus on high quality vendor providers for crossplains, terraform, and Pulumi. Furthermore, I believe we will find more declarative-style configuration being developed across the board for individual applications.

> Prime example, not too long ago I had to help implement seeding of Kafka topics and their configuration and came up with an init container deployment to do what was required. This included a custom container running the same verison of Kafka, some obtuse bash scripting, and more to get implemented in an automated manner. Not too long ago I saw an app that allows a simple yaml file to lay out and deploy topics ([Kafka topics configuration as code](https://github.com/segmentio/topicctl)). I'd use this kind of declaratively configured deployment every time over custom scripts. I believe most professionals would as well.

I've put together an [awesome list of declarative apps](https://github.com/zloeber/awesome-declarative-config) that is in its infancy but may be worth reviewing. The readme for this project continues the conversation. Oh, and contributes are totally welcome :).

## Policy As Code Gains Steam

I'm a huge fan of everything as code in all the work I do. In my experiences, IT solutions that are in version control with proper CICD pipelines are far easier to work with and support. This is because you are then allowed to treat entire solutions like cattle. And treating technical solutions like cattle, not pets, is reduces the inherent technical debt associated with the solution. And all IT solutions you ever have or will implement has technical debt. 

Reproduction of solutions and their configuration reliably allows for teams to remain agile and zero in on weak points far more efficiently than if they have to search around for some nuanced manually configured setting in a buried configuration file somewhere.

Policy as code eluded me up until I had to write a policy engine of my own. If you spend a little time researching policy as code the concept is actually amazingly simple.  Policies as code really is just an engine that consumes a bundle of data along with some checks against that data and returns the status of the checks. This is also called a logic gate. Those from the devops world might call this a unit test. Yes, this is a simple logic gate:

[![](https://mermaid.ink/img/eyJjb2RlIjoiZ3JhcGggTFJcbiAgICBEYXRhc2V0W0RhdGFdXG4gICAgUG9saWN5W1BvbGljeV1cbiAgICBFbmdpbmV7UG9saWN5IEVuZ2luZX1cbiAgICBTdWNjZXNzW1N1Y2Nlc3NdXG4gICAgRmFpbFtGYWlsXVxuICAgIERhdGFzZXQtLT5FbmdpbmVcbiAgICBQb2xpY3ktLT5FbmdpbmVcbiAgICBFbmdpbmUtLT58RXZhbHVhdGVzIFRSVUV8U3VjY2Vzc1xuICAgIEVuZ2luZS0tPnxFdmF1bGF0ZXMgRkFMU0V8RmFpbFxuIiwibWVybWFpZCI6e30sInVwZGF0ZUVkaXRvciI6ZmFsc2V9)](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoiZ3JhcGggTFJcbiAgICBEYXRhc2V0W0RhdGFdXG4gICAgUG9saWN5W1BvbGljeV1cbiAgICBFbmdpbmV7UG9saWN5IEVuZ2luZX1cbiAgICBTdWNjZXNzW1N1Y2Nlc3NdXG4gICAgRmFpbFtGYWlsXVxuICAgIERhdGFzZXQtLT5FbmdpbmVcbiAgICBQb2xpY3ktLT5FbmdpbmVcbiAgICBFbmdpbmUtLT58RXZhbHVhdGVzIFRSVUV8U3VjY2Vzc1xuICAgIEVuZ2luZS0tPnxFdmF1bGF0ZXMgRkFMU0V8RmFpbFxuIiwibWVybWFpZCI6e30sInVwZGF0ZUVkaXRvciI6ZmFsc2V9)

By nature, a policy engine requires some form of DSL that comprises the logic checks being performed. This is usually something that looks a bit like Python. One of the more established policy as code frameworks would be [Hashicorp Sentinel](https://www.hashicorp.com/sentinel). Another up and coming contender you likely already heard of is [Open Policy Agent (aka. OPA)](https://www.openpolicyagent.org/).

In any case, I'd expect we will begin to see more policies being stored in git inline with pipeline or other workflow orchestration platforms like airflow.

## Unified Deployment Platform - Kubernetes

Anyone who has been 'infected' by Kubernetes on the brain will likely gush on about how everything is a paradigm shift when using the platform and that Kubernetes is the 'future' of IT. While everyone else is just not using Kubernetes enough to understand why this is the case. For some reason I'm reminded of something an old colleague of mine once expressed about XML...

![](/images/kube_is_like_violence.jpg)

This is because as you wrangle container orchestration in your environments, it becomes apparent that aspects of your deployment pipelines that do not target the same platform become outliers in your workflows.

Beyond the simplest of apps, a cloud solution can often require;
- Load balancing
- Persistent storage
- Dedicated VMs
- Serverless workloads
- SaaS monitoring
- Secrets (Hashicorp Vault, Azure Vault, AWS SSM, et cetera)
- Monitoring (Datadog, CloudWatch, other)
- And more.

Adding to the complexity, deployments often traverse vendor boundaries. As such, automating the end to end deployment workflow for a project can evolve into a multi-pipeline CICD terraform and bash glued nightmare that makes you feel guilty at the end of the day.

If we are able to push a single manifest (or pull via GitOps) to a kube cluster for all of these component parts we can simplify the lifecycle of more complex deployments. And treating the Kubernetes extensible API as an entrypoint into a declarative deployment state machine for all of your needs is becoming more possible than ever before. We can use Kubernetes as a proxy tool to bootstrap and configure everything in one language that also happens to be declarative. There is power in this level of abstraction that is hard to ignore.

Tools have started to emerge that unify the deployment of resources and configuration using Kubernetes as the platform of choice. [Crossplane](https://crossplane.github.io/) is gathering steam as a multi-cloud deployment solution. And if you find something lacking perhaps use some declarative code from the [slew of AWS deployment controllers](https://github.com/aws-controllers-k8s/community), [Azure service operator](https://github.com/Azure/azure-service-operator), and numerous other interesting infrastructure targets.

## Links

- Awesome list of declarative apps - [link](https://github.com/zloeber/awesome-declarative-config)
- Hashicorp Sentinel - [link](https://www.hashicorp.com/sentinel)
- AWS-controllers-k8s - [link](https://github.com/aws-controllers-k8s/community)
- Azure Service Controller - [link]](https://github.com/Azure/azure-service-operator)