# Incomplete production surface

**Leading word: incomplete surface** — production-reachable code that *looks*
done (compiles, returns 200, passes thin tests) while the real domain step is
deferred, stubbed, dual-sourced, or marked for "later."

This file is the single source of truth. `/implement`, Executor, `/tdd`, and
`/code-review` only point here; they do not restate the classifier.

## Trigger (classifier)

Fire when the change set (or the AC it claims) includes a **user-reachable or
money/data-affecting path** and any of the following holds on that path:

| Signal | What it looks like |
| --- | --- |
| **Deferred marker** | `TODO` / `FIXME` / `HACK` / `XXX` / `待接入` / `后续` / `临时` comments that mark unfinished **production** logic (not a pure refactor note) |
| **Placeholder path** | stub, fake, no-op, fixed return, or "pending integration" that still ships a live response |
| **Dual source** | same domain fact (e.g. USD→CNY rate, tax, inventory owner) resolved from different sources on sibling channels/paths without an explicit product dual-track decision |
| **Config stand-in** | Nacos/env/hardcoded constant standing in for a domain service/table the sibling path already uses for real |
| **Quiet critical path** | production-reachable external/async/webhook/MQ/third-party/state-machine path ships behavior but **decision boundaries leave no correlatable field logs** (ingress, branch/skip, before→after, third-party outcome including empty, projection/fan-out). Looks done in tests; production incidents are forensically unsolvable. Contract: [FORENSIC-OBSERVABILITY.md](FORENSIC-OBSERVABILITY.md). |
| **Log-unsafe** | logging, MDC, metrics, or log serialization sits where failure can **abort or alter** the business path (uncaught throw from logger/appender, business `return`/`throw` gated on log success, log work inside a transaction that rolls back the domain on log failure). Logging must be **fail-open**. Contract: [FORENSIC-OBSERVABILITY.md](FORENSIC-OBSERVABILITY.md). |

If the path is **not** production-reachable (prototype skill, throwaway scratch,
test double behind a test seam, or an explicitly scoped spike the user named as
non-ship), the classifier does **not** fire. Quiet-path / log-unsafe also do not
fire for pure local pure-function diffs with no external/async/state boundary
(`observability: n/a`).

## Required behavior

| Role | Must |
| --- | --- |
| **Executor / `/implement`** | Finish the real domain step for claimed AC, **or** stop and report a blocker. Never land an incomplete surface and call the slice done. On critical paths: instrument decision boundaries, keep logging fail-open, report `observability` ([FORENSIC-OBSERVABILITY.md](FORENSIC-OBSERVABILITY.md)). |
| **`/tdd`** | Green asserts the **shared source of truth** at the seam (e.g. both pay channels use the same rate record). A test that only locks a config constant is not a lock for "uses the rate table." |
| **`/code-review` Correctness** | Incomplete surface on a production path is a **blocking** finding (confidence usually `100` when a comment admits deferral; `>=80` when dual-source, placeholder, quiet critical path, or log-unsafe is proven). Verdict cannot be `Pass`. Forensic chain checklist: [FORENSIC-OBSERVABILITY.md](FORENSIC-OBSERVABILITY.md). |
| **Verifier** | Completion claims fail when an incomplete surface remains for claimed AC — including quiet critical path and log-unsafe. |

## Allowed vs forbidden

**Forbidden (shipped incomplete surface):**

```text
// TODO: wire real rate API later; use Nacos fixed rate for now
rate = config.getExchangeRate();  // sibling channel already uses rate table
```

**Allowed (honest incomplete — not shipped as done):**

- Stop the slice; return `blocked` with the open decision (which source of truth?).
- Split work: ticket A = real integration; no user-facing path claims A until A is green.
- Prototype / throwaway under `/prototype` or an explicit user spike — never mixed into production AC.

**Allowed comments (not incomplete surface):**

- Explaining *why* a complete choice was made (not "do later").
- Tracking pure cleanup that does not change live domain behavior.

## Why this is a hard gate

A 200 + QR code + config constant *looks* finished to CI and thin review. The
bug only shows when two sibling paths are compared in production (different
rates, different money). Diff-local "style" review and Spec-only review miss it
when the ticket never said "both channels share one rate source." The classifier
forces the question: **is the domain step real on every production path this
change ships?**

A webhook handler that updates status *looks* finished when tests green and
Standards clean — until production fires once, display stays wrong, and **no
field log** can answer which branch ran or whether the third party returned
empty. Production evidence is often write-once; quiet critical paths make the
incident forensically unsolvable. Separately, logging that can throw into the
business path turns an observability aid into an outage vector — **logs must
never gate or fail the domain.**
