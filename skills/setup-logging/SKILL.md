---
name: setup-logging
description: Build a project logging foundation — unified API, correlation, fail-open sinks, how-to-read. Stack-native (Spring, Next.js, Python, …).
disable-model-invocation: true
---

# Setup Logging

**Leading word: crime scene** — production incidents are often write-once
(webhooks, async jobs, third-party calls, state machines). Logs are the only
replay. This skill builds a **logging foundation** so later code can leave a
forensically solvable field record — without ever letting logging break business.

This skill owns **foundation construction**. Decision-boundary instrumentation
on feature paths, and forensic review gates, stay in
[`code-review/FORENSIC-OBSERVABILITY.md`](../code-review/FORENSIC-OBSERVABILITY.md).
`/setup-project-harness` only classifies bar and points here; it does not build logs.

## Output contract

Deliver only what the project shape requires:

1. **Unified logger API** — one project pattern for new code (no `print` / multi-framework soup).
2. **Levels + sinks** — dev/test/prod configs that actually emit.
3. **Correlation** — request / job / webhook / message id (or equivalent context keys).
4. **Structured field habit** — documented shape for ids, outcome, before/after, reason.
5. **Redaction rules** — secrets and bulk PII stay out.
6. **Fail-open** — logging, MDC/context, metrics failure never fails or gates domain work.
7. **How to read** — one command or platform path in README / `docs/agents/` / ops notes.
8. Optional: a **thin facade or bootstrap** at the stack-native seam (not a second logging empire).

Do **not**: pick a vendor stack the repo never uses; instrument every legacy path
in one pass; paste “always log more” essays into always-loaded `AGENTS.md`.

## Start gate

```bash
# signals only — adapt to the repo
rg -n "logger|logging|logback|log4j|pino|winston|structlog|slog\\.|zap\\." \
  --glob '!**/node_modules/**' --glob '!**/.git/**' -g '!**/vendor/**' | head
```

Report existing foundation status: `present` | `partial` | `missing` | `thin-n/a`.
If full foundation already present and how-to-read is documented, stop after a
short audit report unless the user asked to upgrade.

## Workflow

### 1. Explore stack and bar

Read repo evidence (manifests, existing log config, middleware, deploy notes):

| Bar | When | This skill does |
| --- | --- | --- |
| **Full** | HTTP API, jobs, MQ, webhooks, multi-tenant, third-party SDK, state machines | Build or close gaps to minimum foundation |
| **Thin** | Pure library / pure functions / no production I/O side effects | Record thin; no foundation build |
| **Partial** | Some logger exists, gaps remain | Close gaps or document intentional thin with user OK |

Completion: bar + foundation status + stack (language, framework, existing logger) stated from evidence.

### 2. Load methodology, then stack recipe

1. Read [PRINCIPLES.md](PRINCIPLES.md) — non-negotiable properties (always).
2. Load only the matching recipe in [STACKS.md](STACKS.md) for this repo’s stack.
3. Prefer **stack-native** tools already in the repo over introducing a new brand.

Completion: chosen API surface, correlation mechanism, sink plan, redaction approach named.

### 3. Draft before write

Show the user (or AFK draft) before mutating:

- files to add/change (config, bootstrap, middleware/filter, docs)
- sample log line / JSON shape at one ingress
- correlation key names
- how-to-read command or console path
- fail-open strategy for this stack
- what is **out of scope** (per-feature decision-boundary work → `/implement`)

Do not silently overwrite a working production log pipeline; merge or gap-close.

### 4. Implement foundation (generation rules)

Give the coding agent a **clear build order** — one vertical slice, not a tour:

1. Logger bootstrap / module (single entry for app code).
2. Level + sink config per environment (prove emit in the cheapest env first).
3. Correlation context (middleware / filter / interceptor / contextvars) with
   `try/finally`-style cleanup where the stack needs it.
4. Redaction helpers or documented forbid-list.
5. One **smoke path** that logs a structured line under a known correlation id
   (health, sample route, or test) so how-to-read is real.
6. How-to-read doc (README section or `docs/agents/logging.md`).
7. Optional one-line Checklist pin in `AGENTS.md` **only** if the repo already
   proved log-unsafe or quiet-path failures — never a logging essay.

**Generation invariants** (encode in code comments / module docs only if useful):

- Business code depends on the **logger facade**, never on a shipper/appender.
- Every log call site is **fail-open** (see PRINCIPLES).
- Correlation is ambient (context/MDC), not threaded through every domain signature.
- Prefer structured key-value fields over free-text-only messages.

### 5. Verify

Run [VERIFY.md](VERIFY.md). Foundation is not done until emission + correlation +
fail-open posture + how-to-read are evidenced.

### 6. Report

```markdown
## Setup Logging — Done

- Bar: full | thin | partial
- Stack: <language / framework / logger>
- Foundation: present | upgraded-from-partial
- Correlation keys: <list>
- How to read: `<command or path>`
- Files changed: <list>
- Verification: <commands + outcomes>
- Out of scope: decision-boundary instrumentation on features → /implement + FORENSIC-OBSERVABILITY
```

## Related

- Forensic contract (boundaries, review, done vocabulary):
  [`../code-review/FORENSIC-OBSERVABILITY.md`](../code-review/FORENSIC-OBSERVABILITY.md)
- Quiet path / log-unsafe classifier:
  [`../code-review/INCOMPLETE-SURFACE.md`](../code-review/INCOMPLETE-SURFACE.md)
- Harness wiring only: `/setup-project-harness`
- Temporary DEBUG probes: `/diagnosing-bugs` (not a substitute for foundation)

## Done

Complete when bar is classified, full-bar projects have minimum foundation plus
how-to-read, fail-open is explicit in the foundation design, verification
passed, and feature-path instrumentation is correctly left to implement/review.
