# Engineering Boundaries (Coding Layer)

Companion to [lifecycle.md](lifecycle.md) and [handoff-package.md](handoff-package.md).

## Three optional layers

| Layer | Pack | Owns |
| --- | --- | --- |
| Product | optional `wen-pm` or any PM process | intent, delivery contract, product scenarios |
| **Coding** | **this repo** | specs, tickets, implement, TDD, code-review, technical wayfinder |
| Test | optional `wen-test` | system test plans, QA execution, completion judgment, defect filing |

This pack must work **alone**. It does not require `wen-pm` or `wen-test`.

## Coding owns / does not own

| Owns | Does not own |
| --- | --- |
| `/to-spec`, `/to-tickets`, `/implement` | Product discovery |
| `/tdd`, `/simplify`, `/code-review` (dev quality) | System `/to-test-plan`, `/qa-run` (moved to `wen-test`) |
| Technical `/wayfinder`, `/research`, `/prototype` | Inventing Expected product behavior |
| FE/BE layer-scoped implementer fidelity checks | Independent acceptance QA sign-off |

## Product fog

Stop inventing. Hand to product/design owner (optional `/pm-intake`).

## After implement

```text
/implement done (dev green + layer fidelity)
  -> optional wen-test /to-test-plan + /qa-run
  -> or human QA / CI policy
  -> defects back to /implement or product rework
```

Do not hard-chain coding skills into `/qa-run` as a mandatory next step inside
this pack. Recommend the test pack when system verification is needed.

## Layer scope (FE / BE)

Unchanged: frontend-only, backend-only, full-stack gates for **implementation**
admission and developer fidelity. See [handoff-package.md](handoff-package.md).

## Skill map

| Need | Skill |
| --- | --- |
| Bounded coding | `/implement` |
| Multi-slice coding | `/to-spec` → `/to-tickets` → `/implement` |
| Tech plan sharpen | `/grill-with-docs` |
| Tech multi-session fog | `/wayfinder` (rare) |
| System test design/exec | **`wen-test`**: `/to-test-plan`, `/qa-run` |
| Product fog | team's product process (optional `/pm-intake`) |
