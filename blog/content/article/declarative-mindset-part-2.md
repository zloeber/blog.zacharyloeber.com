---
title: "Declarative Mindset - Part 2"
date: 2025-05-31T13:56:55-05:00
draft: true

categories: [ "AI", "Agent", "LLM", "Diffusion" ]
tags: [ "AI", "Agent", "Futurism" ]
toc: true
author: "Zachary Loeber"
---

About 5 years ago I wrote [a blog](https://blog.zacharyloeber.com/article/the-declarative-mindset/) about wrapping complexity in computing with declarative configuration. In light of the wild popularity that the AI trend has taken, it seems to me that declarative thinking is now more important than ever. So I've decided to revisit this subject and dive deeper into the importance of being declarative. I'll talk about why English is more important than Math, why LLMs are fast becoming blackbox declarative state machines, and along the way maybe even help people to come to terms with the new computing landscape we are facing.


<!--more-->

## Some Technology Maxims

Let's start with my almost religious beliefs about technology. 

1. We should be able to clearly state what we want and technology should be able to accomodate.

Anyone that has screwed around with printer settings, dealt with Windows drivers, tussled with XML, or attempted to figure out some obscure math function in Excel will have felt the hot rush of anger and the sentiment "Why is this not easier?".

Conversely, complex systems should be easy to understand.

2. Technology continually moves towards systematic abstraction to reduce complexity.

One might also say that technology always gets easier to wield and use. This is

> **Conversely:** The more abstract a system becomes, the less expressive it becomes.

## Technology Always Gets Easier

As we progress technology it almost always becomes more complicated

**Pre-1940s – Mechanical Control**
    Jacquard Loom (1801): Used punched cards to control weaving patterns — one of the earliest examples of programmable machinery.

**1940s – Binary and Machine Code**
    ENIAC (1945): Programs were input via manual rewiring or physical switches.
    Machine Code: Instructions written directly in binary (e.g., 10101011), tied to specific hardware.

**1950s – Assembly Language**
    Assembler Introduced: Human-readable mnemonics like MOV, ADD mapped to machine instructions.
    Still low-level, but easier than raw binary.

**Late 1950s–60s – High-Level Procedural Languages**
    FORTRAN (1957), COBOL (1959), LISP (1958): Allowed expressing logic in algebraic or English-like syntax.
    Marked the beginning of machine-independent programming.

    Compilers emerged to translate high-level code to machine code.

**1970s – Structured Programming**
    C (1972) and Pascal emphasized control structures (if, while, function) to reduce goto chaos.
    Enabled modular, reusable code with stronger type systems and abstraction.

**1980s – Object-Oriented Programming**
    Smalltalk, C++: Introduced classes, objects, and encapsulation, allowing programs to model real-world entities more naturally.
    Code became more composable and expressive.

**1990s – Scripting and Managed Languages**
    Python (1991), Java (1995), JavaScript (1995): Prioritized readability, memory management, and portability.
    Garbage collection, standard libraries, and virtual machines (e.g., JVM) abstracted away low-level concerns.

**2000s – Declarative and Functional Paradigms**
    SQL, HTML/CSS, XAML, YAML, and JSON: Emphasized describing what rather than how.
    Functional programming revival: Haskell, Scala, and functional features in mainstream languages (e.g., JavaScript’s map, filter).

**2010s – DevOps and Configuration as Code**
    Terraform, Ansible, Kubernetes YAML, CloudFormation: Declarative infrastructure management.
    Express complex systems setup via simple DSLs.

**2020s – No-Code/Low-Code & AI-Assisted Programming**
    Bubble, Retool, Zapier, Copilot: Allow non-programmers or semi-technical users to build logic via GUIs or plain language.
    LLMs (e.g., GPT-4): Accept natural language instructions and generate code, making programming accessible to non-developers.

**Future (Emerging) – Intent-Based and Agentic Systems**
    Agent frameworks (e.g., CrewAI, AutoGPT): Users express goals, and autonomous agents execute them.
    Shift from code-as-instruction to code-as-intention.
