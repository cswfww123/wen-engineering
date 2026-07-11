# WEN Layer Boundaries (Coding)

Companion to [lifecycle.md](lifecycle.md) and [handoff-package.md](handoff-package.md).

## Composition contract: standalone **or** linked

`wen-pm` · `wen-engineering` · `wen-test` are **three independent packs**.

| Mode | Meaning |
| --- | --- |
| **Standalone** | This pack alone is enough for coding work when the user brings settled AC, a ticket, or pure eng tasks. Do **not** require `wen-pm` or `wen-test` to be installed. |
| **Linked** | When those packs exist and the user routes across layers, prefer their durable artifacts; recommend them — never hard-fail if missing. |

```text
# linked (all optional except the layer you actually run)
wen-pm ──► wen-engineering ──► wen-test

# standalone coding
user AC / ticket / bug → /implement
or settled multi-slice → /to-spec → /to-tickets → /implement
```

## Ownership

| Layer | Pack | Owns |
| --- | --- | --- |
| Product | optional any PM process / `wen-pm` | intent, delivery contract, product SCN |
| **Coding** | **this repo** | specs, tickets, implement, TDD, code-review, technical wayfinder |
| Test | optional `wen-test` | system test plans, QA execution, completion judgment |

## Coding owns / does not own

| Owns | Does not own |
| --- | --- |
| `/to-spec`, `/to-tickets`, `/implement` | Product discovery |
| `/tdd`, `/simplify`, `/code-review` | System `/to-test-plan`, `/qa-run` |
| Technical `/wayfinder`, `/research`, `/prototype` | Inventing Expected product behavior |
| Layer-scoped implementer fidelity (FE/BE) | Independent acceptance QA sign-off |

## Standalone coding

Valid without PM or test packs:

- clear bugfix or named AC → `/implement`  
- multi-slice with settled intent from **any** PRD/docs/chat-approved AC → `/to-spec` → …  
- human or CI performs QA outside this pack  

Product fog → stop inventing; hand to product owner (mention `/pm-intake` **only if** the team uses `wen-pm`).

## Linked spine (when other packs are used)

```text
(optional PM package) → /to-spec → /to-tickets → /implement
  → (optional) wen-test /to-test-plan → /qa-run
  → defects → /implement or product rework
```

Do not hard-chain coding skills into `/qa-run` inside this pack.

## Layer scope (FE / BE)

| Scope | Developer gates |
| --- | --- |
| Frontend-only | Behavior + UI fidelity when UI changes; pin API/mocks at boundary |
| Backend-only | Behavior + API/contract fidelity; no UI pin |
| Full-stack | Only for surfaces this ticket changes |

See [handoff-package.md](handoff-package.md).

## Skill map

| Need | Where |
| --- | --- |
| Bounded coding | `/implement` |
| Multi-slice coding | `/to-spec` → `/to-tickets` → `/implement` |
| Tech multi-session fog | `/wayfinder` (rare) |
| System test/QA | optional **`wen-test`** |
| Product fog | team's product process (optional `/pm-intake`) |
