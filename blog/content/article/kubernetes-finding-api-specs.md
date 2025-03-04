---
title: "Kubernetes API Specs"
author: "Zachary Loeber"
date: 2020-04-16T10:47:59-05:00
categories:
  - Kubernetes
  - API
tags: 
  - Kubernetes
  - API
  - DevOps
featuredImage: "/images/banners/banner-cloud-puzzle-750x188.jpg"
Permalink: _/blog/2020/4/16/kubernetes-api-specs/_/
draft: false
---
Can you quickly list out all the available pod security policy attributes on Kubernetes? How about listing the autoscaling apiVersions along with their spec attributes?

<!--more-->

## Introduction

If you are authoring any form of declarative manifest for configuring a Kubernetes cluster once it is running these tasks are not uncommon. But with each version of Kubernetes a new API schema is born. What may have worked only a year ago is on the road to depreciation or worse, already depreciated.

I found the simple task of getting API versions for resources to be both straightforward to perform but still oddly difficult to consume. It took digging through arcane **[swagger specifications](https://raw.githubusercontent.com/Kubernetes/Kubernetes/master/api/openapi-spec/swagger.json)** and weird tools just to find out how to get this seemingly basic information. This is a small post on some additional resources you have for getting this information.

## The API

Before diving into this post it would be wise to first give **[this concepts guide](https://kubernetes.io/docs/concepts/overview/kubernetes-api/)** on the Kubernetes API a once over. It describes how the Kubernetes API is defined.

If you are already prolific at reading swagger definition files, then you can simply go to the Kubernetes version you wish to look up, and parse that (See References at the end of this article).

The quick rundown of the API is that it is broken down into a handful of resource categories which contain resource objects which then provide specific API driven operations. I put them into a table for your convenience.

| Category | Scope | Example Resource Objects |
|---|---|---|
| Workloads | Namespace | Job, Pod, Deployment, Container, StatefulSet |
| Services | Namespace | Endpoint, Ingress, Service |
| Config & Storage | Namespace & Cluster | ConfigMap, Secret, StorageClass, PersistentVolumeClaim |
| Cluster | Namespace & Cluster | ClusterRole, ClusterRoleBinding, Node, Namespace, NetworkPolicy |
| Metadata | Cluster | HorizontalPodAutoscaler, Event, PodTemplate, PodSecurityPolicy, MutatingWebhookConfiguration, CustomResourceDefinition |

I was tempted to remove the "scope" column in this table as there is not a clear cut line between these groupings and the scope of their resources. There **IS** a general scope of namespaced vs. non-namespaced (non-namespaced =~ cluster level) at a per-resource level though and these scope approximations. The `kubectl api-resources` command even has a flag appropriately named `--namespaced`.

```bash
# View all available resources which are not 'namespaced'
kubectl api-resources --namespaced=false
```

> **NOTE:** The Kubernetes API also has a notion of 'groups' which is discussed in quite a bit more detail [here](https://github.com/Kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md). The categories mentioned above are not related to the above API groups.

## Finding Resources

Finding available Kubernetes resources is relatively easy to do against a running cluster. But what about for an arbitrary version of Kubernetes? The swagger definition for a released version of Kuberentes is easy enough to find and even read but it also uses references which can lead you down a rabbit hole of paths even for the simplest resources. Luckily enough for us someone has already run into this particular issue and **[put a project out there](https://github.com/instrumenta/kubernetes-json-schema)** to make working with the Kuberentes schema easier. This is done by normalizing the swagger API definition into **[JSON Schema](http://json-schema.org/)**.

The service offers a handful of options for pulling the JSON schema for individual elements. There is a standalone version which de-references the schema to put all resource elements in one spot. This is what I've been using and it works very well. 

For instance, if you want to view the Service object for Kuberentes 1.18.1, in full, just go to **[https://kubernetesjsonschema.dev/v1.18.1-standalone/service-v1.json](https://kubernetesjsonschema.dev/v1.18.1-standalone/service-v1.json)** in your browser. In any modern browser the JSON payload will be easy to browse without much extra effort.

![](/images/kubernetes-finding-api-specs-1.jpg)

## Answering The Questions

This post asked two questions. One of them is; Can you list out all the api versions for the autoscaling resources you can use on your cluster? This one is the easiest to answer. Use `kubectl api-versions`

```bash
kubectl api-versions | grep autoscaling 
```

![](/images/kubernetes-finding-api-specs-2.jpg)

Why is this important? Because the difference between these three resources really determine how you will be able to autoscale your resources. Also, that only shows the version available for the resource at a generic level which is only a small part of how you might author a manifest. Lets take it further.

```bash
kubectl api-resources | grep autoscaling
```

![](/images/kubernetes-finding-api-specs-3.jpg)

This tells us that the kind of resource we can use this against is the horizontalpodautoscaler. Let's use this and the prior resource to get its definition so we can try to create one of these things using the most recent version found for our cluster (v2beta2). **[horizontalpodautoscaler-autoscaling-v2beta2 on Kubernetes 18.0](https://github.com/instrumenta/kubernetes-json-schema/blob/master/v1.18.0-standalone/horizontalpodautoscaler-autoscaling-v2beta2.json)**

> **NOTE:** Need to get your Kubernetes version? `kubectl get nodes` should show ya that one.

We can also simply pull in the resource from their repo in raw JSON format. This generic script to download the JSON schema. Use any number of open source tools to convert to yaml or markdown if that suits your fancy.

```bash
KUBEVER=1.18.0
KIND=horizontalpodautoscaler
RESOURCE=autoscaling
RESOURCEVERSION=v2beta2

tempdir=`mktemp -d`
curl --retry 3 --retry-delay 5 --fail -sSL -o ${tempdir}/${KIND}-${RESOURCE}-${RESOURCEVERSION}.schema.json https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v${KUBEVER}-standalone/${KIND}-${RESOURCE}-${RESOURCEVERSION}.json
```

## Additional Resources

There are a many resources available on this topic. Here are a few that I found most valuable.

- [Kubernetes Core Documentation](https://kubernetes.io/docs)
- [Kubernetes Generated API Documentation](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#-strong-api-overview-strong-)
- [Kubernetes Swagger JSON (current)](https://raw.githubusercontent.com/kubernetes/kubernetes/master/api/openapi-spec/swagger.json)
- [JSON Created Schema](https://kubernetesjsonschema.dev)

## Conclusion

The Kuberentes API is an ever changing multi-headed hydra but since it has a well defined schema intrepid developers and hackers have come up with good helper interfaces for getting information out of it more effectively.