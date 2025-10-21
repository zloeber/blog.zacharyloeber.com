---
title: "Create Terraform with AI and Github Copilot"
date: 2025-10-20T11:43:11-05:00
featuredImage: /images/banners/android-worker-banner.png
Permalink: /blog/2025/10/20/create-terraform-with-ai-and-github-copilot/
categories: ["terraform", "ai", "mcp"]
tags: ["terraform", "ai", "agentic", "mcp", "copilot", "terraform"]
toc: true
draft: false
author: "Zachary Loeber"
---

Creating terraform or other infrastructure as code for a new project can be daunting for some. This shows how you can easily crank out a new deployment to meet your requirements using Github copilot prompt files and a few free MCP servers. For the heck of it, we will also convert between two totally different cloud providers to deploy the same infrastructure.

<!--more-->

## Introduction

Github copilot is getting more powerful with each update and I've been enjoying using it quite a bit to write quick scripts and even initializing whole project repositories for me. But I've never been very impressed with it (or any other LLM's) ability to create solid terraform. I've been exploring model context protocol (MCP) servers quite a bit lately and figured perhaps they can augment an agent with enough additional capabilities to upset me less with their terraform tasks. Turns out that providing Copilot with the right tools can really amplify its results!

## The Setup

I'm using Github Copilot in VSCode along with several MCP servers for this exercise. You can setup a project locally with MCP servers easily enough by creating a file named `./.vscode/mcp.json` in your project. Here is what mine looks like:

```json
{
  "servers": {
    "sequential-thinking": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-sequential-thinking"
      ],
      "type": "stdio"
    },
    "server-filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "."
      ],
      "type": "stdio"
    },
    "terraform": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "hashicorp/terraform-mcp-server"
      ],
      "type": "stdio"
    },
    "mcp-feedback-enhanced": {
      "command": "uvx",
      "args": ["mcp-feedback-enhanced@latest"]
    },
    "aws-knowledge": {
        "url": "https://knowledge-mcp.global.api.aws",
        "type": "http"
    },
    "azure-knowledge": {
      "url": "https://learn.microsoft.com/api/mcp",
      "type": "http"
    },
  },
  "inputs": []
}
```

These are the MCP servers used:

| Server | Purpose |
|---|---|
|sequential-thinking | Very popular MCP for helping an LLM organize its thoughts |
|server-filesystem | Reading/writing to the filesystem |
|terraform | Terraform best practices and provider documentation lookup |
|mcp-feedback-enhanced | (Optional) User feedback forms for more interactive data gathering from the user |
|aws-knowledge | Official AWS online knowledge datastore |
|azure-knowledge | Official Azure online knowledge datastore |

I don't let my MCP servers always run. If you want to start them you can open up the mcp.json file in the editor and above each of the definitions there is a little start button you can click on to get it going.

> **NOTE** mcp-feedback-enhanced is optional because I believe copilot will handle interfacing with you on questions just fine. But I recognize that I personally am not always going to be using Copilot for my solutions and wanted to use a less vendor locked solution. I'm also simply interested in human-in-the-loop MCP servers and this one was the best of three I tested out.

## The Prompts

To create a re-usable interface you can use [Github Copilot prompt files](https://docs.github.com/en/copilot/tutorials/customization-library/prompt-files/your-first-prompt-file) in your project by creating them in the `./.github/prompts/` folder with a name like `*.prompt.md`. Once created you can kick them off at anytime in the Copilot agent chat window with a `/<prompt>` command.

Here is one I created to walk a user through creating an AWS terraform deployment from scratch.

```
---
mode: 'agent'
description: 'Create AWS terraform code for given requirements with interactive feedback.'
---

Create AWS Terraform code for the following requirements with step-by-step reasoning and interactive feedback:

Requirements: ${input:requirements:What infrastructure do you need? Please be as detailed as possible.}

Use the interactive_feedback tool to gather any additional necessary information from the user to refine their requirements.

Use the aws-knowledge MCP tool to ensure accuracy and best practices in AWS services and Terraform code.
Use the terraform-mcp-server tool to generate the Terraform code to meet the refined requirements for AWS infrastructure.
Output the final Terraform code only after confirming all requirements with the user, including any refinements made through interactive feedback.
Include a markdown file with all the requirements gathered along with any you have inferred along with the final Terraform code.
Refine all infrastructure requirements to be AWS-specific and aligned with best practices, security, and compliance standards. Be thorough and detailed in your analysis.
If you need to gather more information from the user to refine the requirements, use the interactive_feedback tool to ask clarifying questions before generating the code.

Rules:
    - Terraform should be written using HCL (HashiCorp Configuration Language) syntax.
    - Use the latest AWS provider version compatible with the required resources.
    - Follow best practices for Terraform code structure, including the use of variables, outputs, and modules.
    - Ensure that the generated code is well-documented with comments explaining the purpose of each resource and configuration.
    - Always try to use implicit dependencies over explicit dependencies where possible in Terraform.
    - When generating Terraform resource names, ensure they are unique and descriptive, lower-case, and snake_case.
    - Be sure to include any necessary provider configurations, backend settings, and required variables in the generated code.
    - Ensure the generated terraform code always includes a top level `tag` variable map that is used on all taggable resources, with at least the following tags: `Environment`, `Project`, and `Owner`.
    - Ensure that sensitive information such as passwords, API keys, and secrets are not hardcoded in the Terraform code. Use variables and secret management solutions instead.
    - Do not assume any prior knowledge about the user's AWS environment; always seek clarification when in doubt.
    - Do not ask for AWS specific information like instance types, instead focus on high level requirements and attempt to map them to AWS services for the user.
    - Before finalizing the Terraform code, always confirm with the user that all requirements have been accurately captured and addressed.
    - All output should be created in the `output/aws/` directory with appropriate filenames.
```

And one for Azure.

```
---
mode: 'agent'
description: 'Create azure terraform code for given requirements with interactive feedback.'
---

Create Azure Terraform code for the following requirements with step-by-step reasoning and interactive feedback:

Requirements: ${input:requirements:What infrastructure do you need? Please be as detailed as possible.}

Use the interactive_feedback tool to gather any additional necessary information from the user to refine their requirements.

Use the azure-knowledge MCP tool to ensure accuracy and best practices in Azure services.
Use the terraform-mcp-server tool to generate the Terraform code to meet the refined requirements for Azure infrastructure.
Output the final Terraform code only after confirming all requirements with the user, including any refinements made through interactive feedback.
Include a markdown file with all the requirements gathered along with any you have inferred along with the final Terraform code.
Refine all infrastructure requirements to be Azure-specific and aligned with best practices, security, and compliance standards. Be thorough and detailed in your analysis.
If you need to gather more information from the user to refine the requirements, use the interactive_feedback tool to ask clarifying questions before generating the code.

Rules:
    - Terraform should be written using HCL (HashiCorp Configuration Language) syntax.
    - Use the latest Azure provider version compatible with the required resources.
    - Follow best practices for Terraform code structure, including the use of variables, outputs, and modules.
    - Ensure that the generated code is well-documented with comments explaining the purpose of each resource and configuration.
    - Always try to use implicit dependencies over explicit dependencies where possible in Terraform.
    - When generating Terraform resource names, ensure they are unique and descriptive, lower-case, and snake_case.
    - Be sure to include any necessary provider configurations, backend settings, and required variables in the generated code.
    - Ensure the generated terraform code always includes a top level `tag` variable map that is used on all taggable resources, with at least the following tags: `Environment`, `Project`, and `Owner`.
    - Ensure that sensitive information such as passwords, API keys, and secrets are not hardcoded in the Terraform code. Use variables and secret management solutions instead.
    - Do not assume any prior knowledge about the user's Azure environment; always seek clarification when in doubt.
    - Do not ask for Azure specific information like instance types, instead focus on high level requirements and attempt to map them to Azure services for the user.
    - Before finalizing the Terraform code, always confirm with the user that all requirements have been accurately captured and addressed.
    - All output should be created in the `output/azure/` directory with appropriate filenames.
```

If you are ready to bootstrap either an AWS or Azure terraform project via Copilot go ahead and do so using the prompt. This starts the process for an Azure based terraform project `/terraform-azure-bootstrap`. It will start by asking what you want then ask you refining questions to figure out what needs to be created. You do not need to close the feedback window that comes up, it will automatically be reused and refresh its contents when it needs further information or approval from you.

## Additional Prompts

For they heck of it I also created a few more prompts that can be used to convert a terraform project from Azure to AWS and vice versa. These use the same MCP servers but with different prompts. I'll let you look at the examples I constructed for each in the [Github repo](https://github.com/zloeber/terraform-copilot-prompts) for this exercise. I created two fictitious projects off the top of my head, one for AWS and another for Azure. I then used the conversion prompt for each to create the equivalent project for the other cloud provider.

## Pleasant Surprises

When it works the way I want AI can be extremely satisfying to wield. This is even more so when it yields more than what you asked for. In this case I found that:

- For the managed kubernetes deployment it generated functioning `Makefile`s with a plethora of commands that are useful to the deployment.
- The terraform conversion between one provider and another included cost comparisons between the two deployments.
- The feedback tool used can remain open and be used for all prompts back and forth between the agent.
- The requirements.md generated is quite comprehensive and additive to the deployment for user comprehension.
- Both the AWS and Azure MCP servers were easily used by the Agent with very little extra prompting.
- For the virtual machines I put in some rather complex logic for how I wanted the disks done and was surprised to find that the appropriate `user-data.sh` bash script for AWS and `cloud-init.yml` file for AWS was created for me not only with the disks done as I had requested (LVM and mounted to `/opt`) but much more. For instance, it also generated a pretty decent nginx deployment for wordpress, test scripts for cloud storage access (that I purposefully included as requirement to try to trip things up), and cloud specific agent installs for disk and memory monitoring. Pretty slick!
- There was a corpus of additional documentation included with both example deployments that included a good deal of extra info that I might personally include in a project were I delivering it to a team to manage. 

## Irksome Things

The results are not all positive. I have a few minor gripes as well.

- An abundance of emojis while visually pretty to see just screams LLM generated to the trained eye. Can probably reduce their use with minor prompt adjustments.
- The nondeterministic nature of LLMs means results for documentation were wildly different between each project. I specifically requested requirements.md be generated in the bootstrap process but forgot to say anything about it in the migration prompts. The first example I migrated from AWS to Azure left the file mostly in tact. The second example migration from Azure to AWS created a 500+ line operational guide out of it (which was cool and all, but still makes my point here).
- As mentioned before this can chew through your premium tokens pretty quickly depending on your requirements.

## Conclusion

So would I use any of this terraform without reviewing it first? Of course not. Heck, it probably wouldn't even run without some modifications. But I certainly would use it to get things started for a project. It produces quite clean and easy to read terraform with the correct naming conventions, variables, and documentation to get things off to a very nice start. I will not use it to scaffold out every project I do though. This is mainly because it does seem to burn through premium tokens which I'd rather use for more complex work. I'm on a standard plan and creating the 4 examples you can find in the project repository ate almost 10% of my premium tokens.

This combo of MCP servers is quite good at overcoming some of AI's issues with building proper terraform as well. I'm quite happy that this is the case as repeated bizarre LLM results on terraform generation was starting to get upsetting. Next up, an MCP server that will allow you to use your own organizational modules. I'm hoping to have such a tool ready to test out next month sometime (if anyone already has one please reach out to me so I can collaborate with ya!).