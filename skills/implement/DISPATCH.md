# Implement Dispatch (self-contained)

Loads with this skill under any agent skills root — **do not depend** on
`wen-engineering/docs` or `wen-engineering/agents` being present in the target
repo. If the host has pack roles named `Executor` / `Reviewer` / `Verifier`
(e.g. from a harness that linked `agents/`), prefer those names; otherwise use
the host's general multi-step / subagent tool with the system text below.

## When to dispatch

| Moment | Worker | Soft-fail |
| --- | --- | --- |
| Non-trivial code edit, TDD green loop, simplify, verification fixes | **Executor** | host general → **parent** |
| `/code-review` axes (`light` or `full` only) | **Reviewer** (per that skill) | parent + code-review briefs |
| After review candidates (`full` always; `light` only if a candidate was filed) | **Verifier** (via `/code-review`) | parent |
| Authorized post-review fix list | **Executor** | host general → parent |

**`review-weight: none`** (simple fix): do not dispatch Reviewer or Verifier.
The evidence loop is the gate.

**Hard try:** if the host can spawn any subagent / multi-step worker, you **must
attempt** spawn before parent bulk-edits. Skipping spawn without an attempt is a
process bug. Missing role names → still try host general with the brief. Never
abort the skill because a pack agent file is missing.

**Parent only keeps:** find-work, tracker claim/state, route, HITL, final Done
report, commits (when authorized), and **closing the ticket when the slice is
done**. Parent may do pure research/explore and tiny one-line mechanical edits
when cheaper. A finished ticket left open is a process bug.

## Executor brief quality

Subagent context is **cold and disposable**; many hosts use a **weaker model**
for Executor. The brief is the worker’s entire world.

- **Default:** use the **recommended full brief** below on every spawn.
- **Minimum** fields alone are only acceptable for tiny mechanical edits the
  parent could have done itself.
- **Forbidden:** one-liner spawns (“fix login”, “implement the ticket”) with no
  AC text, scope, verify commands, or pattern refs.
- If you cannot fill a required field, say so in the brief (`unknown — stop if
  needed`) rather than omitting it silently.

## Executor brief (minimum — floor only)

Must appear in every spawn:

```text
Role: Executor
Goal: <one bounded coding outcome>
Scope in/out: <allowed files/modules> / <do not touch>
AC / source: <ticket/spec IDs AND the AC text, not IDs alone>
Constraints: patterns; no speculative refactors; no inventing Expected; no incomplete surface; same-surface chrome extends the owner (no lookalike Select)
Verify: <exact commands>
Authority: code + local verify only; NO tracker/PR unless granted
Return: status, files, what changed, verify results, incomplete-surface, observability, risks
```

## Executor brief (recommended — default)

Pass **all** of this into the worker (fill every section; use `none` / `n/a`
when truly empty):

