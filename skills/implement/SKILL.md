---
name: implement
description: Implements one bounded task or implementation-frontier ticket through evidence, review, and verification.
disable-model-invocation: true
---

# Implement

Implement one bounded task or one runnable implementation ticket. One ticket
gets one claim, one fresh working context, one reviewable delta, and one
completion decision.

## Find The Work

Read the repo's `CONTEXT.md` or context map when present, plus the source spec,
ticket, legacy PRD/issue, bug report, or task brief. For tracked work, also read
`docs/agents/issue-tracker.md` and `docs/agents/triage-labels.md`; the tracker
doc owns list, frontier, claim, update, and close mechanics. An explicit user
reference wins. If canonical and legacy active sets conflict, show both
candidates instead of silently merging them.

A clear bounded request needs no harness, invented spec, or ticket. Implement
it directly and skip tracker-only steps.

If material product fog remains (worth-doing, target user, stakeholder inner
need, or unspecified Expected after rejection), stop and recommend `/pm-intake`
instead of inventing product intent. See `docs/boundaries.md`.

## Select The Frontier

For tracked work, choose only a ticket that is:

- `Kind: implementation-ticket`, or an unmistakable legacy implementation issue
- `Mode: AFK`, or otherwise free of unresolved human judgment
- open and incomplete
- unblocked: every `Blocked by` edge is complete
- unclaimed by another worker

Never implement a `spec`, `wayfinder-map`, or `wayfinder-ticket`. Prefer explicit
priority, then configured tracker/map order. If no implementation frontier
ticket exists, report the blockers and human frontier rather than taking a
nearby task.

Never select a `bug-report` from a frontier. When the user explicitly names one,
use the adapter's intake-conversion protocol: read it, claim it for conversion,
and re-read ownership. Search exact `Origin` fields and its `Converted to`
pointer before creating anything; reuse an existing replacement. If it is a
runnable ticket, finish any missing report pointer/read-back and claim that
ticket normally. If it is a spec or another non-runnable artifact, report the
canonical route and stop. When claiming is not atomic or workers share one
identity, convert serially.

Only when no replacement exists, verify under that claim that diagnosis, fix,
regression test, verification, and review fit one context. If so, create one
`Kind: implementation-ticket`,
`Subtype: bug`, `Runnable: yes`, with `Origin` pointing to the report. Reuse its
spec parent or use the report as parent when no spec exists. Read the ticket
back, write its canonical reference to `Converted to`, resolve the report as
converted, and read the report back. Then claim the runnable ticket normally.
If it does not fit, release the conversion claim, leave it `needs-triage`, and
recommend `/diagnosing-bugs` or the explicit spec/ticket route.

For a specifically named `HITL` ticket, distinguish the work before claiming it:

- a manual-only action or decision resolves directly through the adapter after
  the human action and evidence are recorded; `/implement` does not manufacture
  a code delta, TDD result, or code-review verdict
- code-bearing paired work requires the user to remain available for the named
  judgment; claim it from the human frontier, never infer the decision, and use
  the evidence loop that matches the actual change plus verification and review

If the decision is settled before work starts, record it and reclassify the
ticket to `AFK` through the adapter instead of carrying a false HITL marker.

## Claim And Isolate

Claim through the configured adapter before repo exploration or edits, then
re-read ownership. If another worker won the claim, release yours and choose
again. A claim coordinates work; it is not assumed to be an atomic lock.

Record a review fixed point that isolates this ticket's delta. Use a clean
working tree, isolated worktree, authorized checkpoint/commit, or another
project-proven boundary. If pre-existing changes make the delta ambiguous, stop
before editing. Do not complete this ticket or start another on an unreviewable
diff.

## Execute The Ticket

1. Mark the ticket in progress using adapter-specific state.
2. Trace the relevant entrypoint when behavior crosses callers, persistence,
   permissions, async paths, conversions, or side effects.
3. Choose the evidence loop from the actual change:
   - observable behavior: load `/tdd`, derive a public-behavior test, confirm
     RED, implement the smallest behavior, and confirm GREEN
   - authorized behavior-preserving docs, config, or mechanical work: establish
     a GREEN baseline and exact verification, make one increment, and rerun it;
     an expand-contract ticket also records the caller inventory and runs its
     compatibility/static checks
4. Load `/simplify` for non-trivial changes; keep tiny mechanical diffs direct.
5. Run the project's exact verification commands.
6. Load `/code-review` against the recorded fixed point. Resolve every blocking
   finding or user-owned decision, then rerun affected verification.
7. Re-check every acceptance criterion. Update comments/evidence and complete
   the ticket through the adapter only when tests, verification, and review pass.

Keep unverified criteria open. Commit only when the user or project workflow
authorizes it.

## Stop Or Continue

Default to one ticket, then stop with the next implementation/human frontiers
and review evidence. If the user explicitly requested a bounded multi-ticket
loop, dispatch a fresh worker and isolated delta for each ticket, then recompute
affected frontiers. Never run two dependent tickets in one context.

If an unexpected user-owned gate appears at any point, update the ticket through
the adapter to `Mode: HITL` plus the configured human-readiness role, record the
named decision, and read both fields back. Reconcile any partial update before
continuing. With no unfinished delta, release the claim and recompute both
frontiers. With unfinished changes, preserve the claim so the delta keeps one
owner; the HITL ticket remains outside the unclaimed human frontier until its
handoff resumes. Never release it unchanged into the AFK frontier.

If work otherwise stops before edits, release the claim. Whenever unfinished
changes exist, record the human or external blocker on the ticket and write a
compact handoff in the OS temp directory with the ticket, fixed point, changed
files, verification state, and blocker. Return its absolute path; do not
silently invoke another user-invoked skill.

## Done

Report the task/ticket, source spec or legacy source, fixed point, changed files,
tests and verification, code-review verdict, tracker update, commit status, and
the next implementation/human frontiers or blocker.
