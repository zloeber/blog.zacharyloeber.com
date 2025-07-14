---
title: "Free Tokens for AI Exploration"
date: 2025-05-16T13:28:23-05:00
draft: false

categories: ["ai", "llm", "openai", "api"]
tags: ["ai", "llm", "openai", "api", "crewai", "development", "openrouter.ai"]
toc: true
author: "Zachary Loeber"
featuredImage: ./images/banners/banner-free-tokens.jpg
Permalink: /blog/2025/05/16/free_tokens_for_ai_exploration
---

Using ChatGPT, Gemini, Grok, or any of the other chat based LLM service is a great way to start with AI. But in order to bring things to the next level you will either need some beefy hardware to run models locally or access to an online API with models you can use. This article will walk you through how to do the later of these two options for free.

<!--more-->

## What is OpenRouter?

OpenRouter.ai is an API service that acts like an umbrella to several dozen LLM providers with some of these models being free for training purposes. You can use these free models to develop AI at no cost if you don't mind being part of that training set. Sadly, OpenRouter does not include any form of embedding endpoints to use. Embedding is the conversion of knowledge/data for later retrieval. This is essentially how AI memory works so without this essential component your development efforts will be crippled.

> **Learning Point** Embedding models are used in AI to convert text or other data into numerical vectors that capture semantic meaning. These vectors enable efficient comparison, search, and retrieval of information, making them essential for tasks like semantic search, recommendation systems, and enabling memory in AI agents.

[This project](https://github.com/zloeber/crewai-openrouter-lab/) works around the lack of an embedding model endpoint by using the ollama endpoint locally.

## Requirements

Create your own local `.env` file from the `.env_example` included and update the OpenRouter API key to be your own key. Other dependencies can be installed in macos/Linux using the included configuration script, `./configure.sh`.

> **NOTE** I use [mise](https://mise.jdx.dev/) for installing the required binaries here and recommend you install and use it if you do not already. Otherwise you can get away with just having the ollama binary, docker, and python 3.12+.

## Starting The Embedder

Start ollama locally and pull down and embedding model to use:

```bash
# Configure ollama to run as a server and pull in the embedder used for storing 'memories'
ollama serve &
ollama pull nomic-embed-text

# Optionally test it out (the final output should be a list of vectors representing the embedded data)
curl http://localhost:11434/api/embeddings \
  -d '{
    "model": "nomic-embed-text",
    "prompt": "What is semantic search"
  }'
```

> **NOTE** [Here](https://ollama.com/blog/embedding-models) is a more detailed description with some example code of using an embedding model via ollama to store embeddings into a vector database (Chromadb) locally.

With this running, we can then focus on finding an appropriate (free) LLM model from OpenRouter.

## Finding a Free LLM

I've included a script you can use to query OpenRouter for LLMs of any sort, including the free ones. In our case we are looking for LLMs with zero cost but also include tools as a feature.

```bash
source ./.venv/bin/activate
python -m src.select-openrouter-model --max-cost 0 --limit 10 --output brief --features 'tools'
```

This should provide a list of models you can use for free that support tools capabilities. This might be different in the future, thus the script.

```text
1. Mistral: Devstral Small (free) (ID: mistralai/devstral-small:free)
2. Meta: Llama 3.3 8B Instruct (free) (ID: meta-llama/llama-3.3-8b-instruct:free)
3. Meta: Llama 4 Maverick (free) (ID: meta-llama/llama-4-maverick:free)
4. Meta: Llama 4 Scout (free) (ID: meta-llama/llama-4-scout:free)
5. Google: Gemini 2.5 Pro Experimental (ID: google/gemini-2.5-pro-exp-03-25)
6. Mistral: Mistral Small 3.1 24B (free) (ID: mistralai/mistral-small-3.1-24b-instruct:free)
7. Meta: Llama 3.3 70B Instruct (free) (ID: meta-llama/llama-3.3-70b-instruct:free)
8. Mistral: Mistral 7B Instruct (free) (ID: mistralai/mistral-7b-instruct:free)
```

## Demo: Interactive Human-AI Chat with CrewAI

This demonstrates using the ollama embedder and openrouter.ai LLM with chainlit and crewai to prompt a user for more information.

### Overview

This script creates a conversational AI assistant that collects personal information through natural dialogue. Using CrewAI's agent framework and Chainlit's user interface, it demonstrates how to build interactive AI systems that gather specific information while maintaining a natural conversation flow.

### How It Works

When a user sends a message, two specialized AI agents work together:

- **Information Collector**: Asks follow-up questions to gather name and location details
- **Information Summarizer**: Transforms collected data into a natural, friendly summary

### Key Features

- Natural back-and-forth conversation with AI
- Dynamic follow-up questions when more context is needed
- Friendly web interface using Chainlit
- Structured information collection in a conversational format

### Running

```bash
source ./.venv/bin/activate
chainlit run ./src/human_input/crewai_chainlit_human_input.py
```

This example demonstrates how AI systems can be made more interactive by combining structured task workflows with natural human conversation.


## Good Take Away Knowledge

Some things to understand about all of this.

### CrewAI uses LiteLLM

CrewAI uses LiteLLM to proxy most connection requests to various LLM providers. This can lead to some confusing results when you go to run your crew and find that your manually passed information for models, endpoints, and keys do not work. This is due to how LiteLLM will source in environment variables and use them instead. In our case, we load a `.env` file into the current environment variables list of the current process which means they should align with the expected names of the LiteLLM provider. This means the variable names are not fungible. You must define them as the following for CrewAI to function properly for OpenRouter.

```
...
OPENROUTER_API_KEY="<your-key>"
OPENAI_MODEL_NAME="<model>"
OPENAI_API_BASE="https://openrouter.ai/api/v1"
...
```

### CrewAI Memory

CrewAI [Memory](https://docs.crewai.com/concepts/memory) is stored locally but still requires an embedding API endpoint to function. By default this is OpenAI's endpoint. Without modification you will be left with many errors about invalid credentials in your logs for OpenAI even when you aren't using it for your LLM calls.

In my examples I overwrite the memory target from a default location in your home directory to the local project. See the CrewAI docs on how to review collections in this data and do other troubleshooting around this.

## Summary

This was an example using CrewAI with OpenRouter but should apply for most any Agent framework you decide to use. Enjoy coding up your AI app!