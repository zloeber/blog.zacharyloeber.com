---
title: "Aws Testing With Localstack on Kubernetes"
author: "Zachary Loeber"
date: 2020-05-21T09:22:20-05:00
categories:
  - devops
  - aws
  - kubernetes
tags: 
  - devops
  - aws
  - kubernetes
  - docker
  - localstack
  - helmfile

featuredImage: "/images/banners/banner-dominoes-750x188.jpg"
Permalink: _/blog/2020/05/aws-testing-with-localstack-on-kubernetes/_/
draft: false
---
Testing out your AWS DevOps tricks in a local Kubernetes instance with localstack is pretty easy to do.

<!--more-->

## Introduction

**[Localstack](https://github.com/localstack/localstack)** is a Python module that makes a good portion of AWS available locally. It is something you might use to quickly vet out infrastructure as code, boto3 scripts, or AWS cli hacks without the worry of affecting your subscription's bill or services.

The default deployment instructions for localstack include running locally via pip and Python or by using docker-compose. Because I've taken a silent vow to run all things on local Kubernetes instead wherever possible I converted it to run locally on a kind cluster instead.

## The Conversion Process

One can use kompose to convert a docker-compose file into Kubernetes manifests then apply the results to a cluster. So first **[download kompose](https://kompose.io/installation/)** for your OS. 

Once you have kompose, the trick to converting the localstack compose file into manifests is updating the source docker-compose.yaml file from version 2.1 to 3 manually before running the conversion process.

You do not need the entire localstack git repo to do any of this, simply grab a copy of the compose file, modify, then convert it.

```bash
mkdir localstack && cd localstack
wget https://raw.githubusercontent.com/localstack/localstack/master/docker-compose.yml
sed -i 's/2.1/3/g' docker-compose.yml
kompose convert
rm ./docker-compose.yml
```
The result will be a set of 4 yaml files, 2 with persistent volume claims, 1 with a deployment, and 1 with a service.

The default compose file exposes a ton of ports that are no longer required (per its own documentation). As such, I removed all but ports 8080 and 4566 from the definitions.

When that has been done you can apply it to any cluster to get things working:

```bash
kubectl create ns localstack
kubectl -n localstack apply -f ./
```

This works well but does not expose the services via ingress and is not extremely reusable. As such I converted it **[into a helmfile](https://github.com/zloeber/CICDHelper/blob/master/helmfiles/helmfile.localstack.yaml)** and dropped it into my own little Kubernetes DevOps stitching framework.

## My Framework

It took about 15 minutes or so for me to convert this project to run in a local kind cluster using helmfiles and make commands instead. You can find the helmfile with the rest of my **[CICDHelper](https://github.com/zloeber/CICDHelper)** along with a new profile aptly called 'localstack'. 

The localstack profile defines a new cluster name. When doing this I also create a `helmfiles/helmfile.cluster.<clustername>.yaml` file with all the helmfile stacks to apply to make the solution a whole. This allows for me to simply run one command to bring up the entire test environment.

```bash
git clone https://github.com/zloeber/CICDHelper
cd CICDHelper
export PROFILE=localstack
make cluster/start helmfile/sync dnsforwarding/start
```

When this has been run the local kind cluster will be running localstack with ingress exposing both the dashboard (http://localstack-dashboard.int.micro.svc) and the service endpoint (http://localstack.int.micro.svc) on port 80.


```bash
## Create a new s3 bucket then list it in localstack
aws --endpoint-url=http://localstack.int.micro.svc s3api create-bucket --bucket my-bucket --region us-east-1
aws --endpoint-url=http://localstack.int.micro.svc s3 ls
```

You can view the created resource in your dashboard as well.

{{< figure src="/images/localstack-dashboard.jpg" alt="Example s3 bucket created locally in localstack!" >}}


The dns forwarding is a nice way to access things via URL instead of IP. But you can use the IP as well if the dnsforwarding gives you issues or isn't working for your platoform. To get the IP assigned to the loadbalancer use `make kube/loadbalancer/ip`



## Conclusion

Localstack is a pretty sweet API interface into a good deal of the AWS offerings that, with some minor effort, you can run locally in a Kubernetes cluster.


## Resources

**[Localstack](https://github.com/localstack/localstack)** - A local AWS environment and API

**[Kompose](https://kompose.io/)** - Convert docker compose files to Kubernetes manifests

**[CICDHelper](https://github.com/zloeber/CICDHelper)** - My own kubernetes devops stitching framework

