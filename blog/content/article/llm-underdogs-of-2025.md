---
title: "LLM Underdogs of 2025"
date: 2026-01-05T09:21:07-06:00
categories: ["ai", "LLM"]
tags: ["ai", "agentic", "agents", "llm"]
toc: true
draft: false
author: "Zachary Loeber"
featuredImage: "images/banners/banner-tech-interview.jpeg"
Permalink: /blog/2026/1/5/llm_underdogs_of_2025/
---

# LLM Underdogs of 2025

2025 has been a flurry of AI madness that has been hard to keep up with. I've been deep in learning and experimenting in the AI space and noticed that while everyone's hyping up the latest GPT variant or Claude release, there are some genuinely impressive open-source models that feel like they just flew under the radar in 2025. These aren't just "good for their size", they're legit excellent models that you can run locally, for free, and deserve more attention.

<!--more-->

This isn't a benchmark shootout or a comparison article. Instead, I want to shine a light on three models that I think are more important than they're given credit for. They range in parameter size and are: 

- Technology Innovation Institute's [Falcon H1R 7B](https://falconllm.tii.ae/falcon-h1r-7b.html) - A super fast edge-ready math wiz and reasoning model

- NVIDEA's Nemotron Nano [8b](https://huggingface.co/nvidia/Llama-3.1-Nemotron-Nano-8B-v1) and [30b](https://research.nvidia.com/labs/nemotron/files/NVIDIA-Nemotron-3-Nano-Technical-Report.pdf) - This model sports a massive maximum context length of 1 million tokens!

- ServiceNow's [Apriel 1.6 15b Thinker](https://huggingface.co/ServiceNow-AI/Apriel-1.6-15b-Thinker) - A mid-sized LLM that trounces other models on tool usage

Each brings something unique to the table lets proceed and try to gain some understanding as to what makes them special and where you might want to put them to work for ya.

