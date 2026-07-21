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
L1  clear work              → /implement
L2  multi-slice             → /to-spec → /to-tickets → /implement
G   same-session pin        → /grill-me → (chat recap default) → /implement
                            → durable archive / /to-spec only if cross-session handoff
Q   stakeholder questionnaire → /to-questionnaire → fill → ingest → /to-spec
L3  mild intent pin         → /product-fog → one next
L4  multi-session eng fog   → /wayfinder → (resolved) → L2
```

### Environment and artifact hygiene (agent-side — do not interview the user)

These are **automatic**. Prefer code and open tracker state; do not add user steps.

1. **Code is the environment.** Wire values, production call paths, and tests beat month-old process notes. Dangerous legacy patterns are do-not-copy, not templates.
2. **Smallest honest step.** Clear AC / bug / one slice → L1 `/implement`. Do not open G/Q/L2/L4 (or create decision files) for thoroughness theater.
3. **Same-session default = no new process docs.** `/grill-me` settles in chat; write `decision-*` / extra archives only for another session, another agent, Wayfinder ticket resolution, or explicit user ask.
4. **Load only active work.** Ignore closed / resolved / delivered tickets, maps, and consumed grill notes when deciding how to build *now*.
5. **Hygiene without asking.** After a handoff file is consumed (spec written, ticket closed, implement done), stop citing it; delete or cold-ignore silently. Never prompt the user to approve doc cleanup.
6. **Ask the user only** for product intent they own or irreversible environment-changing migrations — not for “save this md?” or “trust code or doc?”

Human-facing walkthrough (same flows, longer form): root `README.md` /
`README.zh-CN.md` **Lifecycle** section.

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
  → /grill-me   (loads /grilling; domain-modeling only if terms truly change)
```

**In the flow**, not optional fluff — but **not a documentation factory**. Use when:

- Before `/implement` (or rarely `/to-spec`), a few user-owned decisions are open
- L4 would be overkill (no multi-session map yet)
- L3 routed `Align` for same-session trade-offs

**Default out:** shared understanding **in the chat** + optional short recap.
Do **not** require `decision-*.md` / `docs/decisions/` for same-session work
(Matt-upstream `grill-me` is interview-only; durable docs are the exception).

Frontier rounds with recommended answers (batch table / decision surface by
default — not serial micro-Qs); facts from the repo first, non-blocking where
lookups can run in parallel (see `/grilling`). Durable archive only for
cross-session handoff, Wayfinder ticket close, or explicit user ask. If one
session is not enough → L4 `/wayfinder`. If product need itself is fuzzy →
**HEAVY** PM, not grill. If answers live with another person / a clarification
meeting → **Q** `/to-questionnaire`, then resume G.

### Q — Stakeholder questionnaire (meeting or async)

```text
user is not the product/domain owner for open decisions
  → /to-questionnaire  (options + 推荐 + 手写)
  → fill in meeting or async
  → paste back (问卷已填) → ingest, no re-confirm
  → default /to-spec
  → short /grill-me only for eng residual
```

**In the flow** when grill would only produce "I don't know — ask PM". Use for
需求澄清会 prep or a single async pass. Grill the *send* (who + what you need
back), not a fake product discovery. Questions ship with **options + recommended
answer + free-text override**. Filled answers are **settled** — do not re-ask.
Default return is **`/to-spec`**; `/grill-me` only for remaining engineering
frontier. Never invent Expected. Still not a substitute for HEAVY PM when
worth-doing / market is open.

### L3 — Light product intent gap (still coding-adjacent)

```text
rework / mild Expected gap / "not quite what I meant"
  → /product-fog  →  one next skill in this pack
```

Mini docket only. Never invent Expected. Common next hops: **G**
`/grill-me`, **Q** `/to-questionnaire`, L2 `/to-spec`, L4 `/wayfinder`, stop, or
**Escalate-PM**.

Use when already in a coding context — **not** as market discovery.

### L4 — Multi-session engineering fog

```text
product settled enough, technical route still foggy
  → /wayfinder (thin map) → /to-spec → /to-tickets → /implement
```

**Try G first.** Open a map only when decisions need multiple sessions or a
shared frontier. Chart budget ≤5 tickets; research/task over grill; short
pastes in `skills/wayfinder/CONTINUE.md` (human should not re-paste the whole
brief each session).

At most one **HITL** decision ticket per session by default; research and AFK
tasks may batch. Plan only — never ship the destination inside the map.

**When the map is `resolved`:** stop `/wayfinder`. Go **L2** — `/to-spec` →
`/to-tickets` → `/implement`. Do not re-grill closed DECs; consume Resolutions.

### Support (compose under the above)

| Need | Skill |
| --- | --- |
| Public-behavior tests | `/tdd` (Matt red → green + seams) |
| Cleanup | `/simplify` (WEN) |
| Diff review | `/code-review` (Matt Standards+Spec; optional WEN axes) |
| Evidence only | `/research`, `/prototype` |
| Domain terms / ADRs | `/domain-modeling` |
| Same-session interview | `/grill-me` → `/grilling` (+ `/domain-modeling`) |
| Stakeholder questionnaire | `/to-questionnaire` (meeting or async) |
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
| Need product answers from another person / 澄清会 | LIGHT **Q** | `/to-questionnaire` → ingest → default `/to-spec` |
| Stakeholder: shipped but wrong; Expected unclear | LIGHT L3 | `/product-fog` (often → G or Q) |
| Migration/contracts too big for one session | LIGHT L4 | `/wayfinder` (try G first; then L2) |
| Wayfinder map already resolved | LIGHT L2 | `/to-spec` (not more wayfinder) |
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
