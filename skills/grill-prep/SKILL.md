---
name: grill-prep
description: Splits big ideas into persistent grill docs. Use when grill-prep, project-prep, or dumb zone appears.
---

# Grill Prep

Prepare a large idea for focused discussion without letting the main thread become the dumping ground. This is the large-requirement branch of `/start-grill`: map the grill branches, write persistent topic state, then stop.

## Quick Start

When the user gives a broad idea such as "build a WhatsApp CRM SaaS":

1. Read the idea and directly relevant repo docs.
2. Run one light grill pass grouped by topic.
3. Create `docs/grilling/<slug>/INDEX.md` plus scoped topic files.
4. Rank topics by priority, blockers, and PRD impact.
5. Stop before full grilling starts.

Use [TEMPLATES.md](TEMPLATES.md) for the document shapes.

## Core Rule

The main thread is a router, not the workshop. Do not ask topic questions one at a time here. Do not solve market, product, architecture, finance, and security in one conversation. Convert those questions into topic briefs and move the work out.

Only split when `/start-grill` or local evidence shows a full grill is likely to consume more than about 40% of the useful context window. If the requirement is small, return to `/start-grill` for direct `/grilling` with `/domain-modeling`.

All grill-prep state lives in `docs/grilling/<slug>/`. Assume the chat will be cleared after every session. `INDEX.md`, topic files, `CONTEXT.md`, and ADRs are the only durable memory.

`docs/grilling/**` stores planning state. `CONTEXT.md` stays a glossary only. ADRs are only for hard-to-reverse, surprising trade-offs.

## Workflow

### 1. Seed And Evidence

Capture the user's idea, desired outcome, known constraints, and existing docs or code evidence. Read only what can sharpen the split:

- `README.md`, `CONTEXT.md`, `CONTEXT-MAP.md`, and relevant ADRs when they exist
- existing PRDs, plans, issue docs, or product notes
- directly relevant code only when the idea depends on the current implementation

If the seed is too vague to classify, ask one compact seed question, then stop until answered.

### 2. Light Grill Map

Produce a single grouped scan: known decisions, risky assumptions, missing facts, contradictions or fuzzy terms, and recommended topic split.

Keep it light. Aim for 5-12 sharp questions total. Each question should include why it matters and the smallest evidence that would resolve it.

Separate global blockers from topic work. A global blocker is something that prevents creating useful topic threads at all, such as "we do not know what product this is."

This is not a full `/grilling` session. The full grill happens later through `/do-grill`, which runs `/start-grill` inside one topic scope.

### 3. Split Topics

Create 3-8 topic briefs. Choose names from the idea, not from a fixed checklist. Common topics include market validation, user workflow, product scope, architecture, data model, operations, security, pricing, and growth.

Each topic needs `Required`, `Priority`, `Status`, `Blocked by`, sharp questions, and `Done When` criteria so `/do-grill` and `/finish-grill` can decide what remains without re-reading the whole conversation.

For a repo-backed project, write `docs/grilling/<slug>/INDEX.md` and one file per topic. If no writable project exists, render those docs as artifacts; launch prompts alone are not durable state.

### 4. Launch Topic Threads

Each topic thread gets only the original one-paragraph idea, `INDEX.md`, its own topic brief, and directly relevant repo evidence.

When native thread tools are available and the user asked for real threads, create one thread per topic. Otherwise, provide copy-ready `/do-grill` launch prompts.

Inside a topic thread, `/do-grill` runs `/start-grill` inside that topic scope.

### 5. Return Conclusions

A topic thread returns a compact conclusion, not the whole discussion: decisions made, evidence found, open questions, changed docs, and recommended next topic.

The main thread reads only topic conclusions and updates `INDEX.md`.

When every required topic is `Complete` or `Out of scope`, run `/finish-grill` to create `PRD-SOURCE.md`, then run `/to-prd` from that source instead of the full transcript.

## Dumb Zone Guards

- Stop prep after the split is created.
- If the user starts answering many topic questions in the main thread, file each answer into the matching topic brief and route them to one topic.
- Keep unresolved questions as backlog, not chat turns.
- Prefer documents as context over transcript history.
- Do not load every topic file into every topic thread.

## Done

You are done when the idea has an index, scoped topic briefs, and a clear next thread to enter. Do not claim the plan is validated until topic conclusions exist.
