---
name: grill-with-docs
description: Runs grilling with domain docs. Use for grill, grill-with-docs, or plan/design stress tests.
disable-model-invocation: true
---

# Grill With Docs

Run `/grilling` with `/domain-modeling` active.

Use this as the normal user entrypoint for sharpening a plan or design. Ask one question at a time, provide a recommended answer, check repo evidence instead of asking when the repo can answer, and update glossary or ADR docs only when domain terms or durable decisions crystallize.

Do not route by estimated context size. If the user explicitly asks for persistent multi-session topic docs, use `/grill-prep` instead.
