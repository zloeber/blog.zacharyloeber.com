---
title: "Artifact Types"
author: "Zachary Loeber"
date: 2020-04-29T13:55:09-05:00
categories:
  - devops
tags: 
  - devops
  - cicd
featuredImage: "/images/banners/banner-hand-puzzle-pieces-750x250.jpg"
Permalink: _/blog/2020/04/29/artifact-types/_/
draft: false
---
A build pipeline's job is to create immutable artifacts. The type of artifact you build is highly dependant upon what purpose it serves. This article will go over types of artifacts found in various DevOps pipelines.

<!--more-->

# Introduction

An artifact is really just the output of a build of some sort. Too bad not all artifacts can be treated the same or things would be a whole lot easier. There several kinds of build artifacts that each require different code and pipeline techniques to produce and then use in your deployments. Here are a few:

- Deployment
- Library
- Bundle
- Pipeline

## Deployment Artifacts

Deployment artifacts typically take the form of a released executable for public consumption. This includes deb, rpm, exes, tar.gz (single binaries), msi, img, or any other form of release. Lately, a popular destination for such an artifact is Github Releases. Other package management apps like pip, npm, apt, chocolatey, or nix can also be a target for deployment artifacts.

Arguably, the most popular deployment artifact in the industry at the moment is the lowly container image.

## Library Artifacts

Library artifacts are very similar to deployment artifacts. They can even end up in some of the same artifact repositories. Library artifact destinations include; maven, npm, pip, or nuget. One key element that differentiates a library artifact from a deployment artifact is that a library's purpose is for use in other development efforts. 

If you are developing some application and a version of a library randomly starts acting differently there can be very real downstream issues. Because of this, of utmost importance is that the library artifact is immutable and permanently versioned. That is, we should not be able to overwrite a particular deployed version of the library once the library artifact has been published.

## Bundle Artifacts

I struggled to put this particular artifact type in the list. This is because it really is not one artifact but a grouping of several together that comprise a particular deployment or need. Typically the destination for a bundle artifact is not a repository or artifactory but rather a drop zone such as cloud storage or a virtual machine (or cluster of virtual machines). The end result is the same though, a group of binaries and configuration are packed up for downstream deployment or usage.

It is worth noting that it is entirely possible to bundle up artifacts into container images that are then unbundled further down in a deployment operations. Most notably, the **[Immutable Configuration pattern](https://github.com/rhuss/k8spatterns-examples/blob/master/configuration/ImmutableConfiguration/README.adoc)** for Kubernetes deployments would employ this technique.

## Pipeline Artifacts

This is an ephemeral file, bundle, or any other build output that lives only on your pipeline. These are typically are used to bridge the gap between a CI and CD within the same pipeline and can be found in almost every DevOps platform as a way to make pipeline as code more coherent. A few examples of pipeline artifacts include;

- Azure DevOps **[Pipeline Artifacts](https://docs.microsoft.com/en-us/azure/devops/pipelines/artifacts/pipeline-artifacts?view=azure-devops&tabs=yaml)**
- Github **[Workflow Artifacts](https://help.github.com/en/actions/configuring-and-managing-workflows/persisting-workflow-data-using-artifacts)**
- TektonCD Pipeline **[Task Input/Output Artifacts](https://github.com/tektoncd/pipeline/blob/master/docs/install.md#configuring-artifact-storage)**
- Jenkins **[Archive (workspace) Artifacts](https://www.jenkins.io/doc/pipeline/steps/core/#archiveartifacts-archive-the-artifacts)**

Often, a DevOps pipeline will rely on Pipeline artifacts when getting started or when a centralized artifact repository simply is not available. This is is complicated by the fact that some platforms (most notably, Azure DevOps Classic Pipelines) have created whole ecosystems around treating them as first class citizens within the DevOps process.

Pipeline artifacts can be a way to get a functional pipeline quickly and can be used solely for some types of pipelines. A typical example would be a Terraform pipeline. Terraform produces a plan file that can be used in a bundle along with the cached initialization files and any custom providers for a deployment. Here is an oversimplified example:

{{< figure src="/images/pipeline-artifact-example.jpg" caption="Simple Terraform Pipeline" alt="Simple Terraform Pipeline" >}}

You can see here that the plan bundle can be pushed into a pipeline artifact as a holding area. This is where dedicated reviewers would approve/deny the deployment into an environment. A Terraform plan bundle is perfectly suitable for a pipeline artifact as it meets both criteria I personally use to justify pipeline artifact usage;

1. Is the artifact part of a one-way or single use operation? (Yes. It is unlikely you would use a prior Terraform plan bundle to roll back operations)
2. Does the artifact only apply to a single target environment? (Yes. It can ONLY ever be used on a single target environment)


> Do yourself a favor, don't design your pipelines around using Pipeline artifacts as your sole artifact type. Relying heavily on such ephemeral artifacts can weaken your overall pipeline independence and reduce the pipeline code base reusability. They also makes rolling back to older versions of a deployment difficult, especially if your executed pipeline history is only kept for a short period of time.

# Conclusion

There, these are the general forms that artifacts in your pipelines might take. Did I miss any or have I made an egregious error? Please let me know on twitter, LinkedIn, or reach out to me on the **[SweetOps slack team](https://sweetops.com/slack/)** (which are always lively and a great way to connect with your professional peers!).

> NOTE: Diagram produced with **[CloudSkew](https://cloudskew.com)**