---
title: "Pre-Cache Terraform Provider Plugins"
date: 2025-03-19T11:29:36-05:00
draft: false
categories: ["devops", "terraform", "docker"]
tags: ["devops", "terraform", "docker", "cicd", "optimization"]
toc: false
author: "Zachary Loeber"
featuredImage: "/images/blog/backlit_keyboard.jpg"
---

Pre-caching terraform providers in your CICD pipeline images is awesome but hardly anyone does it. I've created a project that makes this task easier than ever.

<!--more-->

## Why

In a very active platform as a service inside a larger organization you can see hundreds if not thousands of pipelines being run in a day for various terraform provisioning. This can add up to quite a bit of network activity and time wasted downloading the same terraform providers over and over again. But terraform is pretty smart and will not redownload provisioners that already exist in the local plugin cache. Pre-caching these can be beneficial for two main reasons

1. Reduce provisioner pipeline run time - Eliminates the near constant re-downloading of these external binary packages from the terraform registry.
2. Reduce external dependencies - The terraform registry has gone down at least 1 time in the last few years. This causes an unresolvable provisioning outages.

## How

I've created [a project](https://github.com/zloeber/terraform-cicd-image) that includes a Dockerfile and some scripts that process a yaml file that contains target git repos (and any subpaths) that the image would be used within. When built, this image will:

  - Pre-cache providers for the defined target git projects/folders
  - Install multiple versions of the terraform and other binaries via [mise](https://mise.jdx.dev).

## Usage

Clone [this repo](https://github.com/zloeber/terraform-cicd-image) into your organization then make updates as needed:

1. Update the `config/provisioners.yml` file with all of your downstream terraform provisioning projects, their branches, and target folders that will be processed.
2. Update the `mise.toml` file to include terraform and other binary versions you wish to have included.
3. Add CICD pipeline code for your organization to build and push your image. 

> **NOTE** The order of versions in `mise.toml` matter. The first one in the list will be used by default. See the [configuration of mise](https://mise.jdx.dev/configuration.html) for more details on this wonderful tool.

## Manual Providers

If you need to include latest versions of a provider or have a need to manually define one, you can easily do this as well. Edit the local `config/provisioners.yml` file and add a local path that contains a terraform `version.tf` file within the local `config` directory. Examples are provided in this project (that can be removed if you do not need them)

## Local Testing

To see how this will work you can run everything locally using the included taskfile tasks within.

`task providers`

This should produce a local `tempproviders` folder with all of the plugins for your downstream terraform provisioners.

Additionally, helper tasks for building and shelling into the container image are included.

```bash
task docker:build docker:shell
```

## Conclusion

Shaving off 10 seconds per pipeline may seem like a fool's errand but the benefits from such an exercise are hard to ignore. Eliminating external dependencies while speeding up your frequently used pipelines should always be in you scopes when engineering your solutions.