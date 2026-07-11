# Engineering vs PM Boundaries

Companion to [lifecycle.md](lifecycle.md). Keeps this skill pack light and
production-coding-focused.

## Ownership

| Layer | Owns | Does not own |
| --- | --- | --- |
| **PM** (`wen-pm`, `/pm-intake`) | Product/market/need discovery; interviews; evidence ledger; Build/Bet authorization; PRD-level product decisions | Shipping production code; implementation tickets; CI green |
| **Engineering** (this repo) | Engineering specs, technical discovery, slicing, implement, review, QA of code | Inventing user value, market bets, or "what they really meant" |

## Two kinds of fog

| Fog | Examples | Route |
| --- | --- | --- |
| **Product fog** | Worth doing? Who? What outcome? What did the stakeholder really need? Opportunity vs solution | `/pm-intake` — never engineering Wayfinder |
| **Technical fog** | Migration path, ownership of an invariant, API contract, dual-write, test seam, failure modes | `/grill-with-docs` (same session) or slim `/wayfinder` (multi-session) **after** product is settled |

## Admission into engineering

Enter coding skills only when at least one holds:

1. **Settled product intent** — authorized Build/Bet PRD or equivalent: problem,
   outcome, scope/out-of-scope, intended behavior, and acceptance examples are
   explicit (IDs optional but preferred).
2. **Pure engineering work** — migration, reliability, performance, platform,
   or defect fix where product behavior is already defined or unchanged.
3. **Explicit user authority** to implement a named technical change with a
   stated acceptance boundary.

Otherwise: name the product gap and stop. Recommend PM discovery.

## Handoff from PM (expected inputs)

When work arrives from PM, prefer these artifacts over chat paraphrase:

- disposition `Build` or complete bounded `Bet`
- problem, outcome, scope, non-scope
- intended behavior and acceptance examples (`REQ-*` / `AC-*` when present)
- evidence or Bet contract references (`EV-*` / `X-*` / `A-*` + Bet `D-*`)
- any feasibility notes already confirmed by engineering owners

Engineering then:

```text
PM handoff -> /to-spec (or /implement if one-context)
           -> /to-tickets when multi-slice
           -> /implement per frontier ticket
```

Use technical `/wayfinder` only if the handoff is product-settled but the
**implementation route** still cannot be specified honestly in one session.

## Handoff back to PM

Return work to PM when:

- intended behavior is disputed or unspecified after implementation feedback
- value, usability, or viability claims lack authorization
- a "bug" is really a product rework request without Expected behavior

Send: observed Current behavior (repo-backed), stakeholder statements as
statements, and the open product question — not a guessed Expected.

## Skill map (lightweight)

| Need | Skill |
| --- | --- |
| Bounded coding task | `/implement` |
| Settled multi-slice | `/to-spec` → `/to-tickets` → `/implement` |
| Same-session tech plan sharpen | `/grill-with-docs` |
| Multi-session **technical** fog | `/wayfinder` (rare) |
| Product/market/need fog | **Stop** → `/pm-intake` |