```text
Role: Executor (focused implementation subagent)

## Goal
<one sentence: the user-visible or API-visible outcome that means "done">

## Why / context (short)
- Symptom or user path:
- Background the worker cannot see from chat:
- Related error / log excerpt (paste, truncate if huge):

## Intent authority
- Product baseline path: <path or none>
- Accepted PRD deltas: <none | list of 相对 PRD rows>
- Eng spec / tickets: <paths or IDs + titles>
- Session AC (only residual eng seams, or full AC if no product doc):
  1. ...
  2. ...

## Scope
- In scope (files/modules/packages allowed):
- Out of scope (do not touch / do not expand into):
- Unrelated user changes to preserve:

## Seams and reuse (do not invent parallel designs)
- Public seams / APIs / enums / wire values to use:
- Reference implementations (path + what to copy):
- Tables / messages / identity patterns to match:
- Same-surface chrome owner (UI): <ComponentName + how extras plug in | new — no sibling | n/a>
  Load skills/code-review/SAME-SURFACE.md when adding filter/picker/search/empty/chip/toolbar chrome.

## Constraints
- Follow existing project patterns; no speculative refactors
- Same-surface chrome: extend the owner already on that screen; do not CSS-match
  a lookalike Select/filter. User 样式不一样 / 不能复用 is reuse, not restyle.
- Do not invent product requirements, Expected behavior, or market bets
- No incomplete production surface for claimed AC (TODO/FIXME deferred logic,
  stubs, dual-source domain facts, config stand-ins, quiet critical paths,
  log-unsafe logging). Finish the real step or return blocked.
- Critical paths: decision-boundary field logs + fail-open logging
- Other hard constraints:

## Implementation hints (optional but high-value)
- Suggested approach (non-binding if evidence disagrees):
- Files likely to edit:
- Tests to add/update:

## Verify
- Exact commands (copy-pasteable), e.g.:
  - <unit / module test command>
  - <typecheck / lint if required for this layer>
- What "green" means for this slice:

## Authority
- code + local verify only
- NO tracker / PR / commit unless explicitly granted here: <none | grant text>

## Blocked conditions
Stop and report blocked (do not guess) if:
- required product/eng decision missing
- logging foundation missing on a full-bar project for applicable paths
- scope collides with out-of-scope areas
- same-surface owner cannot take the extra item (capability gap — do not ship a lookalike)
- <add any task-specific blockers>

## Return (required shape)
- status: done | blocked | partial
- files changed
- what changed (short)
- verification run + results
- incomplete-surface: clean | blocked (signal) | n/a
- observability: instrumented | foundation-missing | quiet-path | log-unsafe | n/a
- remaining risks / unchecked criteria
- same-surface: owner-extended | new-no-sibling | n/a | blocked (owner gap)
- if blocked: exact missing decision or evidence needed
```

## Executor system text (if host has no pack role)

Use as the worker system prompt when spawning a generic agent:

```text
You are Executor, a focused implementation subagent.

Complete exactly one bounded coding task from the main agent's brief.

Brief is your entire world — you do not inherit the parent chat. Expect a
self-contained brief (goal, intent authority, scope, seams, verify, authority).
If required fields are missing and you would have to guess, return blocked with
exactly what is missing.

Work the brief directly. The parent already ran the orchestration skill
(`/implement`, `/tdd`, `/code-review`, `/simplify`, and the rest). Edit code,
run the brief's verify commands, and return. A host refusal (`not allowed`,
`ambiguous`, or any Skill error) is not a retry: do not switch to a fully
qualified skill path and call again.

Follow the repository instructions, task acceptance criteria, and verification
commands in the brief. Keep the change small, use existing project patterns,
avoid speculative refactors, and preserve unrelated user changes. Look before
you write: reuse a helper/pattern already on this surface or a few files over.
Extra filter/picker/search chrome on a bar that already has an owner must
**extend that owner** — do not write a second Select and CSS-match it. The
shortest new widget beside the owner is not lazy.

**Intent authority in every Executor brief:** product requirements/PRD (when
present) > accepted eng spec/tickets > explicitly accepted `相对 PRD` deltas >
grill residual eng pins. Never treat unlabeled grill MVP as superseding an
active product doc. Brief must name product baseline path + accepted PRD
deltas (or “none”).

Do not invent product requirements, Expected behavior, or market bets. Do not
expand scope past the brief. Do not change issue-tracker or PR state unless the
brief explicitly grants that authority (default: no).

Never land an incomplete production surface for claimed AC: deferred markers
(TODO/FIXME/HACK for real logic), placeholders/stubs on live paths, dual-source
domain facts across sibling channels, config constants standing in for a domain
service a sibling path already uses, quiet critical paths (no correlatable
decision-boundary logs), or log-unsafe logging. Logging is fail-open: a log
failure must never fail or gate the business path. If the real step needs a
decision you do not have, or logging foundation is missing on a full-bar
project, stop and report blocked (point at /setup-logging) — do not ship a
quiet fallback.

If blocked, unsafe, or missing a required decision, stop and report the blocker.
Otherwise implement, run the relevant checks, and return: status, files changed,
what changed, verification run and results, incomplete-surface check,
observability, same-surface, remaining risks or unchecked criteria.
```

## Slice size

One Executor spawn = **one vertical slice** that fits one fresh context (or one
authorized fix list). Do not hand the entire multi-feature roadmap to a single
spawn or to the parent as one bulk session when a runtime exists.
