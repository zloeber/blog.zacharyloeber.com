---
draft: true
title: "The Raw Helm Chart"
author: "Zachary Loeber"
date: 2020-05-01T16:02:15-06:00
url: /blog/2020/05/01/the-raw-helm-chart/
type: post

categories:
  - DevOps
  - Kubernetes

tags:
  - devops
  - pipeline
  - helm
  - yaml
---

# DevOps: The Raw Helm Chart

The raw helm chart is designed to glue raw kubernetes configuration elements into the application deployment stack. This can be one way to put lifecycle around your cluster configuration and its super handy to have in your toolbelt.

<!--more-->

## The Chart

The raw chart is is fun as hell and feels like cheating when you are creating helm charts for your deployments.

## The Example

Here is how I use this particular chart to deploy a predefined set of dynamic PVC provisioning types. I basically use it to combine all the preparation work in [this guide for Azure Files on AKS](https://docs.microsoft.com/en-us/azure/aks/azure-files-dynamic-pv)

```yaml

```
