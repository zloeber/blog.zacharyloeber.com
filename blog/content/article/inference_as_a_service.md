---
title: "AWS Bedrock vs Azure AI Foundry for Inference as a Service - Part 1"
date: 2026-04-13
draft: true
categories: ["ai", "cloud", "platform-engineering"]
tags: ["aws-bedrock", "azure-ai-foundry", "inference", "llmops", "finops"]
toc: true
author: "Zachary Loeber"
featuredImage: "images/banners/secret-zero-banner.png"
Permalink: /blog/2026/4/13/aws_bedrock_vs_azure_ai_foundry_for_inference_as_a_service-part_1/
---

How do you fulfill the organizational need for AI inference? Organizations need internal services that can be adopted safely at scale: clear onboarding, policy guardrails, predictable spend, stable latency, and supportable operations.

At home, I run this exact pattern on a smaller scale with Ollama and sometimes vLLM: one internal endpoint, a curated model list, and simple guardrails around usage so I do not melt my workstation when testing new workloads. That home setup is useful because it reinforces the same lesson we see in enterprises: model choice matters, but operating the service layer matters more.

This is a platform-as-a-service journey. The context here is an AWS-heavy enterprise environment that still needs to decide where inference as a service should live, and how much extra platform complexity is worth taking on for broader model coverage.

This is not a market report. This is an operator-focused walkthrough of what can realistically be delivered to internal teams over the next 6-12 months.

<!--more-->

## Why This Comparison Matters

No one gets extra points for having the most logos in an architecture diagram. The scorecard is whether product teams can ship AI-enabled features without fighting identity, networking, cost surprises, or model entitlement issues.

From that lens, let us evaluate Bedrock and Foundry on day-2 concerns:

- How quickly model access can be approved without creating security debt.
- How often model availability changes, and how disruptive those changes are.
- Whether hard controls can be put around spending and content safety.
- How cleanly each option integrates with existing cloud controls.

Both platforms are clearly mature enough for production workloads, but they make different tradeoffs.

