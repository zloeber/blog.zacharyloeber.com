---
title: "Tokens for AI Exploration"
date: 2025-05-16T13:28:23-05:00
draft: true

categories: ["ai", "llm", "openai", "api"]
tags: ["ai", "llm", "openai", "api", "crewai", "development", "openrouter.ai"]
toc: true
author: "Zachary Loeber"
---

Using ChatGPT, Gemini, Grok, or any of the other chat based LLMs is a great way to start with AI. But in order to bring things to the next level you will either need some beefy hardware to run models locally or access to an online API with models you can use. This article will walk you through how to do the later of these two options for free.

---

The bill of materials for this jaunt into AI is pretty simple. You need to create an account over at https://openrouter.ai/ then create an api key to use in your development. Additionally, you will need to have docker running with ollama to configure a local embedding endpoint to use for storing memory for any of the more advanced agent toolkits or RAG work. This is because no embedding model endpoints are available in OpenRouter.

> **NOTE** Embedding models are used in AI to convert text or other data into numerical vectors that capture semantic meaning. These vectors enable efficient comparison, search, and retrieval of information, making them essential for tasks like semantic search, recommendation systems, and enabling memory in AI agents.

