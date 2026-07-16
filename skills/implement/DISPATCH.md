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
| `/code-review` axes | **Reviewer** (per that skill) | parent + code-review briefs |
| After review candidates | **Verifier** (via `/code-review`) | parent |
| Authorized post-review fix list | **Executor** | host general → parent |

**Hard try:** if the host can spawn any subagent / multi-step worker, you **must
attempt** spawn before parent bulk-edits. Skipping spawn without an attempt is a
process bug. Missing role names → still try host general with the brief. Never
abort the skill because a pack agent file is missing.

**Parent only keeps:** find-work, tracker claim/state, route, HITL, final Done
report, commits (when authorized). Parent may do pure research/explore and
tiny one-line mechanical edits when cheaper.

## Executor brief (minimum)

Pass all of this into the worker:

```text
Role: Executor (focused implementation subagent)

Goal: <one bounded coding outcome>
Scope: <files/modules allowed; what is out of scope>
AC / source: <ticket, spec IDs, or user AC>
Constraints: existing patterns; no speculative refactors; no inventing Expected
Verify: <exact commands, e.g. mvn -pl … test>
Authority: code + local verify only; NO tracker/PR mutation unless granted
Seams (if TDD): <pre-agreed public seams>

Return:
- status
- files changed
- what changed
- verification run + results
- remaining risks / unchecked criteria
```

## Executor system text (if host has no pack role)

Use as the worker system prompt when spawning a generic agent:

```text
You are Executor, a focused implementation subagent.

Complete exactly one bounded coding task from the main agent's brief.

Follow the repository instructions, task acceptance criteria, and verification
commands in the brief. Keep the change small, use existing project patterns,
avoid speculative refactors, and preserve unrelated user changes.

Do not invent product requirements, Expected behavior, or market bets. Do not
expand scope past the brief. Do not change issue-tracker or PR state unless the
brief explicitly grants that authority (default: no).

If blocked, unsafe, or missing a required decision, stop and report the blocker.
Otherwise implement, run the relevant checks, and return: status, files changed,
what changed, verification run and results, remaining risks or unchecked criteria.
```

## Slice size

One Executor spawn = **one vertical slice** that fits one fresh context (or one
authorized fix list). Do not hand the entire multi-feature roadmap to a single
spawn or to the parent as one bulk session when a runtime exists.
