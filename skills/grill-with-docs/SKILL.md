---
name: grill-with-docs
description: Run a plan-sharpening interview with domain docs active.
disable-model-invocation: true
---

# Grill With Docs

Run `/grilling` with `/domain-modeling` active.

Use this as the normal **engineering** entrypoint for sharpening a plan or
design when product intent is already settled enough to talk about code. Ask one
question at a time, provide a recommended answer, check repo evidence instead of
asking when the repo can answer, and update glossary or ADR docs only when domain
terms or durable **technical** decisions crystallize.

## What "Active" Means

"Run `/grilling` with `/domain-modeling` active" means: load both skills'
instructions and follow them together. During the interview, apply
`/domain-modeling` rules whenever domain terms appear — challenge fuzzy terms,
propose precise alternatives, update `CONTEXT.md` inline. Do not treat them as
separate phases.

When a plan or design question depends on current code behavior, trace the
relevant entrypoint so repo evidence answers what it can before the user is asked.

## Boundary

Keep this skill as instruction for a docs-backed grilling session, not a
product-discovery router. For broad ideas, narrow the **engineering** scope one
question at a time.

**Product / market / need fog:** if material uncertainty is about worth-doing,
target user, stakeholder inner need, market, or unvalidated product bets, stop
with evidence gathered and recommend `/pm-intake` (PM workspace). Do not invent
product answers or open an engineering Wayfinder map.

**Technical multi-session fog:** if product is settled (or work is pure
engineering) but the technical destination still cannot fit one honest planning
session, stop and recommend `/wayfinder`. Do not create its map implicitly.

**Settled enough:** recommend `/to-spec` or `/implement`.

Read `docs/boundaries.md` when the layer is unclear.

## Done

When the interview stops, return a compact summary:

- decisions made
- scope and out of scope
- repo evidence checked
- glossary or ADR docs changed
- remaining user-owned questions
- recommended next skill: `/to-spec` or `/implement` when settled;
  `/wayfinder` when **technical** multi-session fog remains;
  `/pm-intake` when **product** fog remains
