# Forensic observability

**Leading word: forensic completeness** — on production-reachable paths that
cross process, network, async, or external-system boundaries, a change is not
done until (1) a project **logging foundation** exists when needed, (2)
**decision-boundary logs** leave a correlatable field record, and (3) logging is
**fail-open**: a log failure must never fail the business path.

This file is the single source of truth for that contract. `/setup-project-harness`,
`/implement`, Executor, `/code-review` Correctness, and Verifier point here;
they do not restate the full tables.

Related: quiet critical path and log-unsafe shipping are also **incomplete /
blocking** under [INCOMPLETE-SURFACE.md](INCOMPLETE-SURFACE.md).

## Why this is hard

Production evidence is often **write-once**:

- Third-party webhooks, callbacks, and MQ messages may not reappear.
- State machines and side effects cannot be safely re-fired "to see what
  happened."
- Test environments can replay; production usually cannot.

Without a logging foundation and decision-boundary field records, many incidents
are not merely hard — they are **forensically unsolvable**. Temporary
`[DEBUG-…]` probes in `/diagnosing-bugs` do not substitute for this contract.

## Non-negotiable: logging never breaks business

| Rule | Meaning |
| --- | --- |
| **[MUST] Fail-open** | If logging throws, blocks, times out, or mis-serializes, the **domain path continues** with the same success/failure it would have without the log call. |
| **[MUST] Isolate side effects** | Log append, MDC put/clear, string build for logs, and metrics emission must not sit on an uncaught path that can abort the transaction or request. |
| **[FORBID] Log-gated control flow** | Do not use "log succeeded" as a precondition for business work. Do not throw business errors because a logger/appender failed. |
| **[FORBID] Secrets in logs** | Tokens, passwords, full PAN/PII dumps, raw credential headers. Prefer ids + redacted summaries. |

Implementation shape (language-agnostic):

- Prefer the project's established logger; never invent a parallel channel that
  can fail the caller.
- Guard volatile log work when the stack can throw (custom appenders, remote
  log shippers, complex argument evaluation). Business code must not depend on
  those succeeding.
- MDC/context: set/clear in `try/finally` so cleanup failure modes still cannot
  strand identity — but MDC failure must not fail the request either.

**Review severity:** a log call that can fail the business path is a
**blocking Correctness** finding (log-unsafe), not a style nit — even if the
messages themselves look excellent.

## When foundation is required

During harness setup and before AFK work on integration-heavy code, classify:

| Project signal | Foundation bar |
| --- | --- |
| Pure library / pure functions / no I/O | Thin: language logger optional; forensic path `n/a` unless public side effects appear |
| HTTP API, jobs, MQ, webhooks, multi-tenant, third-party SDK, state machines | **Full foundation required** before treating the repo as agent-ready for those paths |

### Full foundation (minimum solvable production set)

1. **Unified logger API** — one project pattern (e.g. SLF4J facade + backend), not ad-hoc `print` / multi-framework mix on new code.
2. **Levels + sinks** — dev/test/prod config that actually emits; agents know where logs land.
3. **Correlation** — request / job / webhook / message id (or MDC keys) so one incident can be grepped as a chain.
4. **Structured fields habit** — ids, outcome, before/after, reason; not only free-text prose.
5. **Redaction rules** — what never goes to logs.
6. **How to read** — one documented command or platform path (e.g. `tail` path, log service query). Without this, agents and humans cannot collaborate.

If foundation is missing on a full-bar project: **setup builds foundation first**;
`/implement` on critical paths returns `blocked` / `foundation-missing` rather
than shipping quiet or log-unsafe code.

## Decision-boundary instrumentation (permanent)

On applicable paths, durable **INFO** (or project-equivalent) field logs at:

| Boundary | Must leave behind |
| --- | --- |
| External ingress | Type/summary, correlation ids, count — not unbounded raw secrets |
| Route / branch | Which branch, why skip |
| State transition | before → after for status / review / display / money-affecting fields |
| Async handoff | accepted / started / finished + result summary |
| Third-party call | success / empty / error / timing / mappability — empty is as important as error |
| Projection / fan-out | scope, row counts, per-entity result summary when fan-out is the product behavior |

**Not required:** log every `if`; DEBUG spam on hot pure loops; temporary
hypothesis probes (those stay under `/diagnosing-bugs` and are removed).

## Review checklist (Correctness — forensic chain)

For each production-reachable chain the diff touches, ask whether logs alone
can answer:

1. Did the event enter the system?
2. Which branch ran (or why skip)?
3. What did the external system return (including empty)?
4. What state was written (before → after)?
5. Why is the user-visible outcome what it is?
6. Are all of the above **correlatable** by one id?
7. Can any new log path **fail the business**? (If yes → blocking log-unsafe)

Missing a required link on an applicable path → **blocking** (quiet critical
path). Pure local pure-function diffs → `n/a` with one-line reason.

## Role duties

| Role | Must |
| --- | --- |
| **`/setup-project-harness`** | Explore foundation; on full-bar projects without it, draft/build foundation before calling harness complete. Record how to read logs. |
| **Executor / `/implement`** | Instrument decision boundaries on claimed critical paths; enforce fail-open; report `observability`. Never ship log-unsafe. |
| **`/code-review` Correctness** | Run the forensic chain checklist; quiet path and log-unsafe are blocking. |
| **Verifier** | Completion claims fail when applicable paths lack forensic completeness or introduce log-unsafe logging. |
| **`/diagnosing-bugs`** | Temporary probes remain tagged and removed; if the gap is foundation or permanent boundary logs, hand back to harness/implement — do not "fix" production forever with DEBUG-only. |

## Done report vocabulary

Use in implement / review / verify:

- `observability: instrumented` — applicable boundaries covered, fail-open
- `observability: foundation-missing` — blocked; do not pretend done
- `observability: quiet-path` — behavior present, forensic chain incomplete
- `observability: log-unsafe` — logging can break business (blocking)
- `observability: n/a` — no applicable external/async/state path in this slice
