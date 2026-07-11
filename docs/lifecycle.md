# WEN Engineering Lifecycle

This is the routing source of truth for WEN **coding** skills. The route follows
the shape of the work; it is not a form every request must complete.

This repo is for **production coding**: settled product intent becomes
verifiable implementation work. It does **not** require companion `wen-pm` or
`wen-test`. Product discovery and system QA are optional external layers.

- Product / market / need → team's product process (optional `wen-pm`)
- System test design / QA execution → optional `wen-test` (`/to-test-plan`, `/qa-run`)
- Developer proof (TDD, verification, code-review) → **this pack**

See [boundaries.md](boundaries.md) and [handoff-package.md](handoff-package.md).

## Choose The Entry

### Product or market fog (stop inventing)

Stop when material uncertainty is about worth-doing, target user, inner need,
market bets, or unspecified Expected after rejection. Hand to the product/design
owner (optional `/pm-intake`). Do not invent product answers in coding skills.

### Clear, bounded work

Use `/implement` when intent is settled enough and one context holds the task
and acceptance boundary. Includes developer evidence (TDD or compatibility
baseline), simplify, verification, `/code-review`. Does **not** require system
`/qa-run` inside this pack.

### Settled, multi-slice work (default multi-session coding path)

```text
settled delivery inputs -> /to-spec -> /to-tickets -> /implement
  -> (optional) wen-test: /to-test-plan -> /qa-run
```

- `/to-spec` / `/to-tickets` / `/implement` own coding artifacts and developer
  completion gates (behavior + layer-scoped fidelity for the implementer).
- System-level test planning and acceptance QA live in **`wen-test`** when the
  team uses that pack; otherwise human QA or project CI policy applies.
- `/implement` never closes the parent **spec**; release/closeout is project
  policy, human closeout, or optional external `/qa-run` evidence.

### Technical multi-session fog (advanced, rare)

```text
settled product + technical fog -> /wayfinder -> /to-spec -> /to-tickets
```

Engineering discovery only. Not product discovery; not system QA.

### Bugs and regressions

Use `/diagnosing-bugs` for hard diagnosis. Explicit fix authority uses the same
implement evidence loop. Confirmed defects from external QA should enter as
tickets or `bug-report` intake per the tracker adapter.

## Artifact Model

- **Spec** (`Kind: spec`) — non-runnable parent
- **Implementation ticket** — one vertical slice; `AFK` may enter implementation frontier
- **Wayfinder map / ticket** — technical discovery only; never implement as code work
- **Bug report** — non-runnable intake until converted
- **Implementation / human / discovery frontiers** — as before

System test plans and QA reports are **not** owned by this pack when `wen-test`
is used; they may still be stored in the app repo via tracker conventions.

## One Ticket, One Reviewable Delta

```text
claim -> behavior test or compatibility baseline -> simplify -> verification -> code review -> close
```

Layer-scoped **UI fidelity** or **API contract fidelity** during `/implement`
is the **developer** check that the slice matches the delivery package — not a
substitute for independent system QA.

Parent **spec** stays open until project closeout (human, CI policy, or optional
external `/qa-run` Complete + child resolution). `/implement` never closes the
parent spec.

## Context And Concurrency

- Fresh context per implementation ticket when multi-ticket.
- Claims coordinate; serial if not atomic.
- Recompute frontiers after resolutions.

## Support Disciplines

`/research` and `/prototype` remain evidence-only for engineering questions.
`/tdd`, `/simplify`, `/code-review` compose under `/implement`.

## Legacy Compatibility

`SPEC.md`, `tickets/`, `bugs/` remain. Historical PRDs/issues stay valid inputs.
Retired from this pack (now optional external packs): `to-prd`, `to-issues`
(product), `to-test-plan`, `qa-run` (test).
