# Implement Dispatch (self-contained)

Loads with this skill under any agent skills root — it does not depend on the
pack's `docs/` or `agents/` being present. If the host has pack roles named
`Executor` / `Reviewer` / `Verifier`, prefer those names; otherwise use the
host's general subagent tool with the system text below.

**Executor is usually a weaker model.** It follows text literally and reasons
little. So: the parent plans, the worker types, the parent accepts
([SKILL.md](SKILL.md) §1–§3).

## When to dispatch

| Moment | Worker | Brief | Soft-fail |
| --- | --- | --- | --- |
| Planned slice (implement §1 done) | **Executor** | Implementation brief | host general → parent |
| Authorized post-review fixes | **Executor** | Fix-list brief | host general → parent |
| `/code-review` axes, Verifier | per `/code-review` DISPATCH (`none` spawns nothing) | there | parent |

**Hard try:** when the host can spawn a subagent, attempt it before the parent
edits. Skipping without an attempt is a process bug. Missing role name → try
host general with the same brief. Never abort because a pack file is missing.

**Parent always keeps:** planning, acceptance, commit, merge-back, tracker
state, HITL, the Done report. The worker gets none of these.

**Model tier:** host default. UI / design-pin slices → parent-tier model
(Claude Code: the Agent tool `model` override).

## Writing a brief for a weak worker

1. **Every judgment is already made.** Concrete values, exact paths, exact
   `file:symbol`, exact commands. The worker chooses nothing.
2. **Paste, don't point.** The worker cannot open pack files or the parent
   chat. AC text, pin rows, code excerpts, error output go in the brief; a
   path to a long doc is extra, never the substitute.
3. **Steps, not prose.** Numbered steps, each ending on something checkable.
4. **Name every fork.** Where the worker could be unsure, the brief names the
   target, or names the stop condition.
5. **Raw facts back.** Return asks for command output, file lists, grep
   output, evidence paths — the parent classifies them.
6. A field with nothing to say → `none`. A field you cannot fill because a
   decision is missing → do not dispatch; the slice is `blocked`.
7. Prefer ≤8 Plan steps per spawn; a bigger plan is two slices.

## Implementation brief

```text
Role: Executor. Run the Steps in order. The Plan is fixed; you type it in.
Working root: <abs worktree path> — run every command here.

## Goal
<one observable outcome>

## Acceptance (final — implement exactly these)
A1 <behavior with literal values>
A2 ...

## Files
Edit only: <path>, <path>
Read first: <path:lines> — <what to copy from it>
Use existing: <file:symbol> — <use it for …>
Chrome owner (UI): <add item <x> to <Owner>.items in <file> | none>
Source of truth: <domain fact → service/table to call | none>
Log points: <boundary → fields to log, fail-open | none>

## Plan (in order)
1. <file> — <change>
2. ...

## Tests
Add `<test name>` in <test file>: <input> → assert <literal expected value>.
Run one test: <cmd>   Typecheck: <cmd>   Suite: <cmd>

## Steps
S1 Read every "Read first" file.
S2 Add the tests. Run the one-test command. It must FAIL. Keep the output.
S3 Apply the Plan, in order.
S4 Run the one-test command → PASS. Then typecheck and suite → exit 0.
S5 Start: <cmd>. Open <url>. Log in with env <USER_VAR> / <PASS_VAR>. Seed: <cmd | none>.
S6 For each Walkthrough row: do the action exactly, save the evidence to its
   path, write what you actually saw.
S7 Run `git diff --name-only` (every file must be in "Edit only") and
   `git diff | grep -nE 'TODO|FIXME|HACK|XXX|待接入|后续|临时|\.skip\(|\.only\(|@Disabled|@Ignore|@ts-ignore|eslint-disable|as any'` (must be empty).
S8 Leave changes uncommitted. Fill in Return.

## Walkthrough
| id | action (exact) | expected | evidence path |
| W1 | <e.g. 点「新建」，名称填 demo-01，提交> | <列表首行出现 demo-01> | <abs path.png> |

## Stop and return `blocked` when
- a file outside "Edit only" must change
- a file or symbol named here does not exist
- the same check fails 3 times
- startup or login fails
- <slice-specific triggers>

## Return (fill every line; `not run` if skipped)
status: done | blocked | partial
S2 red output: <last 20 lines>
S4 commands + exit codes:
files changed:
W1 actual: <what you saw> | evidence: <path>
S7 name-only output: <paste>
S7 grep output: <paste | empty>
log lines added: <file:line | none>
blocked at: <step + exact error | none>
```

## Fix-list brief (after `/code-review`, authorized fixes only)

```text
Role: Executor. Apply exactly these fixes, in order. Change nothing else.
Working root: <abs worktree path>
Edit only: <files named by the fixes>

## Fixes
F1 <file:line>
   now:    <current code, pasted>
   change: <exact replacement or exact edit>
   check:  <cmd> → <expected>
F2 ...

## Steps
S1 For each fix: apply it, run its check, record the result.
S2 Run: <suite cmd> → exit 0.
S3 Run `git diff --name-only` (only the files above).
S4 Leave changes uncommitted. Fill in Return.

## Stop and return `blocked` when
- the "now" code is not at the named place
- a check still fails after 3 attempts

## Return
status: done | blocked | partial
per fix: F<n> applied | not applied — check output:
S2 exit code + last 20 lines:
S3 output:
```

## Executor system text (if host has no pack role)

Use as the worker system prompt. `agents/Executor.md` carries the same body;
keep the two identical (`scripts/check-agent-sync.sh`).

<!-- executor-system-text:start -->
```text
You are Executor, a focused implementation worker.

1. The brief is everything you know. You do not see the parent chat, earlier
   tool results, or pack/skill files. You need no Skill tool; if one is
   refused, carry on from the brief.
2. Work inside the brief's Working root. Edit only the files the brief lists.
3. Follow the brief's Plan and Steps in order. Use the names, values, and
   commands it gives. Where it names an existing file:symbol, owner component,
   or source of truth, use exactly that one.
4. Add the tests the brief names. Run them first and keep the failing output.
   Then change the code until they pass.
5. Keep every existing test and assertion as it is. Make code pass tests;
   never make tests pass code: no skip/only, no disabled tests, no weakened
   assertions, no @ts-ignore / as any / eslint-disable, no swallowed errors,
   no hardcoded return values, no mocking the thing under test.
6. Finish every step for real. A TODO, stub, placeholder, or fixed value
   standing in for the real logic means the step is not done.
7. Logging you add must never throw into or change the business path.
8. Stop and return `blocked` with the exact step and error when: a file
   outside the list must change, a named file or symbol does not exist, the
   same check fails 3 times, the app will not start, or the brief's own stop
   conditions hit. A failing test the brief did not mention: report it, leave
   it alone.
9. Finish by filling in every line of the brief's Return with real command
   output. Write `not run` for anything you skipped. The parent checks the
   work; report exactly what happened.
```
<!-- executor-system-text:end -->