Amazon positions Bedrock as a managed platform for foundation model access with model choice, guardrails, and cost tiers (source: https://aws.amazon.com/bedrock/). Azure positions Foundry as a unified platform that now spans model access, agents, governance, and SDK/API consolidation under the new Foundry experience (source: https://learn.microsoft.com/en-us/azure/foundry/what-is-foundry).

Those are both solid platform stories. The real question is which one helps us operate an internal inference service with less friction.

## The Simple Comparison: Bedrock vs Foundry

### Model Choice and Access Friction

Bedrock gives a straightforward control point for model entitlements in AWS accounts. AWS documents explicit model access workflows and a supported model catalog, which is exactly what helps with controlled onboarding (source: https://docs.aws.amazon.com/bedrock/latest/userguide/model-access.html, source: https://docs.aws.amazon.com/bedrock/latest/userguide/models-supported.html).

Foundry provides a much larger umbrella catalog and separates offerings between models sold directly by Azure and partner/community models. That split is useful because it signals different support and commercial posture upfront (source: https://learn.microsoft.com/en-us/azure/foundry-classic/concepts/foundry-models-overview).

Practical takeaway: Bedrock feels cleaner when AWS-native entitlement governance is the first priority. Foundry gives broader catalog optionality but requires more deliberate choices about which model categories are allowed by default.

### Feature Maturity for Agentic Workloads

AWS Bedrock now emphasizes agent-oriented capabilities and related services in the Bedrock ecosystem (source: https://aws.amazon.com/bedrock/). Microsoft Foundry similarly pushes agent development and operations, including multi-agent workflows, tool catalogs, and observability in one platform surface (source: https://learn.microsoft.com/en-us/azure/foundry/what-is-foundry).

For an internal inference service, this matters less than vendor messaging implies. Most teams need a stable model invocation layer first, then agent frameworks second. Both clouds can support that path, but each also tempts teams to over-build too early.

It is worth separating GA from preview promises in platform contracts. Microsoft explicitly documents preview handling and provides guidance to disable preview features in production contexts, and some Foundry SDK surfaces are still preview-labeled (source: https://learn.microsoft.com/en-us/azure/foundry/what-is-foundry#disable-preview-features). If a feature is preview, treat it as optional and non-SLO until proven otherwise.

### Governance and Enterprise Controls

Bedrock provides dedicated guardrail features and clearly documented controls for reducing harmful outputs and applying policy constraints (source: https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html).

Foundry ties governance into Azure Policy, RBAC, and Content Safety patterns. It also documents how serverless and managed compute differ for network isolation and billing behaviors, which matters for regulated workloads (source: https://learn.microsoft.com/en-us/azure/foundry-classic/concepts/foundry-models-overview).

Practical takeaway: both can be governed. Bedrock guardrails are easy to explain to platform consumers. Foundry offers broader policy surface area, but with more knobs to standardize.

### Speed of New Model Availability

For platform operations, headlines matter less than lifecycle stability. Foundry explicitly documents model lifecycle, deprecation, and retirement processes, including replacement guidance for some model families (source: https://learn.microsoft.com/en-us/azure/foundry-classic/concepts/model-lifecycle-retirement).

Bedrock publishes supported-model matrices and access controls, but real-world availability still depends on region and provider rollout timing (source: https://docs.aws.amazon.com/bedrock/latest/userguide/models-supported.html).

No one should promise that model X will be available in every required region at the same time on either platform. That detail belongs in the service contract as a conditional, not a guarantee.

### Practical Cost Posture

Bedrock pricing is explicit at the model and feature level, with multiple service tiers and a documented batch inference discount for select models (50% lower than on-demand for supported batch scenarios) (source: https://aws.amazon.com/bedrock/pricing/).

Foundry pricing is consumption-based across the services and features in use. Microsoft also states the platform itself is free to explore, with costs incurred at deployment and usage layers (source: https://learn.microsoft.com/en-us/azure/foundry/what-is-foundry#pricing-and-billing, source: https://azure.microsoft.com/en-us/pricing/details/ai-foundry/).

Practical takeaway: both are usage-driven, but charge mechanics differ enough that separate FinOps guardrails are needed per platform. There is no universal token pricing abstraction that keeps finance sane across both without custom reporting.

### Optional Outsider Lens (Not a Deep Dive)

Before moving on, it is worth briefly acknowledging outsider inference providers such as OpenRouter and Ollama Cloud.

- OpenRouter presents itself as a unified API across many providers and models, with OpenAI-compatible access and routing/fallback features (source: https://openrouter.ai/).
- Ollama starts from local-first open-model workflows and now also offers cloud-backed model access for larger workloads (source: https://ollama.com/).

These are real options for experimentation, rapid prototyping, and selective routing. But this article is intentionally not a deep comparison of aggregator or local-plus-cloud providers. The primary operating decision here remains Bedrock vs Foundry for enterprise internal inference as a service.

[Illustration 1: Technical diagram - inference routing model]

To keep this practical, use a three-lane request router in the technical visual:

- Default lane: approved standard models, token budget enforced, low-friction path.
- Premium lane: higher-cost model families behind explicit entitlement and tighter quotas.
- Exception lane: temporary approvals with expiry, audit trail, and forced review.

## What This Means for Our Inference Service

The platform choice directly changes what can be promised internally.

### Default Tiers We Can Offer

If we optimize for service reliability and operational simplicity, two default tiers make sense regardless of cloud:

- Standard inference tier: low-to-mid cost models, strong guardrails, predictable quotas.
- Advanced inference tier: broader context windows or reasoning-heavy models, stricter approvals.

On AWS-first, these tiers map naturally to Bedrock model access controls and explicit pricing visibility per model/provider. On Foundry-first, these tiers map to curated subsets from Foundry model categories with policy constraints on deployment types and region eligibility.

### Where We Need Exceptions and Escape Hatches

No serious enterprise model service survives without exceptions. A formal process is required for teams that need models outside the default catalog.

A practical pattern:

- Exception requests are time-bound.
- Exceptions require business justification and data classification review.
- Exception usage gets separate cost center tagging and weekly review.

This is where multi-cloud can be useful, but only as a controlled escape hatch. Broad, unmanaged “pick any model from anywhere” behavior quickly explodes governance and support load.

### How to Handle Premium Model Access

Premium access is usually less about capability and more about economics. A handful of teams can justify it. Most cannot.

So premium models should be gated with:

- Explicit ownership (team + cost center).
- Monthly token and spend caps.
- Burst rules with automatic fallback to standard tier.
- Auto-expiration unless renewed.

If a premium model call fails quota checks, deterministic fallback is usually better than hard outage when possible. If fallback materially changes answer quality, log that downgrade event for transparency.

### How to Set SLOs, Guardrails, and Cost Controls

For SLOs, keep it boring and measurable:

- Availability SLO by tier.
- p95 latency targets by model class.
- Error budget tied to platform incidents and quota failures.

For guardrails, separate safety controls from business policy controls:

- Safety: harmful content, sensitive data handling, prompt/response filtering.
- Policy: model eligibility, region restrictions, quota and budget enforcement.

For cost controls, treat token spend like any other shared platform utility:

- Per-project budgets.
- Anomaly alerts.
- Spend-to-value reviews in monthly governance cadence.

None of this is glamorous, but this is the difference between a demo platform and a service platform.

## Current Working Decision

A practical operating posture for the next 6-12 months is:

AWS-first inference service on Bedrock, with selective external routing when business requirements cannot be met by the default Bedrock catalog in approved regions.

Why this is a strong near-term call:

- Existing identity, network, and operations controls are already strongest in AWS.
- Bedrock provides enough model and governance capability to stand up a production internal service without introducing a second full operating plane on day one.
- A narrow Foundry path can still be preserved for approved exception scenarios where model availability, commercial terms, or feature fit justify it.

This decision is about reducing implementation risk while still preserving optionality.

## What Would Change This Decision

This posture should be revisited if any of these triggers happen:

1. A material model capability gap persists on Bedrock for a high-value internal use case and cannot be mitigated through prompt, architecture, or workflow changes.
2. Foundry demonstrates consistently better enterprise governance and cost controls for the specific deployment types required, with lower operating overhead in practice.
3. Commercial terms shift enough that running the same service profile in Foundry is clearly lower total cost at expected scale.
4. Regional availability and lifecycle stability become measurably better for required model families in Foundry than in Bedrock.
5. Internal platform strategy changes from AWS-centric to intentionally dual-cloud for AI platform services.

If those conditions are met, move from AWS-first to policy-driven dual control planes. Until then, focus wins.

[Illustration 2: Meme - platform reality check]

Inference as a service is not hard because calling a model API is hard. It is hard because operating it responsibly at scale is hard.

If we stay disciplined, Bedrock can carry the default service path today. Foundry remains a strategic option where it solves specific gaps better. That is a practical position teams can execute now.

