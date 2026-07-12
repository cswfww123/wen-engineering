---
name: diagnosing-bugs
description: Diagnose bugs via a feedback loop first. Use for debug, broken behavior, failing tests, or perf regressions.
---

# Diagnosing Bugs

Build a feedback loop before changing code. Attribution: [ATTRIBUTION.md](ATTRIBUTION.md).

Not for new feature planning — route that work to grill / wayfinder / to-spec / tickets / tdd by shape.

## Authority Gate

- **Diagnosis only** — “debug”, “diagnose”, “why failing”, or a named non-runnable `bug-report`. Existing signals, read-only probes, or disposable evidence only. No tracked production edits, tests, config, or tracker mutation.
- **Fix authorized** — only when the user explicitly asked for the fix or an active implementation scope already authorizes code changes. Record a review fixed point before editing. A named `bug-report` stays diagnosis-only until a user-invoked workflow converts it.

## Workflow

### 1. Feedback Loop

Fastest agent-runnable pass/fail that reproduces the bug. Diagnosis-only: prefer existing signals; put new harness/instrumentation in OS temp or authorized scratch and remove or return the path — do not add a tracked regression test yet.

Try in order: failing seam test → curl/HTTP → CLI + fixture → browser script → replayed request/payload/trace → throwaway harness → flaky loop (seed/time/network controlled) → bisect/differential → HITL script (`scripts/hitl-loop.template.sh`).

Sharpen the loop (faster, sharper, deterministic) before deep debugging. No loop → report what you tried; ask for access, artifact, or temp instrumentation permission. Do not guess a fix without a loop unless the user asks for emergency mitigation.

### 2. Reproduce

Run until the reported failure appears. Confirm symptom match, consistency (or flaky rate), and capture exact signal (message, output, timing, payload, trace).

### 3. Hypothesize

Before editing, rank 3–5 **falsifiable** hypotheses. If a stack frame/endpoint/handler/API/job/test path is known, trace the call chain first.

```text
If <cause>, then <probe> should change <observable>.
```

Show the list when domain knowledge may help; if AFK, proceed with best-ranked and record the assumption.

### 4. Probe

One hypothesis at a time. Prefer: debugger/REPL → boundary logs that distinguish hypotheses → profiles/query plans/traces for perf. Tag temp logs `[DEBUG-xxxx]`. Never “log everything.”

### 5. Fix (authorized only)

Diagnosis-only: stop when root cause is proved; return disposition `bounded-fix` (→ `/implement`), `spec-and-slice` (→ `/to-spec` → `/to-tickets`), or `blocked`.

Authorized fix:

1. Regression at a correct seam (same public boundary/call chain as the bug) before the fix when a seam exists; else document the gap
2. Minimized repro → failing check → smallest correct fix → check green → original loop green
3. `/simplify` if non-trivial; project checks; `/code-review` against fixed point; resolve blockers; re-verify

### 6. Clean Up And Explain

Diagnosis-only: captured reproducer, evidence-backed root cause, unchanged production files, next disposition.

Authorized fix: original repro fixed; regression green or seam gap documented; all `[DEBUG-...]` removed; throwaway harnesses deleted or marked; root cause plain; remaining risk listed.

Return: mode, root cause, reproducer/evidence, changed files if any, verification/review, disposition (`bounded-fix` | `spec-and-slice` | `blocked`).

If the root cause shows a poor seam or tangled coupling, recommend `/improve-codebase-architecture` after bug work — do not start it silently.
