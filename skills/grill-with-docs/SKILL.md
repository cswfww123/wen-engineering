---
name: grill-with-docs
description: Run a plan-sharpening interview with domain docs active.
disable-model-invocation: true
---

# Grill With Docs

Run `/grilling` with `/domain-modeling` active.

Use this as the normal user entrypoint for sharpening a plan or design. Ask one
question at a time, provide a recommended answer, check repo evidence instead of
asking when the repo can answer, and update glossary or ADR docs only when domain
terms or durable decisions crystallize.

## What "Active" Means

"Run `/grilling` with `/domain-modeling` active" means: load both skills'
instructions and follow them together. During the interview, apply
`/domain-modeling` rules whenever domain terms appear — challenge fuzzy terms,
propose precise alternatives, update `CONTEXT.md` inline. Do not treat them as
separate phases.

When a plan or design question depends on current code behavior, trace the
relevant entrypoint so repo evidence answers what it can before the user is asked.

## Boundary

Keep this skill as instruction for a docs-backed grilling session, not a router.
For broad ideas, narrow the active scope one question at a time. Do not invent
product value, market bets, or Expected after rejection — record user decisions.

If the product need itself is fuzzy (HEAVY: worth-doing, market, unvalidated
idea), stop and recommend full PM — not deep technical grilling. If only a mild
coding-adjacent intent gap remains (LIGHT), recommend `/product-fog`.

If breadth-first questioning shows the destination is still foggy and the work
cannot fit one honest planning session, stop with the evidence gathered and
recommend `/wayfinder`. Do not create its map implicitly; Wayfinder is a
user-invoked shared-state workflow.

Optional: when the team uses `wen-pm` and wants a full product discovery stack
(interviews, OST, to-prd), recommend `/pm-intake` — never hard-fail if missing.

**Settled enough:** recommend `/to-spec` or `/implement`.

## Done

When the interview stops, return a compact summary:

- decisions made
- scope and out of scope
- repo evidence checked
- glossary or ADR docs changed
- remaining user-owned questions
- recommended next skill: `/to-spec` or `/implement` when settled;
  `/wayfinder` when multi-session fog remains;
  `/product-fog` when product intent is still unpinned;
  optional `/pm-intake` when the team prefers the full PM pack
