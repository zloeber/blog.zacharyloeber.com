---
title: "Some Cool Kubernetes Tools"
author: "Zachary Loeber"
date: 2019-12-22T20:59:43-06:00
url: "/blog/2019/12/15/some_cool_kubernetes_tools/"
categories:
  - DevOps
  - Kubernetes
tags:
  - devops
  - pipeline
  - kubernetes
  - helm
featuredImage: "/images/blog/backlit_keyboard.jpg"
---
Are you working with kubernetes regularly? There are so many tools out there it can be difficult to know which ones to use. Here are a few of them I've found to be useful but may have flown under your radar.

<!--more-->

So these tools aren't the first ones you will install on a cluster but are more like hidden gems worthy of more public attention. Operating kubernetes is much less like brain surgery with the right tooling.

{{< figure src="/images/blog/drill_to_the_head.jpg" caption="The right tooling for kubernetes" alt="The right tooling for kubernetes" >}}

Let us just hop straight to the first one shall we?

## Katafygio

I've decided to start with the one that has the weirdest name but is arguablely the most valuable of the lot, [katafygio](https://github.com/bpineau/katafygio). 

If you have ever been a progressive network admin, you may have used Really awesome Cisco config Differ (aka. RANCID) to backup your slew of devices into version control. Kubernetes is a bunch of configuration with an api so we should back that up too right? That's where katafygio comes in and takes over where RANCID leaves off.

This app is a single binary that can be used to continuously backup yaml manifests of your cluster's configuration to a git repository. If you don't have an external git repo it will simply create one locally and start pumping configuration into it instead. I've seen (and used, and modified) whole bash script wrappers around kubectrl to do such tasks in the past. Yeah, I'll never do that again. You can run this app in your pipeline before a deployment or as a helm chart deployment on your cluster.

[katafygio Github Page](https://github.com/bpineau/katafygio)

## Popeye

It is refreshing to have kubernetes project names without 'kube' or 'k8s' in their name. I'm not certain what I think of all the nautilus based names but here is another one to add to the list, [Popeye](https://github.com/derailed/popeye). This project terms itself as a 'Kubernetes cluster resource sanitizer'. This description can be a bit misleading though as it only operates in a read-only mode and does not sanitize or change anything in your cluster. Popeye is pretty neat, it scans a cluster for over and under utilized nodes, dead/inactive namespaces, and a slew of other items at a glance. You even get a nice report card score at the end. ![](https://raw.githubusercontent.com/derailed/popeye/master/assets/d_score.png?raw=true)

There is no official helm chart for popeye but if you were running this on your cluster it would be as a simple Kubernetes cronjob anyway. Otherwise the single binary can be installed and run in a CI/CD pipeline or from your workstation as well.

[Popeye Github Page](https://github.com/derailed/popeye)

## Packages

This last one is not specifically a tool for kubernetes but it fills a niche that is hard to deny. [Packages](https://github.com/cloudposse/packages) provides an easy way to tap into github releases to pull down and extract the appropriate binary for your tools. It uses simple Makefile, docker, and bash to install or access the latest versions of a great tools either directly or via a container image.

I believe this is important as a great deal of our modern devops tools are released via github releases, not through any form of package management system. This tool can help the devops engineer stay on top of these releases without admin rights and in a fairly transparent way. Using packages via makefile spits out reusable bash snippets you can scrape out and easily embed into your own project or CI/CD pipelines as well.

Anyone who has dealt with a custom toolchain of apps released on github already know that each release is its own unique butterfly. The OS name may be references as Darwin, darwin, Linux, linux, or may not have an OS referenced in the download URL at all. Packages offeres an easy way around this mess with simple makefile tasks like this which will install the jenkins-x (jx) release binary for either OSX or Linux (or in Windows, WSL right?) and show you the curl commands used to do the install.

```
# I like to drop my binaries into ~/.local/bin from a long history of using pip for Python.

make -C install jx INSTALL_PATH=~/.local/bin
```

Packages includes several cool kubernetes specific tools such as k9s, jx, k3d, duffle, and more are being added regularly. It also includes foundational devops tooling like jq and gomplate.

> It should be noted that the team behind this project creates some of the best helmfile manifests I've seen as well as several other tools absolutely worth checking out and contributing towards.

[Packages Github Page](https://github.com/cloudposse/packages)

## Bonus Tools

I could write all day on the various tools out there. I've got no time for that so I'll just pop out a few more worth giving a whirl or keeping tabs on;

- [Forecastle](https://github.com/stakater/Forecastle) - Automatic dashboard of links to your kubernetes published applications
- [kube-opex-analytics](https://github.com/rchakode/kube-opex-analytics) - Kubernetes cost allocation and capacity analytics tool.
- [kube-cost](https://github.com/kubecost/cost-analyzer-helm-chart) - Same as above but a bit more comprehensive (it seems)
- [polaris](https://github.com/FairwindsOps/polaris) - Validation of best practices in your Kubernetes clusters. Creates a health report card similar to popeye exept web-based.
- [goldilocks](https://github.com/FairwindsOps/goldilocks) - Create baselines for vertical pod autoscaling (which is more difficult than you may think)

Enjoy yet more tooling to add to your long backlist of things to look into as we dive into 2020!
