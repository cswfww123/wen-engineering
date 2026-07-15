# WEN Layer Boundaries (Coding)

Companion to [lifecycle.md](lifecycle.md) and [handoff-package.md](handoff-package.md).

## Composition: standalone **or** linked

`wen-pm` · `wen-engineering` · `wen-test` are **three independent packs**.

| Mode | Meaning |
| --- | --- |
| **Standalone** | Daily coding on settled AC, tickets, bugs, light intent pins, eng wayfinder — no PM/test required |
| **Linked** | Fuzzy product work uses `wen-pm`; system QA uses `wen-test`; hand off durable artifacts — never hard-fail if missing |

```text
# linked (only the layers you run)
HEAVY  wen-pm ──handoff──► LIGHT wen-engineering ──build──► wen-test

# light-only daily
AC / bug / ticket → /implement
settled multi-slice → /to-spec → /to-tickets → /implement
```

## Two tracks

| Track | When | Entry |
| --- | --- | --- |
| **LIGHT** (default) | Product intent good enough to code | This pack — smallest step (`/implement` first) |
| **HEAVY** | Product need / market / user still fuzzy | Full PM (`wen-pm` `/pm-intake` or team PM) — not coding skills |

## Ownership

| Layer | Pack | Owns |
| --- | --- | --- |
| Product (heavy) | optional `wen-pm` | discovery, evidence, Build/Bet, Delivery Contract |
| **Coding (light)** | **this repo** | implement, to-spec/tickets, product-fog pin, wayfinder, TDD, review |
| Test | optional `wen-test` | system test plans, QA |

## Coding owns / does not own

| Owns | Does not own |
| --- | --- |
| LIGHT L1–L4 routes | Inventing Expected / market bets |
| `/product-fog` as **thin** intent pin | Full interviews, OST, experiment design |
| `/wayfinder` multi-session eng fog | Mandatory `wen-pm` installation |
| Layer-scoped implementer fidelity | System `/to-test-plan` / `/qa-run` |

## Skill map

| Need | Track | Where |
| --- | --- | --- |
| Daily bug / clear AC | LIGHT | `/implement` |
| Settled multi-slice | LIGHT | `/to-spec` → `/to-tickets` → `/implement` |
| Same-session plan pin (in-flow) | LIGHT **G** | `/grill-me` (+ `/domain-modeling`) |
| Mild intent gap in coding context | LIGHT | `/product-fog` (often → grill) |
| Multi-session eng fog | LIGHT | `/wayfinder` (prefer grill if one session) |
| Fuzzy need / market / "should we build" | **HEAVY** | `wen-pm` `/pm-intake` … |
| System QA | test | optional `wen-test` |

## Layer scope (FE / BE)

| Scope | Developer gates |
| --- | --- |
| Frontend-only | Behavior + UI fidelity when UI changes; pin API/mocks at boundary |
| Backend-only | Behavior + API/contract fidelity; no UI pin |
| Full-stack | Only surfaces this ticket changes |

See [handoff-package.md](handoff-package.md).
