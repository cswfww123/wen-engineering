# Engineering Boundaries And Adaptability

Companion to [lifecycle.md](lifecycle.md) and
[handoff-package.md](handoff-package.md). This pack is **coding-first** and
**PM-optional**.

## Ownership

| Layer | Owns | Does not own |
| --- | --- | --- |
| **Product / design** (any process) | Worth-doing, intent, acceptance, UI rules, delivery design pins | Shipping production code in this pack |
| **Engineering** (this repo) | Specs, technical discovery, FE and/or BE implementation, review, QA gates scoped to layer | Inventing user value or Expected behavior |
| **wen-pm** (optional companion) | One possible product process (`/pm-intake` …) | Required dependency of this pack |

## Two kinds of fog

| Fog | Examples | Route |
| --- | --- | --- |
| **Product fog** | Worth doing? Who? Outcome? What they really meant? | Stop inventing answers; use the team's product process (optional: `/pm-intake`) |
| **Technical fog** | Migration, ownership, contracts, dual-write, test seams | `/grill-with-docs` or slim `/wayfinder` after intent is settled |

## Admission

Enter coding skills when at least one holds:

1. **Settled delivery inputs** for the **layer in scope** (see
   [handoff-package.md](handoff-package.md)) — not necessarily a wen-pm PRD.
2. **Pure engineering** — migration, reliability, performance, platform, or
   defect fix with product behavior defined or unchanged.
3. **Explicit user authority** for a named technical change with a clear
   acceptance boundary.

Otherwise: name the gap and stop. Recommend product/design owners — not
engineering Wayfinder for product discovery.

## Layer-scoped work (FE / BE / full-stack)

| Scope | Default gates |
| --- | --- |
| Frontend-only | Behavior + **UI fidelity** (when UI changes); pin API/mocks at the boundary |
| Backend-only | Behavior + **API/contract fidelity**; no UI pin required |
| Full-stack | Both, for the surfaces the ticket actually changes |

Do not force backend tickets through UI prototype gates. Do not force
frontend-only tickets to implement backend. Record out-of-scope layers and
integration owners on the ticket.

## Delivery inputs (any source)

Prefer durable inputs over chat paraphrase. Full checklist:
[handoff-package.md](handoff-package.md).

```text
settled inputs (PM optional)
  -> /to-spec -> /to-tickets -> /implement
  -> /qa-run   # gates match layer scope
```

Human boards are never the agent execution frontier.

**UI admission** applies only when **this work** changes user-visible UI.
**API admission** applies when **this work** changes published contracts.

## Completion gates

| Gate | When |
| --- | --- |
| Behavior | every ticket |
| UI fidelity | ticket changes user-visible UI |
| Contract fidelity | ticket changes published API/events |

Contract/product errors return to the product/design owner (optional PM).
Implementation errors stay in eng.

## Skill map

| Need | Skill |
| --- | --- |
| Bounded coding task | `/implement` |
| Settled multi-slice | `/to-spec` → `/to-tickets` → `/implement` |
| Same-session tech plan sharpen | `/grill-with-docs` |
| Multi-session **technical** fog | `/wayfinder` (rare) |
| Product/market/need fog | **Stop** → team's product process (optional `/pm-intake`) |
