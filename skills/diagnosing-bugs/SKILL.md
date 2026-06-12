---
name: diagnosing-bugs
description: Diagnoses bugs with a feedback loop. Use for debug reports, broken behavior, failing tests, or perf regressions.
---

# Diagnosing Bugs

Diagnose hard bugs by building a feedback loop before changing code.

This skill is adapted for this repo from Matt Pocock's MIT-licensed `diagnosing-bugs` skill. See [ATTRIBUTION.md](ATTRIBUTION.md).

## When To Use

Use this when the user reports:

- an error, crash, exception, failed test, or broken behavior
- a behavior regression from a previous working state
- a performance regression
- a request phrased as "debug this", "diagnose this", "why is this failing", or "fix this bug"

Do not use it for new feature planning. Use `/grill-with-docs`, `/to-prd`, `/to-issues`, or `/tdd` instead.

## Workflow

### 1. Build A Feedback Loop

Create the fastest agent-runnable pass/fail signal that reproduces the user's bug.

Try these in order:

1. failing test at the seam that reaches the bug
2. curl or HTTP script against a running service
3. CLI command with fixture input and expected output
4. browser script for UI, console, and network symptoms
5. replayed request, payload, event log, or trace
6. throwaway harness around the smallest relevant subsystem
7. repeated loop for flaky bugs, with seed/time/network controlled where possible
8. bisection or differential loop against commit, version, config, or dataset changes
9. human-in-the-loop script when only the user can trigger the path

For human-in-the-loop cases, adapt `scripts/hitl-loop.template.sh` and record captured output.

Improve the loop before debugging: make it faster, sharper, and more deterministic. For nondeterministic bugs, raise the reproduction rate enough to debug against.

If you cannot build a loop, stop and report what you tried. Ask for access, a captured artifact, or permission for temporary instrumentation. Do not guess a fix without a loop unless the user explicitly asks for emergency mitigation.

### 2. Reproduce

Run the loop until the reported failure appears.

Confirm:

- the symptom matches the user's bug, not a nearby failure
- the failure reproduces consistently, or often enough for flaky bugs
- the exact symptom is captured: message, wrong output, timing, request, payload, or trace

### 3. Hypothesize

Before editing, write 3-5 ranked hypotheses.

When the repro identifies a stack frame, endpoint, handler, public API, job, or failing test path, load `/deep-code-trace` before finalizing hypotheses so the real call chain, queries, conversions, and side effects shape the diagnosis.

Each hypothesis must be falsifiable:

```text
If <cause> is true, then <probe/change> should make <observable signal> change.
```

Show the ranked list to the user when it may benefit from domain knowledge. If the user is AFK, proceed with the best-ranked hypothesis and record the assumption.

### 4. Probe

Test one hypothesis at a time.

Prefer:

1. debugger or REPL inspection when available
2. targeted logs at boundaries that distinguish hypotheses
3. measurements, profiles, query plans, or traces for performance regressions

Tag temporary instrumentation with a unique prefix such as `[DEBUG-a4f2]`. Never add broad "log everything" instrumentation.

### 5. Fix With Regression Coverage

Write the regression test before the fix when a correct seam exists.

A correct seam exercises the real bug pattern through the same public boundary or call chain that failed. If no correct seam exists, document that as an architecture/testing gap.

Then:

1. turn the minimized repro into a failing test or repeatable check
2. watch it fail
3. apply the smallest behavior-correct fix
4. watch the regression check pass
5. rerun the original feedback loop

### 6. Clean Up And Explain

Before declaring done:

- original repro no longer fails
- regression check passes, or missing seam is documented
- all `[DEBUG-...]` instrumentation is removed
- throwaway harnesses are deleted or clearly marked
- the confirmed root cause is stated plainly
- remaining risk and verification gaps are listed

If the root cause exposed a poor seam, tangled callers, or hidden coupling, hand off specifics to `/improve-codebase-architecture` after the bug fix.
