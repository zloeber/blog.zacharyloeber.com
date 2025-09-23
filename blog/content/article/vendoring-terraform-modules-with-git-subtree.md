---
title: "Vendoring Terraform Modules With Git Subtree"
date: 2025-08-04T22:46:31-05:00
draft: false
featuredImage: "/images/blog/gears.png"
Permalink: /blog/2025/08/04/vendoring_terraform_modules_with_git_subtree/
categories: ["devops", "git", "terraform", "cicd"]
tags: ["terraform", "cicd", "devops", "git"]
toc: true
author: "Zachary Loeber"
---

In this article I'll go over a less obvious way to vendor in outside modules into your terraform code base.

<!--more-->

# Vendoring Terraform Modules with Git Subtree

(When I do it and why you probably shouldn't)

Did you know you can vendor in third-party terraform modules in your projects?

> **NOTE** Yes, I said **vendoring**. As in, **copy the code entirely into your repo** and commit it.

Before you close the tab and scream "but module versioning exists!", let me explain why this technique may actually *reduce* complexity and increase reliability in some situations. 



## Why Vendor a Terraform Module?

Third-party Terraform modules are great. You can drop in complex constructs like AWS RDS Clusters, managed Kuberenetes clusters, and more in seconds. But let’s be real: there are some pretty big drawbacks when you're pulling them from the Terraform Registry or directly from random repos in GitHub.

Here’s what I’ve run into over the years:

- **Production code relying on external availability.** If the registry or GitHub is down, the deploys start to fail.
- **Unexpected upstream changes.** Even with version locking, changes in behavior or provider requirements can break you.
- **You can't patch them.** Need to tweak something? Good luck unless you're forking or building awkward workarounds.
- **Regulated environments.** Auditors don’t love "we download random GitHub code at deploy time."

So instead, you can **vendor** them using `git subtree`. This gives all the benefits of module reuse, while still retaining full control of what goes into your infrastructure codebase.

## Why Not Git Submodules?

I'm not a fan of git submodules for a number of reasons;

- You must manually initialize, clone, update, and sync submodules.
- Running git pull doesn't update submodules—you need to run git submodule update --recursive explicitly.
- CI/CD pipelines may fail if submodules are not cloned and initialized properly.
- If you make changes to a submodule, you must push them to that repo before updating the parent.
- You can not easily snapshot or modify the submodule locally without committing upstream.
- Anyone consuming the repo outside of Git CLI—like designers, PMs, or documentation writers can run into confusing issues when working with submodules.

Unless you're very comfortable with Git internals and have strong reasons to use submodules, it's generally better to avoid them. They create more friction than value in most projects, especially for teams.

Alternatively, `git subtree` gives most of the value of submodules with fewer drawbacks.
- No extra commands to clone/update.
- Works out of the box for all contributors and CI.
- (Arguably) Easier to track changes and revert.
- Self-contained in your repository.

## The Case *Against* Vendoring

Let’s be clear: this is not for everyone.

If you're working in a fast-moving team and author all your own modules then it is likely you have little concern for Terraform Registry outages or upstream git repos being unreachable. Thus, you would have few reasons to to vendor your terraform modules.

**Don’t vendor with git subtree** if:
- You're happy with the module ecosystem as-is.
- You don't have auditing or reproducibility concerns.
- You want easier updates and don't want to deal with subtree merges.

But if you're building critical infrastructure with carefully reviewed third-party modules and you want full reproducibility and the ability to patch upstream code? This is for you.

## A Fully Working Example: Vendoring the AWS VPC Module

Let’s say we want to vendor in the popular [terraform-aws-vpc](https://github.com/terraform-aws-modules/terraform-aws-vpc) module.

### 1. Pick a place for vendored modules

I like to keep them in a `modules/` directory:

```bash
mkdir -p modules && cd ./modules
```

### 2. Add the upstream module as a remote

```bash
git remote add tf-vpc https://github.com/terraform-aws-modules/terraform-aws-vpc.git
git fetch tf-vpc
```

### 3. Add it as a subtree

This will copy version 5.1.0 into modules/vpc:

git subtree add --prefix=modules/vpc tf-vpc v5.1.0 --squash

You now have a full copy of the module in your repo.

### 4. Use it locally in Terraform

In your Terraform configuration:

```bash
module "vpc" {
  source = "./modules/vpc"

  name = "my-vpc"
  cidr = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}
```

No more external downloads. No more surprises.

### 5. Updating the Module

Later, if version 5.2.0 is released and you want to upgrade:

```bash
git fetch tf-vpc
git subtree pull --prefix=modules/vpc tf-vpc v5.2.0 --squash
```

This brings in the latest changes. You can review them like any other code change in a pull request.

### 6. Bonus: Patch Locally

Want to fix something or adjust behavior? Just edit the code directly in modules/vpc. No forking, no hacks.


## Summary: The Tradeoff is Simplicity vs Control

Vendoring Terraform modules using git subtree is a tradeoff. It gives you complete control, full auditability, and the ability to run Terraform without internet access. But it does require you to manage updates manually.

In environments where stability, reproducibility, and compliance matter more than bleeding-edge updates getting your terraform (and all code for that matter) vendored is important and should be done.

Otherwise, stick with the registry or direct git module references which should be good enough for most teams.


## Appendix: Subtree Cheat Sheet

|Action|Command|
|---|---|
|Add remote	|`git remote add <name> <url>`|
|Add subtree| `git subtree add --prefix=<path> <remote> <branch-or-tag> --squash`|
|Update subtree|`git subtree pull --prefix=<path> <remote> <branch-or-tag> --squash`|
|Push upstream|`git subtree push --prefix=<path> <remote> <branch>`|