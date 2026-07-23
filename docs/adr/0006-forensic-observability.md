# Forensic observability: foundation, decision-boundary logs, fail-open

Status: accepted

Production-reachable paths that cross external systems, async boundaries, or
domain state machines are not complete without (1) a project logging foundation
when the project shape requires it, (2) correlatable decision-boundary field
logs, and (3) **fail-open** logging that never fails the business path. The
contract lives in `skills/code-review/FORENSIC-OBSERVABILITY.md`. Quiet critical
path and log-unsafe shipping are blocking under
`skills/code-review/INCOMPLETE-SURFACE.md`.

## Context

Agent-driven development often ships behavior that is test-green and
Standards-clean while leaving **no field record** at ingress, branch/skip,
third-party outcome (including empty), or before→after state. Diagnosis then
requires a second cycle: add logs → deploy → replay. That is costly in test and
often **impossible** in production, where webhooks and side effects are
write-once.

A second failure mode is the opposite extreme: aggressive logging that can throw
or gate the domain, turning observability into an outage vector.

Pack history already treated incomplete *domain* surface as blocking (ADR 0005)
and treated foundation construction as setup-adjacent (ADR 0001). Foundation
build now lives in `/setup-logging`; harness only classifies. This ADR binds the
**forensic** subset into the same refuse-to-pass gates, without dumping "log
everything" best practices into always-loaded `AGENTS.md`.

## Decision

1. **Single contract:** `skills/code-review/FORENSIC-OBSERVABILITY.md` —
   foundation bar, decision-boundary table, fail-open rules, review checklist,
   role duties, done vocabulary.
2. **Classifier extension:** incomplete surface gains **quiet critical path**
   and **log-unsafe** rows pointing at that contract.
3. **Foundation skill:** `/setup-logging` builds the logging foundation
   (unified API, correlation, fail-open sinks, how-to-read) with stack-native
   recipes. `/setup-project-harness` only **classifies** full/thin/partial bar
   and hands off — it does not implement logger modules.
4. **Implement / Executor:** applicable slices must instrument decision
   boundaries and report `observability`; foundation-missing or log-unsafe is
   not `done`.
5. **Correctness + Verifier:** forensic chain review is required on applicable
   diffs; quiet path and log-unsafe block `Pass`. Performance may still note
   timing/metrics gaps; decision-boundary completeness is Correctness.
6. **Fail-open is non-negotiable:** logging, MDC, and metrics failure must never
   fail, roll back, or gate business work.

## Considered Options

- **Diagnose-only instrumentation (`/diagnosing-bugs` tags).** Necessary for
  probes; insufficient as the only policy — production remains unsolvable after
  cleanup.
- **Performance-axis only "observability gaps".** Too weak; silent state
  transitions are correctness/forensic failures, not optional perf nits.
- **Always-on AGENTS essay "log more".** Rejected: violates harness thin-entry
  policy; models already know generic logging; the failure is missing *gates*
  and *fail-open*, not missing slogans.

## Consequences

- `setup-logging`, `setup-project-harness`, `implement`, `code-review`,
  `diagnosing-bugs`, and pack agents gain thin pointers to the contract and
  classifier.
- Integration-heavy greenfield repos may need `/setup-logging` before AFK
  feature work — intentional.
- Consumer projects still choose stack-specific logger libraries; the pack
  enforces *properties* (foundation, boundaries, fail-open), not a vendor.
