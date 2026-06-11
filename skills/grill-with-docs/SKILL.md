---
name: grill-with-docs
description: Runs grilling with domain docs. Use for grill, grill-with-docs, or plan/design stress tests.
disable-model-invocation: true
---

# Grill With Docs

Run `/grilling` with `/domain-modeling` active.

Use this as the normal user entrypoint for sharpening a plan or design. Ask one question at a time, provide a recommended answer, check repo evidence instead of asking when the repo can answer, and update glossary or ADR docs only when domain terms or durable decisions crystallize.

## What "Active" Means

"Run `/grilling` with `/domain-modeling` active" means: load both skills' instructions and follow them together. During the interview, apply `/domain-modeling` rules whenever domain terms appear — challenge fuzzy terms, propose precise alternatives, update `CONTEXT.md` inline. Do not treat them as separate phases.

## Routing

- For normal one-session plan sharpening → use this skill (`/grill-with-docs`)
- If the user is reporting an existing bug, broken behavior, failing test, exception, crash, or performance regression → route to `/diagnosing-bugs`
- For broad ideas, keep the interview in this skill and narrow the active scope one question at a time
- Do not route by estimated context size or create a separate multi-session grill path

Bug routing means: stop the plan interview, load `/diagnosing-bugs`, and build a feedback loop around the reported symptom. Return to `/grill-with-docs` only if diagnosis shows the request is really a product/design decision rather than a defect.

## Done

When the interview stops, return a compact summary:

- decisions made
- scope and out of scope
- repo evidence checked
- glossary or ADR docs changed
- remaining user-owned questions
- recommended next skill, such as `/to-prd` only when the source is settled