> **NOTE** If you want to compare/contrast these and other open source models in this class they are all technically in the 'small' class of models at [Artificial Analysis](https://artificialanalysis.ai/models/open-source/small)

## Falcon H1R 7B: Efficiency Meets Reasoning

Let's start with [TII](https://www.tii.ae/about-us)'s Falcon H1R 7B, which just dropped (literally, like hours ago as I'm writing this). This one caught my attention immediately because it challenges a fundamental assumption we've all been making: that you need massive models for serious reasoning tasks.

### What Makes It Special

The Falcon H1R 7B uses a hybrid Transformer-Mamba architecture, which is a fancy way of saying they've combined two different approaches to get better performance with fewer parameters. The result? This 7-billion parameter model is punching way above its weight class. It scored **88.1% on AIME-24 mathematics benchmarks**, outperforming ServiceNow's Apriel 1.5 at 15B parameters. Yeah, a model with less than half the parameters performing better on advanced math.

But here's where it gets really interesting: it processes up to 1,500 tokens per second per GPU at batch size 64. That's nearly **double the speed of comparable models**. For anyone building multi-agent systems or handling high-volume inference workloads, this matters tremendously.

### Where It Shines

As mentioned already, this model is quite good at math but that's not it's main superpower. The sweet spot for Falcon H1R 7B is anywhere you need reliable reasoning without the compute overhead of larger models:

- **Edge deployments**: Running on constrained hardware where every parameter counts
- **Real-time applications**: That token throughput makes it viable for interactive systems
- **Math and coding tasks**: It delivers 68.6% accuracy on coding and agentic tasks, best-in-class for models under 8B
- **Energy-conscious deployments**: Lower memory and energy consumption while maintaining near-perfect scores on benchmarks

### Why It's Important

The open-source AI community has been in an arms race of parameter counts. Falcon H1R 7B demonstrates that architectural innovations can matter more than raw size. It's released under the Falcon TII License, making it accessible for both research and commercial use. For developers building on limited budgets or those who need to deploy at scale, this efficiency-without-compromise approach is exactly what we need.

## NVIDIA's Nemotron Nano: Massive Context Length

NVIDIA's Nemotron Nano family represents a different kind of innovation. The 8B variant (Llama-3.1-Nemotron-Nano-8B-v1) and the more recent 30B variant are part of what NVIDIA calls their most efficient family of open models with leading accuracy for agentic AI applications.

### What Makes Them Special

The Nemotron Nano models use a hybrid Mixture-of-Experts (MoE) architecture combined with Mamba-2 layers. The 30B model is actually a 31.6B total parameter model that activates only about 3.6B parameters per token. This sparse activation approach means you get the intelligence of a much larger model with the speed and memory footprint of a smaller one.

The context window is another standout feature: **1 million tokens**! Yes, you read that right. For comparison, that's enough to fit several entire codebases or extensive documentation in a single context. The implications for code review, documentation generation, and long-form reasoning tasks are significant.

### Where They Shine

Aside from the large context, the Nemotron Nano models excel in scenarios where you need both reasoning capability and practical throughput:

- **Multi-agent systems**: The 30B variant delivers 4x higher throughput than Nemotron 2 Nano, making it ideal for systems where multiple agents need to collaborate
- **Software development**: Best-in-class performance on SWE-Bench among models in its size class
- **Agentic workflows**: Built specifically for tasks like software debugging, content summarization, and information retrieval
- **Long-context tasks**: That 1M token window makes it perfect for analyzing large codebases or extensive documents

The 8B variant is particularly interesting for edge deployments or when you want reasoning capabilities on more modest hardware. NVIDIA optimized it specifically for PC and edge use cases, and it shows.

### Why They're Important

NVIDIA isn't just releasing models, they're releasing the entire ecosystem. The Nemotron 3 family comes with open training datasets (25T tokens worth), reinforcement learning environments through NeMo Gym, and the full training recipe. This level of transparency is rare and incredibly valuable for researchers and practitioners who want to understand not just what works, but why it works.

The hybrid MoE architecture is also proving to be a game-changer for efficiency. By activating only a subset of parameters per token, these models achieve what researchers call the "Pareto frontier", optimal speed without sacrificing quality. This architectural approach could influence how we think about model design going forward.

## ServiceNow's Apriel 1.6 15B Thinker: Tool Wielding Reasoning Model

Now let's talk about Apriel 1.6 15B Thinker, which might be the most underrated model in this entire lineup. ServiceNow has been quietly building something impressive with their Apriel SLM series, and version 1.6 demonstrates what's possible when you focus on both performance and efficiency.

### What Makes It Special

Apriel 1.6 is a multimodal reasoning model, meaning it can work with both text and images. It scored 57 on the Artificial Analysis Index, putting it on par with models like Qwen3 235B A22B and DeepSeek-v3.2 (all models that are 15x larger).

If you look closer at this model compared to others in it's class you will find that it absolutely trounces almost all the other's in tool use [link](https://artificialanalysis.ai/models/open-source/small). It outperforms larger parameter models like gpt-oss-20b by almost 10% in some of the tests. Looking through the various test charts it is almost funny to see how many of the models with 2x the parameters score less than Apriel.

> **NOTE** The ability to use tools well is the difference between a toy LLM you play with and a machine you can use for real work. A model that can use tools well can also be supplemented with MCP servers to give them additional skills and capabilities beyond their training as well.

### Where It Shines

Apriel 1.6 excels in domains where you need both vision and reasoning in the enterprise:

- **Document understanding**: OCR, chart analysis, and structured data extraction from images
- **Enterprise applications**: It scores 69 on Tau2 Bench Telecom and 69 on IFBench (key benchmarks for enterprise domains)
- **Function calling and tool use**: The simplified chat template and special tokens make it easier to integrate with agentic systems
- **Resource-constrained deployments**: At 15B parameters, it fits on a single GPU while delivering frontier-level performance

### Why It's Important

Apriel 1.6 represents a crucial evolution in how we think about multimodal AI. Most multimodal models are either massive (100B+ parameters) or sacrifice significant capability to stay small. ServiceNow has found a middle ground that makes advanced vision-language capabilities accessible.

The training approach is also noteworthy. Trained on NVIDIA's GB200 Grace Blackwell Superchips, the entire mid-training pipeline required approximately 10,000 GPU hours, a relatively small compute footprint achieved through careful data strategy and training methodology. This efficiency-first mindset shows that throwing more compute at the problem isn't always the answer.

For developers building enterprise AI applications, Apriel 1.6 offers something unique: production-ready multimodal reasoning that actually fits in a reasonable memory budget. The focus on enterprise benchmarks and tool calling also makes it particularly well-suited for real-world business applications rather than just benchmark chasing.

## The Bigger Picture

What ties these three models together isn't just that they're flying under the radar, it's what they represent about where AI development is heading. We're moving away from the "bigger is always better" mentality toward a more nuanced understanding of efficiency, architecture, and targeted optimization.

Falcon H1R 7B shows that hybrid architectures can achieve remarkable results with fewer parameters. Nemotron Nano demonstrates that sparse activation through MoE can give us the best of both worlds, large model intelligence with small model efficiency. Apriel 1.6 proves that multimodal capabilities don't require massive models if you're thoughtful about training and optimization.

All three of these models are:
- Fully open and available for local deployment
- Designed with efficiency as a first-class concern
- Backed by transparent research and training methodologies
- Focused on practical, real-world use cases

For those of us building AI-powered applications, especially in environments where we can't just throw unlimited compute resources at every problem, these models matter. They represent a future where advanced AI capabilities are accessible to anyone with modest hardware, not just those with access to massive GPU clusters.

## Getting Started

If you want to try these models yourself all three can be run locally using tools like llama.cpp, Ollama, or vLLM. 

- **Falcon H1R 7B**: Available [on Hugging Face](https://huggingface.co/blog/tiiuae/falcon-h1r-7b) and Ollama (`ollama pull falcon:7b`)

- **NVIDIA Nemotron Nano 8B/30B**: Available [on Hugging Face](https://huggingface.co/nvidia/NVIDIA-Nemotron-3-Nano-30B-A3B-BF16), through NVIDIA's NIM platform, and Ollama (`ollama pull nemotron-3-nano:30b`)

- **Apriel 1.6 15B Thinker**: Available [on Hugging Face](https://huggingface.co/blog/ServiceNow-AI/apriel-1p6-15b-thinker) and hosted on platforms like Together AI and Ollama (`ollama pull ServiceNow-AI/Apriel-1.6-15b-Thinker:Q4_K_M`)

## Closing Thoughts

The AI landscape moves fast so it's easy to get caught up in the hype around the latest massive model releases. But some of the most interesting innovation is happening in the efficiency space, building models that are genuinely useful for practitioners who don't have access to unlimited compute resources. Falcon H1R 7B, NVIDIA Nemotron Nano, and Apriel 1.6 15B Thinker deserve more attention than they're getting. If you've been thinking about integrating AI into your projects but have been put off by the resource requirements of larger models, these three are worth a serious look.

## Links and Resources

- Technology Innovation Institute's [Falcon H1R 7B](https://falconllm.tii.ae/falcon-h1r-7b.html)

- NVIDEA's Nemotron Nano [8b](https://huggingface.co/nvidia/Llama-3.1-Nemotron-Nano-8B-v1) and [30b](https://huggingface.co/nvidia/NVIDIA-Nemotron-3-Nano-30B-A3B-BF16) and its [technical paper](https://research.nvidia.com/labs/nemotron/files/NVIDIA-Nemotron-3-Nano-Technical-Report.pdf)

- ServiceNow's [Apriel 1.6 15b Thinker](https://huggingface.co/ServiceNow-AI/Apriel-1.6-15b-Thinker)