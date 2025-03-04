---
title: "Kubernetes Archetype Pattern"
author: "Zachary Loeber"
date: 2020-05-10T10:27:05-05:00
categories:
  - devops
  - Kubernetes
tags: 
  - devops
  - Kubernetes
  - helm
  - pattern
  - ingress
featuredImage: "/images/banners/banner-hand-puzzle-pieces-750x250.jpg"
Permalink: _/blog/2020/05/kubernetes-archetype-pattern/_/
draft: true
---
Using monocharts in an archetype pattern can help reduce future technical debt in your Kubernetes deployments.
<!--more-->

## First Things First

Helm is one of many tools for rendering and applying arbitrary deployment templates into Kubernetes. Professionals in DevOps seem to be very opinionated about using the tool. While I've personally been turned off by helm 2 and its persnickety tiller requirements (and security implications therein) I still used it successfully to accomplish many tasks. This is largely because;

- Helm charts allow for creation versioned immutable deployment artifacts
- It is nominal to include simple post-deployment testing with helm
- One can vastly simplify their deployment code surface area of support by having most of the deployment code in a central repository

In this article I'm going to make the case for a pattern that I found works very well when supporting several common Kubernetes application stacks within an organization. I use helm for this pattern as it seems to have been almost built for this kind of pattern.

## The Archetype Pattern

