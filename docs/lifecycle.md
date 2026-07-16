# WEN Engineering Lifecycle

Routing source of truth. Follow the **shape of the work** — not every request
fills every form.

This pack is **standalone or linked** with optional `wen-pm` / `wen-test` — never
hard-require those packs.

| Layer | Pack | Role |
| --- | --- | --- |
| Product (heavy) | optional `wen-pm` | fuzzy need / market / discovery → Delivery Contract |
| Coding (this pack) | **wen-engineering** | light daily coding + thin intent bridge + wayfinder |
| Test | optional `wen-test` | system test plan + QA |

See [boundaries.md](boundaries.md) and [handoff-package.md](handoff-package.md).

---

## Choose track first (one question)

```text
Is the product need itself fuzzy?
  (worth-doing, target user, market, unvalidated idea, "what should we build?")
    → HEAVY: full product discovery (wen-pm / team PM)
    → then hand settled package into this pack

Is the product intent good enough to code against?
  (named AC, bug, settled multi-slice, pure eng)
    → LIGHT: start in this pack at the smallest step that fits
```

**Default bias for daily work: LIGHT.** Do not open PM, Wayfinder, or multi-skill
pipelines when `/implement` is enough.

---

## LIGHT — daily coding (default)

Start at the **smallest** honest step. Escalate only when that step fails.

```text
L1  clear work        → /implement
L2  multi-slice       → /to-spec → /to-tickets → /implement
G   same-session pin  → /grill-me          ← still in the flow
L3  mild intent gap   → /product-fog → one next (often G or L2/L4)
L4  multi-session fog → /wayfinder → L2
```

### L1 — One-context settled work

```text
bug | clear AC | pure eng slice  →  /implement
```

Evidence loop (TDD or GREEN baseline), `/simplify` when non-trivial, project
checks, `/code-review`, done. No invented spec or ticket.

Hard diagnosis first: `/diagnosing-bugs`. Fix authority uses the same implement
loop.

### L2 — Settled multi-slice (default multi-session coding)

```text
settled package (PRD / docs / chat AC / PM handoff)
  → /to-spec → /to-tickets → /implement
  → (optional) wen-test: /to-test-plan → /qa-run
```

Scope FE/BE fidelity to the ticket layer. `/implement` never closes the parent
spec. Slice risk: `/alignment-review`.

### G — Same-session grill (first-class LIGHT tool)

```text
plan/design still fuzzy, but one interview can clear it
  → /grill-me   (loads /grilling + /domain-modeling)
```

**In the flow**, not optional fluff. Use when:

- Before `/to-spec` or `/implement`, a few user-owned decisions are open
- L4 would be overkill (no multi-session map yet)
- L3 routed `Align` for same-session trade-offs

One question at a time, recommended answers, facts from the repo first (see
`/grilling`: facts vs decisions, confirmation gate). Runs with
`/domain-modeling` active so glossary/ADR update as terms crystallize. If one
session is not enough → L4 `/wayfinder`. If product need itself is fuzzy →
**HEAVY** PM, not grill.

### L3 — Light product intent gap (still coding-adjacent)

```text
rework / mild Expected gap / "not quite what I meant"
  → /product-fog  →  one next skill in this pack
```

Mini docket only. Never invent Expected. Common next hops: **G**
`/grill-me`, L2 `/to-spec`, L4 `/wayfinder`, stop, or **Escalate-PM**.

Use when already in a coding context — **not** as market discovery.

### L4 — Multi-session engineering fog

```text
product settled enough, technical route still foggy
  → /wayfinder → /to-spec → /to-tickets
```

At most one non-research **decision ticket** per session (research tickets may
burn down via parallel `/research` subagents). Prefer **G** `/grill-me` first if
one interview would clear it. Plan only — never ship the destination.

### Support (compose under the above)

| Need | Skill |
| --- | --- |
| Public-behavior tests | `/tdd` (Matt red → green + seams) |
| Cleanup | `/simplify` (WEN) |
| Diff review | `/code-review` (Matt Standards+Spec; optional WEN axes) |
| Evidence only | `/research`, `/prototype` |
| Domain terms / ADRs | `/domain-modeling` |
| Same-session interview | `/grill-me` → `/grilling` (+ `/domain-modeling`) |
| Merge/rebase conflicts | `/resolving-merge-conflicts` |

---

## HEAVY — fuzzy product requirements

When the **need / market / user / worth-doing** is the open problem, do **not**
start with `/implement`, `/to-spec`, or a technical Wayfinder map.

```text
fuzzy idea | unknown user | market bet | "should we build this?"
  → full product discovery
  → preferred: wen-pm /pm-intake → … → Build|Bet → to-prd
  → then LIGHT L2: /to-spec → /to-tickets → /implement
```

| Heavy owns | Light must not do |
| --- | --- |
| Customer interviews, experiments, OST | Invent Expected or market bets |
| Four-risk deep evidence, Kill/Pause/Pivot | Pretend mini docket = discovery complete |
| Product Delivery Contract | Open eng map to invent product value |

If `wen-pm` is **not** installed: stop inventing; name the missing human/PM
process and the evidence still required. Optional: `/product-fog` only to record
`Discovery` / `Pause` / `Kill` and refuse to code.

---

## Quick chooser

| Situation | Track | Entry |
| --- | --- | --- |
| Fix this bug / do this AC | LIGHT L1 | `/implement` |
| Feature with settled PRD/AC, multi-slice | LIGHT L2 | `/to-spec` |
| Few open decisions; one session can pin them | LIGHT **G** | `/grill-me` |
| Stakeholder: shipped but wrong; Expected unclear | LIGHT L3 | `/product-fog` (often → G) |
| Migration/contracts too big for one session | LIGHT L4 | `/wayfinder` (try G first) |
| Vague idea, no validated need | **HEAVY** | `wen-pm` `/pm-intake` |
| System QA of a build | optional test | `wen-test` |

---

## Artifact model (coding)

- **Spec** — non-runnable parent  
- **Implementation ticket** — one vertical slice; AFK → implementation frontier  
- **Wayfinder map / ticket** — multi-session discovery; never implement as code  
- **Bug report** — non-runnable until converted  
- **Product-fog docket** — session pin only; not a PRD  

## One ticket, one reviewable delta

```text
claim → behavior test or compatibility baseline → simplify → verify → code-review → close
```

## Context and concurrency

- Fresh context per implementation ticket when multi-ticket  
- Claims coordinate; serial if not atomic  
- Recompute frontiers after resolutions  

## Legacy

`SPEC.md`, `tickets/`, `bugs/` remain. Historical PRDs stay valid inputs.
Retired from this pack: product `to-prd` / `to-issues` (optional `wen-pm`);
system `to-test-plan` / `qa-run` (optional `wen-test`).
