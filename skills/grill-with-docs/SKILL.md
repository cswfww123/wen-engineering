---
name: grill-with-docs
description: Run a plan-sharpening interview with domain docs active.
disable-model-invocation: true
---

# Grill With Docs

Run `/grilling` with `/domain-modeling` active.

Use this as the normal user entrypoint for sharpening a plan or design. Ask one question at a time, provide a recommended answer, check repo evidence instead of asking when the repo can answer, and update glossary or ADR docs only when domain terms or durable decisions crystallize.

## What "Active" Means

"Run `/grilling` with `/domain-modeling` active" means: load both skills' instructions and follow them together. During the interview, apply `/domain-modeling` rules whenever domain terms appear — challenge fuzzy terms, propose precise alternatives, update `CONTEXT.md` inline. Do not treat them as separate phases.

When a plan or design question depends on current code behavior, trace the relevant entrypoint so repo evidence answers what it can before the user is asked.

## Boundary

Keep this skill as instruction for a docs-backed grilling session, not a router. For broad ideas, narrow the active scope one question at a time. Do not route by estimated context size or create a separate multi-session grill path.

## Done

When the interview stops, return a compact summary:

- decisions made
- scope and out of scope
- repo evidence checked
- glossary or ADR docs changed
- remaining user-owned questions
- recommended next skill, such as `/to-prd` only when the source is settled
