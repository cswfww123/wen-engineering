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

Pack-repo background (not installed): `docs/boundaries.md`, `docs/handoff-package.md`.

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
L1  clear work (bug, AC, one slice) → /implement
G   requirement — default entry  → /grill-code (entry sweep → residual frontier)
                                  → /implement | (multi-slice) /to-spec
L2  multi-slice spec spine       → /to-spec → /to-tickets → /implement (one ticket) | /implement-spec (parallel frontier)
                                  (usually the hop after G; direct entry when the sweep shows zero poles)
Q   stakeholder questionnaire → /to-questionnaire → fill → ingest → /to-spec
L3  mild intent pin         → /product-fog → one next
L4  multi-session eng fog   → /wayfinder → (resolved) → L2
```

### Environment and artifact hygiene (agent-side — do not interview the user)

These are **automatic**. Prefer code and open tracker state; do not add user steps.

1. **Code is the environment.** Wire values, production call paths, and tests beat month-old process notes. Dangerous legacy patterns are do-not-copy, not templates. Same-surface chrome **extends the owner** already on that screen ([SAME-SURFACE.md](../code-review/SAME-SURFACE.md)) — a CSS-matched lookalike is not reuse. **Code does not override an active product requirements doc** for *what we should build* — that is product intent (implement the gap, or get an explicit authorized delta). Hard gates: [PRD-AUTHORITY.md](../to-spec/PRD-AUTHORITY.md).
2. **Smallest honest step.** Clear AC / bug / one slice → L1 `/implement` (PRD / 原型图 in play → still extract inventory + pin rows first, [PRD-AUTHORITY.md](../to-spec/PRD-AUTHORITY.md) §2). Do not open G/Q/L2/L4 (or create decision files) for thoroughness theater. Every other requirement (named product docs `docs/requirements/*`, `docs/prd/*` included) → **G** `/grill-code`: entry sweep (facts-first collision map) then **residual poles only** — never a full product re-grill. Sweep shows zero poles → L2 `/to-spec` with a PRD Inventory. User **按原文** revokes listed `相对 PRD` ids via L3 — do not re-grill the package.
3. **Same-session default = no new process docs.** `/grill-code` settles in chat; write `decision-*` / extra archives only for another session, another agent, Wayfinder ticket resolution, or explicit user ask. Grill may pin residual eng seams; it must **not** silently supersede an active PRD — PRD deltas require labeled `相对 PRD` accept.
4. **Load only active work.** Ignore closed / resolved / delivered tickets, maps, and consumed grill notes when deciding how to build *now*. Still load the **active product requirements / eng spec** for the feature under build.
5. **Hygiene without asking.** After a handoff file is consumed (spec written, ticket closed, implement done), stop citing it; delete or cold-ignore silently. Never prompt the user to approve doc cleanup.
6. **Ask the user only** for product intent they own or irreversible environment-changing migrations — not for “save this md?” or “trust code or doc?” Do not ask them to choose “grill AC vs PRD” when the pack already ranks product doc first; only ask when a **labeled** PRD delta is proposed.
7. **Agent owns entry routing.** Classify incoming work from the request itself (bug → `/diagnosing-bugs`; fuzzy product → HEAVY gate; clear AC / one slice → L1; otherwise → G) and enter the matching flow — do **not** interview the user to pick a skill. User-typed slash commands are manual overrides, not the only door. Mid-flow hops still wait for the user's order (grill close gate, `/implement` | 「开干」).

Human-facing walkthrough (same flows, longer form): root `README.md` /
`README.zh-CN.md` **Lifecycle** section.

### L1 — One-context settled work

```text
bug | clear AC | pure eng slice  →  /implement
```

Parent plans the brief, Executor runs it (TDD, or GREEN baseline for no-behavior slices), parent accepts; `/simplify` when non-trivial, project
checks, then review by size (`none` skips, `light`, or `full` — `/code-review`
**Pick weight**), done. A finished tracked ticket is closed in the same run
and read back as closed; an unfinished ticket stays open. No invented spec or ticket.

Hard diagnosis first: `/diagnosing-bugs`. Fix authority uses the same implement
loop. If diagnosis yields a multi-step fix **proposal**, freeze a design packet and
hard-try pack `Reviewer` (design axes; prefer another model) before coding —
[DESIGN-REVIEW-BRIEF.md](../code-review/DESIGN-REVIEW-BRIEF.md); then user scopes
MVP and continues `/implement` or L2.

### L2 — Multi-slice spec spine (usually the hop after G)

```text
requirement settled at G (or direct entry when the sweep showed zero poles)
  → /to-spec → /to-tickets → /implement
  → (optional) wen-test: /to-test-plan → /qa-run
```

Usually reached **from G**: `/grill-code` settled the poles and labeled PRD
deltas in chat; `/to-spec` synthesizes and publishes. Direct entry is equally
valid (user names the package, or the entry sweep showed zero open poles) —
the PRD Inventory then re-runs the collision check, and HITL rows it surfaces
get **one residual grill round** before `accepted`
([PRD-AUTHORITY.md](../to-spec/PRD-AUTHORITY.md) §1–2).

**Which executor for the tickets:** one ticket at a time → `/implement`
(fresh context per ticket). Two or more unblocked AFK tickets on the frontier
and the user wants the package run in one go → `/implement-spec` (parallel
Executors, per-ticket accept + review, serial merge, package close).

Scope FE/BE fidelity to the ticket layer. The parent spec closes only after
its last child and a clean prd-walk (last-ticket `/implement` or
`/implement-spec` step 9). Coverage and slice shape are enforced by `/to-tickets` pre-publish gate
(inventory `SRC` in `Covers`; `Supports` does not count) —
default path does **not** run `/alignment-review` after every publish.
**Exception (mandatory):** PRD-sourced package close — last open ticket, or
“已按 PRD 实现” — run `/alignment-review` **prd-walk** against the **original
product doc** ([PRD-AUTHORITY.md](../to-spec/PRD-AUTHORITY.md) §5). Any `缺` blocks
delivered. Use `/alignment-review` otherwise only as a manual audit of handoff
or unreviewed artifacts.

### G — Grill (default requirement entry)

```text
any requirement that is not a bug, not clear-AC, not a single slice
  → /grill-code   (loads /grilling; domain-modeling only if terms truly change)
      entry: facts-first sweep (PRD package → PRD-package entry sweep, hard gate)
      frontier: open poles only — under a PRD, residual poles only
```

**In the flow**, not optional fluff — but **not a documentation factory**. Use when:

- Default entry for requirements: AC not clear yet, decision count **unknown** — the entry sweep counts them
- Under a named PRD: entry sweep first, then **residual poles only** (contradiction, unmapped term, eng seam). **Forbidden:** full product grill that re-authors settled PRD rows. Labeled `相对 PRD` deltas must declare `doc-change` vs `eng-read`
- Sweep shows zero open poles → skip the interview; hop L2 `/to-spec` (multi-slice) or L1 directly
- L4 would be overkill (no multi-session map yet); L3 routed `Align` for same-session trade-offs

**Default out:** one **briefing** in the chat, composed with the installed `show-me` skill (settled choices, what changes, one diagram — using its smallest fitting shape), then stop. Build starts only when the user says **`/implement`** or **「开干」**. `按推荐` closes a row; it is not that order.
Do **not** require `decision-*.md` / `docs/decisions/` for same-session work
(Matt-upstream `grill-me` is interview-only; this pack's coding grill is `/grill-code`. Durable docs are the exception. Non-coding plans use `/grill-me`.)

**Next hop after that order (pick one — do not default to "spec + prototype"):**

| Settled after grill | Next | Do not |
| --- | --- | --- |
| Behavior AC enough; no UI / UI already has design pin | `/implement` (or L2 tickets if multi-slice) | Multi-variant `/prototype` |
| Multi-slice or cross-session handoff | `/to-spec` → `/to-tickets` → `/implement` | Stop at chat-only AC for handoff |
| Only "what should it look like?" still open | `/prototype` then pin winner → implement or L2 | Treat prototype as production fidelity |
| Versioned high-fidelity pin already exists | Record pin on ticket/spec → `/implement` + UI fidelity gate | Re-open multi-variant prototype |
| Product need / market still fuzzy | **HEAVY** PM | Grill as substitute for PM |

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
  → short /grill-code only for eng residual
```

**In the flow** when grill would only produce "I don't know — ask PM". Use for
需求澄清会 prep or a single async pass. Grill the *send* (who + what you need
back), not a fake product discovery. Questions ship with **options + recommended
answer + free-text override**. Filled answers are **settled** — do not re-ask.
Default return is **`/to-spec`**; `/grill-code` only for remaining engineering
frontier. Never invent Expected. Still not a substitute for HEAVY PM when
worth-doing / market is open.

### L3 — Light product intent gap (still coding-adjacent)

```text
rework / mild Expected gap / "not quite what I meant"
  → /product-fog  →  one next skill in this pack
```

Mini docket only. Never invent Expected. Common next hops: **G**
`/grill-code`, **Q** `/to-questionnaire`, L2 `/to-spec`, L4 `/wayfinder`, stop, or
**Escalate-PM**.

Use when already in a coding context — **not** as market discovery.

**按原文 / 收回 delta:** treat as this track. Mini docket lists the accepted
`相对 PRD` ids being revoked; next hop re-opens **only** those inventory `SRC`s
(usually a small L2 patch or one ticket). Do not open a full product grill and
do not narrate the revoke as a pack failure.

### L4 — Multi-session engineering fog

```text
product settled enough, technical route still foggy
  → /wayfinder (thin map) → /to-spec → /to-tickets → /implement
```

**Try G first.** Open a map only when decisions need multiple sessions or a
shared frontier. Chart budget ≤5 tickets; research/task over grill; short
pastes in [CONTINUE.md](../wayfinder/CONTINUE.md) (human should not re-paste the whole
brief each session).

At most one **HITL** decision ticket per session by default; research and AFK
tasks may batch. Plan only — never ship the destination inside the map.

**When the map is `resolved`:** stop `/wayfinder`. Go **L2** — `/to-spec` →
`/to-tickets` → `/implement`. Do not re-grill closed DECs; consume Resolutions.

### Support (compose under the above)

| Need | Skill |
| --- | --- |
| Public-behavior tests | `/tdd` (Matt red → green + seams) |
| Cleanup | `/simplify` (this pack) |
| Diff review | `/code-review` (Matt Standards+Spec; optional WEN axes) |
| Evidence only | `/research`, `/prototype` |
| Domain terms / ADRs | `/domain-modeling` |
| Same-session coding interview | `/grill-code` → `/grilling` (+ `/domain-modeling` only if terms change) |
| Non-coding plan / idea | `/grill-me` → `/grilling` (no repo, no implement handoff) |
| Stakeholder questionnaire | `/to-questionnaire` (meeting or async) |

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
| Any other requirement (default entry; PRD included) | LIGHT **G** | `/grill-code` (entry sweep → residual poles; zero poles → hop L2/L1) |
| Multi-slice settled at G, or sweep showed zero poles | LIGHT L2 | `/to-spec` (PRD Inventory + last-ticket prd-walk) → `/to-tickets` → `/implement` or `/implement-spec` |
| Plan, idea, or decision with no codebase | — | `/grill-me` |
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
