---
name: grilling
description: One-question-at-a-time interview protocol. Use when grill-with-docs loads grilling or for bare grilling.
---

# Grilling

Interview until shared understanding: one question at a time, wait for feedback, walk design-tree branches and resolve decision dependencies. Always include a recommended answer.

## Layers (in order)

Skip a layer only when clearly irrelevant:

1. **Constraints** — budget, timeline, tech, team, regulation, commitments
2. **Scope** — out of scope; adjacent problems not solved
3. **Core behavior** — main user-visible flows
4. **Edges / errors** — invalid input, partial failure, concurrency, missing data. Shared mutable invariants → `.agents/rules/invariants/`
5. **Dependencies** — upstream/downstream, shared state, migration
6. **Trade-offs** — competing goals (simplicity vs flexibility, etc.)

## Format

```text
Q: <one focused question>
Recommended: <best answer from evidence>
Alternatives considered: <brief, if any>
```

If unconfident, say what evidence would resolve it and whether it lives in the repo.

## Rules

- Repo can answer → explore, report findings; do not ask. Trace entrypoints when behavior (not names) matters.
- Contradiction with earlier decisions or code → state it, cite evidence, ask which way — never silent pick.
- Stop when an implementer can start without guessing material decisions: constraints stated/deferred, core behavior specified, edges covered or out of scope, remaining unknowns marked user-owned, or the user says stop. Do not stop merely because questions ran out.
