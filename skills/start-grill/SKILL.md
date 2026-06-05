---
name: start-grill
description: Starts grill work and routes by size. Use for start-grill, grill, plan sharpening, or dumb-zone risk.
disable-model-invocation: true
---

# Start Grill

Sharpen a plan or design through grilling while keeping durable docs current.

This is the public grill entrypoint. It decides whether the request can fit in one focused session or should be split through `/grill-prep`.

## Quick Start

1. Read the user's idea and any directly relevant repo evidence.
2. Estimate whether a complete grill would consume more than about 40% of the useful context window.
3. If small, run `/grilling` with `/domain-modeling` active.
4. If large, run `/grill-prep` to create persistent topic docs.

## 40% Gate

The agent running `/start-grill` owns the 40% judgment.

Use judgment, not token math. Split when two or more of these are true:

- more than one product, market, technical, security, or business branch must be resolved
- likely more than 8-12 meaningful questions before shared understanding
- the user will probably need multiple pauses, clears, or sessions
- repo evidence spans several modules, contexts, ADRs, or issue sets
- answers in one branch should not pollute another branch
- the discussion already shows dumb-zone symptoms: repeated "I don't know", looping, or mixed topics

Stay direct when the requirement has one topic, fewer than 3-4 meaningful open questions, and little repo evidence.

## Small Requirement Path

Run `/grilling`:

- ask one question at a time
- provide your recommended answer for each question
- explore the codebase instead of asking when code can answer
- stop when shared understanding is reached

Keep `/domain-modeling` active:

- challenge fuzzy or conflicting terms against `CONTEXT.md`
- update `CONTEXT.md` only for glossary terms
- offer ADRs only for hard-to-reverse, surprising trade-offs

When enough is settled, use `/to-prd` directly if the user wants a PRD. Small requirements do not need `/finish-grill`.

## Large Requirement Path

Run `/grill-prep`.

It writes durable state to `docs/grilling/<slug>/` and stops before full grilling starts. After the user clears context, use `/do-grill` to complete one topic per session. When required topics are complete or explicitly out of scope, run `/finish-grill` before `/to-prd`.

## Done

For small requirements, done means shared understanding and updated glossary/ADRs where needed.

For large requirements, done means `/grill-prep` created an index, topic files, priorities, blockers, and the next recommended topic.
