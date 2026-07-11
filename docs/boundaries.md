# Engineering vs PM Boundaries

Companion to [lifecycle.md](lifecycle.md) and [handoff-package.md](handoff-package.md).
Keeps this skill pack light and production-coding-focused.

## Ownership

| Layer | Owns | Does not own |
| --- | --- | --- |
| **PM** (`wen-pm`, `/pm-intake`) | Product/market/need discovery; Build/Bet; Product Delivery Contract; UI contract + pin; `SCN` | Shipping production code; eng implementation tickets |
| **Engineering** (this repo) | Specs, technical discovery, slicing, implement, review, QA; **UI fidelity** vs pin | Inventing user value or Expected behavior |

## Two kinds of fog

| Fog | Examples | Route |
| --- | --- | --- |
| **Product fog** | Worth doing? Who? Outcome? Inner need after rejection? | `/pm-intake` — never engineering Wayfinder |
| **Technical fog** | Migration, ownership, contracts, dual-write, test seams | `/grill-with-docs` or slim `/wayfinder` after product is settled |

## Admission into engineering

Enter coding skills only when at least one holds:

1. **Settled product package** — Build/Bet Product Delivery Contract with
   `REQ-*` / `AC-*`; when UI is in scope, complete UI contract + pin (see
   [handoff-package.md](handoff-package.md)).
2. **Pure engineering work** — migration, reliability, performance, platform,
   or defect fix where product behavior is already defined or unchanged.
3. **Explicit user authority** to implement a named technical change with a
   stated acceptance boundary.

Otherwise: name the product gap and stop. Recommend PM discovery.

## Handoff from PM

Prefer the handoff package over chat paraphrase. Full checklist:
[handoff-package.md](handoff-package.md).

```text
PM: to-prd → test-scenarios → [optional to-issues]
  -> /to-spec → /to-tickets → /implement
  -> /qa-run   # behavior + UI fidelity when visual
```

PM `to-issues` is human-board only — never the agent frontier.

**UI admission (visual work):** refuse prose-only screenshots. Require
`SCR-*` / `FLD-*` / `RULE-*` and a pinned delivery prototype version (or an
explicit non-pin reason). Missing pieces → stop and list gaps for PM.

Use technical `/wayfinder` only if product is settled but the **implementation
route** still cannot be specified honestly in one session.

## Completion gates

| Gate | When | Required |
| --- | --- | --- |
| Behavior | every ticket | tests / SCN / verification match `AC-*` |
| Fidelity | ticket touches UI | fields, labels, linkage, and UI states match UI contract + pin |

Do not close UI tickets on behavior-green alone. Contract errors return to PM;
implementation errors stay in eng.

## Handoff back to PM

Return work to PM when:

- intended behavior is disputed or underspecified
- fidelity failure is a **contract** gap (wrong/missing FLD/RULE/pin)
- a "bug" is product rework without authorized Expected

Send: repo-backed Current, statements as statements, failing AC/SCN/FLD/RULE
IDs, and the open product question — not a guessed Expected.

## Skill map (lightweight)

| Need | Skill |
| --- | --- |
| Bounded coding task | `/implement` |
| Settled multi-slice | `/to-spec` → `/to-tickets` → `/implement` |
| Same-session tech plan sharpen | `/grill-with-docs` |
| Multi-session **technical** fog | `/wayfinder` (rare) |
| Product/market/need fog | **Stop** → `/pm-intake` |
