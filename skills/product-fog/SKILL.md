---
name: product-fog
description: Light intent pin in coding context — mini docket, no invented Expected, one next route.
disable-model-invocation: true
---

# Product Fog

**LIGHT L3** bridge: pin product intent when you are already in a coding context
and a mild gap blocks honest implement/spec. Mini docket → **exactly one** next
action. Not full product discovery. Not production code. Never invent Expected.

Lifecycle: `docs/lifecycle.md` (LIGHT vs HEAVY). Output: [DOCKET.md](DOCKET.md).

## When (LIGHT only)

Use when:

- Rework after "not what I wanted" and Expected is unclear but work is coding-adjacent
- Mild intent/scope gap while preparing `/to-spec` or `/implement`
- Need a written pin before choosing grill / wayfinder / stop

**Do not use as the front door for HEAVY fuzzy need.** If worth-doing, target
user, market, or unvalidated idea is the open problem:

- Prefer **HEAVY**: `wen-pm` `/pm-intake` (or team PM) when available
- If no PM pack: disposition `Escalate-PM` or `Discovery` / `Pause` / `Kill` —
  refuse to start coding pipelines

**Skip immediately (other LIGHT entries):**

- Named defect / clear AC → `/implement`
- Build-ready REQ/AC package → `/to-spec`
- Product settled, multi-session technical fog → `/wayfinder`

## Steps

### 1. Inspect before asking

Inventory conversation, docs, screenshots, repo, runtime. Trace existing user
paths when relevant. List inaccessible sources; do not guess.

### 2. Classify

| Track | Meaning |
| --- | --- |
| `pure-eng` | Intent settled enough to code |
| `existing-change` | Current behavior must be understood/fixed/extended; rejection rework |
| `new-idea` | No relevant implemented behavior |

If track is `new-idea` and evidence of need is absent → prefer HEAVY
(`Escalate-PM` / `Discovery`), not fake Build-ready.

### 3. Mini docket

Load [DOCKET.md](DOCKET.md). **existing-change:** Current / Expected / Delta;
Expected = decision, quote, or `Unresolved` only. **new-idea:** one load-bearing
assumption + falsification idea. Risk colors: green/yellow/red/`UNKNOWN`.

### 4. One disposition → one next action

| Disposition | Next |
| --- | --- |
| `pure-eng` | `/implement` or `/to-spec` |
| `Align` | `/grill-with-docs` or `/wayfinder` |
| `Build-ready` | `/to-spec` |
| `Discovery` | Stop; name real-user evidence needed; optional HEAVY PM |
| `Pause` | One named missing source/owner |
| `Kill` | Record why; stop |
| `Escalate-PM` | Full `wen-pm` stack (interviews, OST, to-prd) |

No menus. Do not open Wayfinder maps or publish specs from this skill.

## Hard rules

- No production or implementation-tracker mutations
- No fabricated Expected, user value, or market bets
- HEAVY discovery is optional and never required for pure LIGHT coding
