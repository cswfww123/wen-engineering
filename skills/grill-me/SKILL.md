---
name: grill-me
description: Relentless interview for a non-coding plan, decision, or idea. Not a codebase (that is /grill-code).
disable-model-invocation: true
---

Run a `/grilling` session (load `grilling` once). Use its **frontier-round** rules, question format (`❓` / `➡️`), and batch table shape when several decisions share settled prerequisites.

This skill is the **non-coding** grill: a plan, a decision, an idea, writing, a personal or team call that does not land in a repository. **Shared understanding in the conversation is enough.** Do not write a decision file unless the user asks.

## When this is the wrong skill

- The subject is a codebase, a PRD, a ticket, wire values, schema, or “how should we build this” → **`/grill-code`** (LIGHT G). Do not run this skill and then invent engineering defaults.
- Clear acceptance criteria, a bug, or one engineering slice → **`/implement`**.
- A detailed product doc already settles a multi-slice feature → **`/to-spec`**, not a product re-grill.

## How to grill

1. **Frontier only.** Each round asks decisions whose prerequisites are already settled. Give a recommended answer. Wait.
2. **Facts are yours.** Look up anything the environment can answer. Do not scan a repo, PRD, or tracker unless the user pointed at one as source material for a non-coding question.
3. **No engineering machinery.** Do not post MVP tables, conflict-fact tables, `相对 PRD` rows, domain-model updates, or an implement handoff. Do not route to `/implement`, `/to-spec`, or `/to-tickets` unless the user asks to switch into coding work — then stop and hand off to `/grill-code` or the route they named.
4. **Wrong human.** If the answers live with someone else, say so and stop. Offer a short question list they can forward. Do not invent the missing answers.

## Close

When the frontier is empty, stop. Recap the settled choices in the chat. Do not offer a build, a spec, or an archive.
