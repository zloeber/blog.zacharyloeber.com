---
title: "Terraform Custom Module MCP Server"
date: 2025-10-22T21:48:03-05:00
featuredImage: /images/banners/robot_puzzle.png
Permalink: /blog/2025/10/22/terraform-custom-module-mcp-server/
categories: ["terraform", "ai", "mcp"]
tags: ["terraform", "ai", "agentic", "mcp", "copilot"]
toc: true
draft: false
author: "Zachary Loeber"
---

I created an MCP server that streamlines access to custom Terraform modules that I'd like to share with the community. The project called [terraform-ingest](https://github.com/zloeber/terraform-ingest) is a CLI, MCP, and API tool that can be used locally or with an AI agent to tap into your existing code base more effectively.

<!--more-->

## The Problem

I looked high and low for a model context protocol server I could use as an interface to the several dozen custom Terraform modules I've created. My search was futile so I spent a few cycles and just made my own. With [this solution](https://github.com/zloeber/terraform-ingest) you can use a simple YAML file to define all your custom Terraform modules git sources. These are then ingested to extract and index all relevant information for embedding into a vector database. From here you can use this tool as a CLI, API, or MCP server to find  modules that best suit your needs and weave them together to create organizational compliant infrastructure as code!

[Model Context Protocol](https://modelcontextprotocol.io/docs) is the wildly popular interface for AI agentic workloads. I've written about how to use existing MCP Servers to augment AI for vast improvements in its ability to [clean up crappy](https://blog.zacharyloeber.com/article/cagent-terraformer-rewrite/) and even [author new](https://blog.zacharyloeber.com/article/create-terraform-with-ai-and-github-copilot/) Terraform. This works quite well for non-modular code. But it lacks the ability to interface with the many custom modules I've personally created for the teams I've worked with. And while I've created [tools](https://github.com/metagit-ai/metagit-cli) to help manage multi-git project repositories as a single virtual monorepo it still is hard, even for me, to consistently know the right variables and outputs for the modules needed for any given solution. What we all need is an MCP server that better aggregates several dozen terraform modules (both as single projects or recursively as monorepo projects) into one managed source of truth.

## The Solution

A [RAG](https://en.wikipedia.org/wiki/Retrieval-augmented_generation) ingestion pipeline for Terraform modules is how I envisioned a solution for these issues. It makes sense to pull in and ingest key information about each targeted module, interested versions, providers, and target paths. We can accomplish this with some simple git cloning, hcl parsing, and then finally vectordb embedding of the generated json that summarizes each module for similarity searching.

## How It Was Built

In this case the solution was built in a few rounds using AI for heavy lifting and scaffolding in this general order:

- Create a YAML definition and click cli interface with FastAPI server to allow for the ingestion of one or more git repos of terraform modules into a local json file, one per-target git branch or tag.
- Add a FastMCP interface for searching through the results.
- Add the embedding of this data into a local vector database using an embedding method of your choice (starting with chromadb and local but less precise embedding but including ollama or external embedding if so desired).

In between these steps at various points I added in the following:

- Multi-stage docker images
- A bunch of gitlab pipelines, publishing to Pypi, better unit tests, semantic releases, et cetera
- hatch-vcs for build and automatic versioning
- mkdocs based static website generation for docs
- Minor refactors from what got generated for me to be more cohesive to the way I like to have my Python apps
- Additional MCP dynamic resources and prompt template generation
- Lazy-loading of bulky dependencies

## Use Cases

[This project](https://github.com/zloeber/terraform-ingest-example) includes a practical configuration example that encompasses all the modules for a team of Terraform professionals I happen to hold in the highest regards, [Cloudposse](https://github.com/cloudposse/). They have produced almost 200 high-quality open source AWS terraform modules. You can look at this example project to get more information on how to generate and then ingest such a configuration. The configuration file has hundreds of entries like the following:

```yaml
...
- name: aws-access-analyzer
  url: https://github.com/cloudposse-terraform-components/aws-access-analyzer.git
  recursive: false
  branches: []
  include_tags: true
  max_tags: 1
  path: ./src
  exclude_paths: []
...
```

Once you have ingested the modules to a local cache and embedded to a vector database it is easy to search without any AI.

```bash
# Retrieve the top 5 similar results using the vectordb search
terraform-ingest search "API Gateway Lambda integration" -l 5

# Get all the details about the top search result for 'vpc module for aws' (requires jq)
terraform-ingest search "vpc module for aws" -l 1 -j -c ./.vscode/cloudposse.yaml | jq -r '.results[0].id' | xargs -I {} terraform-ingest index get {}
```

The cli also includes the ability to directly call exposed MCP tools.

```bash
terraform-ingest function exec get_module_details --arg repository "https://github.com/cloudposse-terraform-components/aws-api-gateway-rest-api.git" --arg ref "v1.535.3" --arg path "src" --output-dir ./output
```

## Use Cases

Some possible use cases include (but are not limited to):
- On-demand module documentation and example generation
- Query your authored modules via any LLM
- Module upgrade planning and risk analysis
- Greenfield deployment using your own organization's modules
- Running a self-updating internal MCP server for inline validation of module use via any internal agent


## Lessons Learned

I learned a few things about developing an MCP server for RAG that are worth mentioning.

### STDIO Is Goofy

This is the default mode many run local MCP servers in. The name says it all, it uses stdio output streams to communicate with the server. As such, you want to prevent superfluous output to the console when running in this mode otherwise MCP clients will get confused and start having JSON serialization errors.

STDIO mode is just a local process that gets kicked off on behalf of the MCP client. If you want to speed things along you probably don't want to be running long running imports or embeddings when you start your app. Including a means of pre-processing long running workflows helps get around this. In my case I include a cli that can be used to do the needful for terraform-ingest before starting the MCP services.

### Local Embedding Is Heavy

Using local vector databases and embeddings is really nice for development. But they are also quite large dependencies that can add multiple GB to your distribution. This makes for large Docker images and pypi downloads. More importantly, it really really drags out your CICD pipelines and I'm exceedingly impatient when it comes to long running pipelines.

To get around this we lazy-load in models and dependencies if they are needed. My code architecture now looks something like this:

```
┌─────────────────────────────────────────────────────┐
│  User Interface Layer                               │
│  ┌──────────────┬──────────────┬─────────────────┐  │
│  │     CLI      │     API      │  Programmatic   │  │
│  └──────────────┴──────────────┴─────────────────┘  │
│         ↓           ↓              ↓                │
├─────────────────────────────────────────────────────┤
│  TerraformIngest                                    │
│  ├─ auto_install_deps parameter                     │
│  └─ calls ensure_embeddings_available()             │
├─────────────────────────────────────────────────────┤
│  dependency_installer.py                            │
│  ├─ DependencyInstaller class                       │
│  │  ├─ check_package_installed()                    │
│  │  ├─ get_missing_packages()                       │
│  │  ├─ install_packages()                           │
│  │  └─ ensure_embedding_packages()                  │
│  └─ ensure_embeddings_available() function          │
├─────────────────────────────────────────────────────┤
│  embeddings.py                                      │
│  └─ VectorDBManager (no changes, already works)     │
└─────────────────────────────────────────────────────┘
```

> **WARNING** I usually do not recommend this approach for production use as it has security ramifications and defies best practices for artifact immutability. If you are repackaging this server up to use in production bake a new image with the appropriate embedding models in place. Then let me know as well cause that would definitely fill my bucket a bit!

## Conclusion

I'm pretty happy with the results of this little project and plan on configuring it for any large set of modules I author. I've included some other nice features like automatic updating, automatic import of a github organization, and indexing. I could easily see updating the caching to be more efficient and adding more/better searching but even as it is currently the MCP server is quite functional and I encourage the community to put it through its paces so it can be further improved!

