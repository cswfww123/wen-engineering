---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /code-review to review the work.

Commit your work to the current branch.

## WEN process (required — read before writing code)

These steps **bind** how the Matt steps above are executed in this pack. They
do not replace TDD / typecheck / review / commit.

### 0. Route and bound

- Clear bounded request **or** one implementation-frontier ticket only.
- Intent not ready → stop; do not invent Expected (see project lifecycle docs if present).
- Note layer (`frontend` | `backend` | `full-stack` | `non-UI`) for fidelity later.
- Tracked work (frontier, bug-report conversion, HITL, claim): load
  [TRACKED-WORK.md](TRACKED-WORK.md) **before** edits.

### 1. Hard-try Executor before non-trivial edits

**Before** the first non-trivial production edit (and for each subsequent
vertical slice), run the dispatch ladder. Load [DISPATCH.md](DISPATCH.md) once
per session.

1. **Must try** spawn pack role `Executor` if the host can load it; else spawn
   the host's general multi-step / coding subagent with the **Executor system
   text + brief** from [DISPATCH.md](DISPATCH.md).
2. If spawn fails or no subagent runtime exists → parent performs the same
   bounded slice in-session (soft fail).
3. **Never** abort because Executor is missing.
4. **Forbidden:** parent bulk-implements a multi-slice feature while a subagent
   runtime exists **without at least one Executor (or host-general) attempt**
   recorded for that slice.

Tiny one-line mechanical edits may stay in parent when cheaper.

### 2. Evidence loop (via Executor ladder)

Per slice, Executor (or fallback) does:

1. Confirm / record seams with the user or ticket AC.
2. `/tdd` red → green at those seams (or authorized GREEN baseline for
   mechanical docs/config). Green must lock the **real** domain step at the
   seam — not a config constant that sidesteps a sibling path's source of truth
   (see [incomplete surface](../code-review/INCOMPLETE-SURFACE.md)).
3. `/simplify` when the delta is non-trivial.
4. Project verification for this layer (behavior gate).
5. Fidelity when applicable (UI vs design/contract; API vs stated contract).
6. **Incomplete-surface + forensic observability self-check** before claiming
   the slice ready for review: production paths for this AC must be complete.
   Deferred markers, placeholders, dual-source domain facts, config stand-ins,
   **quiet critical paths**, and **log-unsafe** logging on live paths are
   forbidden — finish the real step or **stop and report a blocker**.
   Classifier: [INCOMPLETE-SURFACE.md](../code-review/INCOMPLETE-SURFACE.md).
   On external/async/webhook/MQ/third-party/state-machine paths: instrument
   decision boundaries (ingress, branch/skip, before→after, external outcome
   including empty, fan-out) with correlatable field logs; **logging is
   fail-open** — log/MDC/metrics failure must never fail or gate business.
   If the project lacks a required logging foundation, report
   `observability: foundation-missing` and stop rather than shipping quiet
   paths. Contract: [FORENSIC-OBSERVABILITY.md](../code-review/FORENSIC-OBSERVABILITY.md).

Parent re-issues a **new** Executor brief per slice — not one mega-todo dump
that never dispatches.

### 3. Review

1. Record a review fixed point that isolates this ticket/task delta.
2. Run `/code-review` against that fixed point (AC + fidelity). That skill
   **must hard-try** Reviewer / Verifier per its own dispatch, and **must**
   run the Correctness axis (incomplete surface is a blocking class there).
3. If verdict is not `Pass` and fixes are in scope (`/implement` authorizes
   in-scope behavior-preserving fixes): hard-try **Executor** again with the
   eligible fix list + fix contract from code-review.
4. Do not close a parent **spec**; complete only this ticket/task.
5. **`Pass` is invalid** if an incomplete surface remains for claimed AC —
   even when Standards looks clean and thin tests are green.

### 4. Commit

Commit only when authorized, on the current branch. Do **not** commit a slice
that still carries an incomplete production surface for its AC.

### Done report (mandatory fields)

- task / ticket / source
- fixed point
- files changed
- behavior-gate + fidelity (or n/a)
- **incomplete-surface check**: `clean` | `blocked` (cite signal) | `n/a` (docs/config only)
- **observability**: `instrumented` | `foundation-missing` | `quiet-path` | `log-unsafe` | `n/a`
- code-review verdict
- **`agents used`**: e.g. `Executor` | `host-general` | `parent-fallback` (and
  for review: `Reviewer` / `Verifier` / fallback) — if parent did the work,
  say so explicitly and why (no runtime / spawn failed)
- tracker update, commit status, next frontier or blocker
