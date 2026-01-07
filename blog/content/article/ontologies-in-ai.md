---
title: "Ontologies in AI"
date: 2025-11-26T08:14:45-06:00
categories: ["ai"]
tags: ["ai", "agentic", "agents", "rag"]
toc: true
draft: true
author: "Zachary Loeber"
featuredImage: "/images/banners/banner-agile-750x187.jpg"
Permalink: /blog/2025/11/26/ontologies_in_ai/
---

In this post I'm going to talk about ontologies and where they fit into your AI workflows.

<!--more-->

## Ontology?

Firstly, let's define this word shall we? An ontology is a means to create a schema for the classification of concepts, entities, and the relationships between them. Applied to data, an ontology it adds valuable context to how the data is to be understood and followed.

Think of an ontology like a library's Dewey Decimal System. Just as the system doesn't just tell you where a book is located, but also how it relates to other books (history books near political science, chemistry near physics), an ontology doesn't just label data, it defines how different pieces of information connect and relate to each other in a structured, meaningful way.

## Different Ontologies for Different Purposes

![Nano Banana is incredible, this in one try!](/images/ontology-diagram.png)

To illustrate how ontologies vary based on their use case, consider two very different AI agents:

**Dungeon Master:** would have an ontology structured around game mechanics and narrative elements. Its entities might include characters (with attributes like hit points, inventory, and alignment), locations (dungeons, towns, wilderness), items (weapons, potions, magical artifacts), and events (combat encounters, quest triggers, character interactions). The relationships would define how these interact: "character possesses item," "location contains enemy," "quest requires item." This ontology prioritizes dynamic gameplay states and narrative coherence.

**Researcher:** Built around academic concepts and information hierarchies. Its entities might include publications, authors, institutions, research topics, methodologies, and citations. Relationships would capture academic connections: "author affiliated with institution," "paper cites paper," "research builds upon research," "methodology applies to topic." This ontology emphasizes credibility, provenance, and the evolution of ideas over time.

The key difference? The dungeon master's ontology models a fictional, mutable world focused on entertainment and player experience, while the research agent's ontology models a factual knowledge graph focused on accuracy and intellectual lineage.

### Example: Same Conversation, Different Ontologies

Let's see how the same simple conversation gets interpreted through different ontological lenses.

**The Conversation:**

> User: "I need help finding information about dragons."
> 
> AI: "I can help with that. Are you looking for something specific?"
> 
> User: "Yes, something about fire resistance."

**Through the Dungeon Master Ontology:**

The important data gets processed like this:

| **Ontology Component** | **Interpretation** |
|------------------------|-------------------|
| **Entity** | Player character (the user) |
| **Intent** | Item or ability search |
| **Concept** | "Dragon" → Monster category, high-level threat |
| **Concept** | "Fire resistance" → Character attribute, defensive stat |
| **Relationship** | Character needs protection from dragon breath weapon |
| **Action** | Query inventory system for fire resistance potions, armor, or spells |

And the DM agent would likely respond with game-mechanical solutions: "You can find a Potion of Fire Resistance at the local alchemist, or the Ring of Fire Immunity in the dragon's hoard itself."

**Through the Research Agent Ontology:**

The AI would parse this as:

| **Ontology Component** | **Interpretation** |
|------------------------|-------------------|
| **Entity** | Researcher (the user) |
| **Intent** | Literature search |
| **Topic** | "Dragons" → Mythology, folklore, or biology (depending on academic context) |
| **Topic** | "Fire resistance" → Materials science, evolutionary biology, or chemical properties |
| **Relationship** | Research intersection between two domains |
| **Action** | Query academic databases for papers connecting these concepts |

Same words, completely different understanding—all because of the underlying ontology.

## RAG Ingestion Ontology Example

A simpler example for RAG (Retrieval-Augmented Generation) systems shows how ontologies help organize ingested content:

**Entities:**
- Documents (articles, papers, reports)
- Sections (chapters, paragraphs, headings)
- Concepts (topics, keywords, themes)
- Authors (creators, contributors)

**Relationships:**
- "Document contains section"
- "Section discusses concept"
- "Concept relates to concept"
- "Author wrote document"

**During Ingestion:**

When processing a document about "machine learning in healthcare," the ontology:
- **Identifies**: Document type, primary concepts, related topics
- **Links**: ML concept → Healthcare concept → Specific applications
- **Chunks**: Preserves semantic boundaries (sections, topics)
- **Embeds**: With relationship context for better retrieval

This structure ensures that when a user later asks "How is AI used in hospitals?", the RAG system retrieves not just keyword matches, but semantically related content about ML applications in healthcare settings.

To further illustrate, here's how a **business intelligence agent** would structure its ontology:

**Entities:**
- Organizations (companies, departments, subsidiaries)
- Personnel (employees, executives, contractors)
- Financial records (transactions, budgets, forecasts)
- Products/Services (SKUs, offerings, pricing tiers)
- Customers (accounts, segments, contacts)
- Metrics (KPIs, performance indicators, targets)

**Relationships:**
- "Employee works for department"
- "Department belongs to organization"
- "Transaction involves product"
- "Customer purchases product"
- "Metric measures performance of department"
- "Budget allocated to department"

**Sample Query Interpretation:**

When a user asks: "Show me Q4 sales performance for the Northeast region"

The business ontology parses this as:
- **Time Entity**: Q4 (fiscal period)
- **Metric**: Sales performance (revenue, units sold)
- **Location**: Northeast region (geographic segment)
- **Relationship Chain**: Region → Departments → Sales Transactions → Products
- **Action**: Aggregate financial data filtered by time and geography

The agent would return dashboards, trend analyses, and comparative metrics—all structured according to how the business defines its operational reality.

## Ontology Workflow

The next natural question any engineer should be asking is where does this additional filtering get applied? What does it even look like?

## 

At the core of RAG is a pretty basic process of consuming many chunks of data with some overlap, running it through an embedding model (another llm), and storing the results into a vectordb. An LLM then searches through that data based on the context of the current conversation. This 

## Standards

There are a few defined standards that can facilitate ontology definitions. This includes:

- JSON-LD - JSON for Linked Data