The dictionary [definition of archetype](https://www.merriam-webster.com/dictionary/archetype) is, "the original pattern or model of which all things of the same type are representations or copies". And this is a great starting point for defining this pattern. For a more technical take on this word, we look to object oriented programming where one would use an **[archetype](https://en.wikipedia.org/wiki/Archetype_pattern)** to separate logic from implementation.

Having personally stitched together Kubernetes technical stacks for projects I can think of a few areas where the application deployment logic at the tail end of a CICD pipeline might benefit from being separated from the implementation within a Kubernetes cluster. For instance, if your project starts out with nginx-ingress but later on evolves to a full blown Istio service mesh deployment which uses its own ingress CRDS it would be nice to not have to convert 50 microservice deployments to start using Istio gateways with virtualrouters. Floating the ingress deployment manifest code into a top level monochart which then derives the appropriate YAML to deploy via an application subchart would be using the archetype pattern.

Our Kubernetes specific definition for the archetype pattern will be; "Using a single top level, mutable, set of deployment manifests for deriving all application deployments."

This top level set of common deployment manifests will be stored in one helm chart which we will call the 'archetype' or 'mono' chart.

> **NOTE** The monochart name comes from the inspiration for this blog post, CloudPosse's own publicly released **[monochart](https://github.com/cloudposse/charts/tree/master/incubator/monochart)**.

## The Use Case

There are several use cases for this pattern. As already mentioned, ingress is an ideal starting point for additional abstraction. Choosing an ingress controller may be one of the first real Kubernetes decision you will have to make on a project. When deploying ingress controllers it can be easy to pigeonhole yourself into a corner because each controller has their own specific nuances that you will need to adopt. Many include their own CRDs and don't even use the standard ingress resource api definitions.

With a well thought out archetype pattern, one can later swap out ingress controllers from nginx-ingress to traefik or istio ingress with far less effort. I know, I've personally done so for a project.

Some other use case scenarios might include;

- Wanting to deploy specific annotations for each ingress (or any resource) that can be used by other elements in your cluster to provide additional functionality (such as prometheus scraping).
- Selecting a certificate issuer based on some element in the deployment.
- Service port deployment standardization
- Automatic labeling of resources that includes a team name, project, workload, et cetera...

Also, the greatest use case scenario I can think of is an overwhelmed DevOps team can reduced their overall surface area for supporting multiple similar application workload deployments by centralizing the deployment code into one repository.

## The Chart

There is no strict definition as to what an archetype should contain. A good rule of thumb would be to have one archetype chart per Kubernetes cluster profile in your organization. Here is a table of how a more fragmented organization might have multiple Kubernetes cluster 'profiles'.

| Cluster Type | Purpose | Deployed Stacks |
|---|---|---|
| Internet Facing - Web | Customer facing microservices | Istio base, Istio Ingress, Istio Egress, Fluentbit, Vault Operator, Cert-Manager |
| Internal - Web | Business facing microservices | Traefik, DataDog Agent |
| Backend - Kafka | Confluent Kafka Stack | Kafka Operator, Prometheus Operator, Azure KeyVault Integration, Cert-Manager, No Ingress |

> **NOTE** Having a single cluster profile with pre-determined organization supported components reduces the operational overhead, complexity, and technical debt. Just sayin'

The chart itself should have the ability to deploy most custom workloads into any given cluster profile. Since this chart will not replace upstream deployments (like the Prometheus Operator for example) there is no reason to overdo things. If starting from scratch, perhaps start with `helm create` to baseline a deployment chart and build up from there. Update the helm chart so that you can systematically piecemeal together deployments that include everything your organization may wish to deploy. Include prometheus rules, sidecars, ingress definitions, anything that may require custom CRDs, common microservice ports, and anything else that is specific to your project and environment. I create my archtype chart in a way so that a default values.yaml chart deployment does not actually deploy anything.

I highly recommend looking at CloudPosse's monochart for inspiration. I've also created my own version of this chart that has evolved over the last year or so that I've become fond of using as well. Links to both are in the resources section at the bottom of this article.

## A Practical Example

A partial example of how this might work can be found in my KubeStich project. I use my own archetype chart extensively to deploy ingress separately from any upstream chart I deploy in this project. Because I'm religious about keeping ingress as a separate deployment, I can deploy ingress for Prometheus backed by Traefik using almost the same declarative code as when I deploy the same ingress backed by Istio.

```bash
## helmfiles/helmfile.prometheus-operator.yaml archetype chart values excerpt
  values:
  - app: grafana
    dnsRoot: {{ .Values | getOrNil "dnsRoot" | default "micro.svc" }}
    zone: {{ .Values | getOrNil "prometheusoperator.zone" | default "internal" }}
    ingress:
      enabled: true
      tlsEnabled: true
      hosts:
      - name: grafana
        secretName: po-grafana-ingress
        config:
          http:
            paths:
            - path: "/"
              backend:
                serviceName: po-grafana
                servicePort: 80
```

Above you can see a single ingress being created for the po-grafana service for a prometheus operator deployment. Note that I am using some helmfile specific scaffolding in this example for the zone and dnsRoot elements, but it should be easy enough to read.

```bash
## helmfiles/helmfile.istio.yaml archetype values excerpt
- app: istio
  dnsRoot: {{ .Values | getOrNil "dnsRoot" | default "micro.svc" }}
  zone: {{ .Values | getOrNil "istio.zone" | default "internal" }}
  istio:
    gateway:
      enabled: true
  ingress:
    enabled: true
    type: istio
    hosts:
    - name: prometheus
      paths:
      - path: "/"
        backend:
          serviceName: prometheus
          servicePort: 9090
    - name: kiali
      paths:
      - path: "/"
        backend:
          serviceName: kiali
          servicePort: 20001
    - name: grafana
      paths:
      - path: "/"
        backend: 
          serviceName: grafana
          servicePort: 3000
```

The above istio ingress example almost mirrors that of the prometheus operator example but I also include the prometheus and kiali ingress. You will see that with istio we enable a gateway as well as the Istio virtualservices require one. Because it is enabled but not defined in further down ingress definitions, the default behavior in the archetype chart is to have each virtualservice (prometheus, grafana, kiali) use the same istio gateway.

In both examples ee use the power of a standardized chart to derive the host url automatically using dnsRoot and a zone definition. The zone definition is for exposing internal, external, or staging zone based on simple top-level class definitions.

This vastly simplifies all future chart deployments as we can use the same general format to expose ingress but take different actions based on `ingress.type` (which is 'standard' by default). As long as we consistently use the archetype chart, a future migration to another ingress controller becomes a much simpler affair.

## Archetype Descendants

Under most circumstances I would not recommend leaning on subcharts within Helm. But there is value in using them in an archetype pattern. Using the archetype chart as a dependency we can standardize particular deployment elements for a project or target cluster profile pretty easily. Let's use an example to show how this can be used to abstract a deployment.

I've created an example descendant chart that uses the archetype chart as a dependency. 

```bash

```



## Resources

**[An Archetype Chart Example](https://github.com/zloeber/archetype-chart)** - An example archetype chart.

**[A Descendant Chart Example](https://github.com/zloeber/descendant-chart)** - A descendant chart example

**[KubeStich Project](https://github.com/zloeber/KubeStich)** - Can be used to deploy all examples in this article

**[CloudPosse's Monochart](https://github.com/cloudposse/charts/tree/master/incubator/monochart)** - The original archetype chart

**[DRY Helm Charts for Micro-Services](https://medium.com/faun/dry-helm-charts-for-micro-services-db3a1d6ecb80)**

**[Helm](https://helm.sh)**

**[Helmfile](https://github.com/roboll/helmfile)**
