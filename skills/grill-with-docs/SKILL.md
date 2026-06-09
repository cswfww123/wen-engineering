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
- For large ideas needing persistent multi-session topic docs → use `/grill-prep` instead
- Do not route by estimated context size

Bug routing means: stop the plan interview, load `/diagnosing-bugs`, and build a feedback loop around the reported symptom. Return to `/grill-with-docs` only if diagnosis shows the request is really a product/design decision rather than a defect.
