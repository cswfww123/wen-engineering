# Logging principles (foundation)

Methodology for `/setup-logging`. Properties over vendors. Every stack recipe
in [STACKS.md](STACKS.md) must satisfy these.

## Leading words

| Word | Meaning |
| --- | --- |
| **Crime scene** | Production evidence is often write-once. Logs are the only reliable replay of what happened. |
| **Fail-open** | Logging failure must never fail, roll back, or gate business work. |
| **Foundation** | Unified API + levels/sinks + correlation + structure habit + redaction + how-to-read. |
| **Decision boundary** | Permanent field logs at ingress / branch / state / async / third-party / fan-out — owned by implement + forensic review, not this skill’s full pass. |

## Why foundation first

Without foundation, agents and humans cannot:

- reconstruct one incident as a **chain** (correlation)
- trust that new logs will actually **emit** somewhere readable
- instrument critical paths without inventing a parallel logger that breaks prod

Feature-level decision-boundary logs assume foundation already exists. That is
why `/implement` reports `observability: foundation-missing` rather than shipping
quiet paths.

## Non-negotiable: fail-open

| Rule | Meaning |
| --- | --- |
| **[MUST] Fail-open** | If logging throws, blocks, times out, or mis-serializes, the **domain path continues** with the same success/failure it would have without the log call. |
| **[MUST] Isolate side effects** | Append, context put/clear, string build for logs, metrics emission must not sit on an uncaught path that aborts the transaction or request. |
| **[FORBID] Log-gated control flow** | Do not use “log succeeded” as a precondition for business work. |
| **[FORBID] Secrets in logs** | Tokens, passwords, full PAN/PII dumps, raw credential headers. Prefer ids + redacted summaries. |

Implementation shapes (language-agnostic):

- Prefer the project’s established logger facade; never invent a parallel channel
  that can fail the caller.
- Guard volatile log work when the stack can throw (custom appenders, remote
  shippers, expensive argument evaluation).
- Context/MDC: set/clear in `try/finally` (or framework equivalent). Cleanup and
  put failures still must not fail the request.

## Decouple from business

Logging is **infrastructure observed from domain**, not domain logic.

| Do | Don’t |
| --- | --- |
| Business code calls a thin `log.info("…", fields)` / project facade | Business code opens files, HTTP-ships logs, or catches logger errors into domain errors |
| Correlation via ambient context (MDC, ALS, contextvars) | Thread `requestId` through every pure domain function signature “for logging” |
| Sinks/shippers configured in env/ops layer | App code branches on “is ELK up?” before serving users |
| Structured fields as data | String-concat only blobs that cannot be queried |

Elegance = **smallest stack-native surface** that meets the properties — not a
custom multi-module “observability platform” unless the repo already has one.

## Minimum foundation (full bar)

1. **Unified logger API** — one pattern for new code.
2. **Levels + sinks** — dev/test/prod that emit.
3. **Correlation** — one id (or small key set) greppable across a request/job chain.
4. **Structured field habit** — document field names; prefer key-value / JSON.
5. **Redaction** — forbid-list or helpers for secrets/PII.
6. **How to read** — one documented command or platform path shared by agents and humans.

## What foundation is not

- Not full APM / tracing product selection (optional later; correlation may use
  the same id as a tracer if already present).
- Not instrumenting every existing feature path (debt paid when paths are touched).
- Not metrics/alerting design (may share fail-open rules if co-located).
- Not temporary `[DEBUG-…]` probes (`/diagnosing-bugs`).

## After foundation

| Who | Does |
| --- | --- |
| `/implement` + Executor | Decision-boundary logs on claimed critical paths; report `observability` |
| `/code-review` Correctness + Verifier | Forensic chain checklist; quiet path and log-unsafe block Pass |
| `/diagnosing-bugs` | Temporary tagged probes only; hand permanent gaps back here or implement |

Done vocabulary: see
[`../code-review/FORENSIC-OBSERVABILITY.md`](../code-review/FORENSIC-OBSERVABILITY.md).
