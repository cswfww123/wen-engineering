# Observability foundation (harness setup)

Harness-side gate for `/setup-project-harness`. The pack forensic contract
(decision-boundary logs, review checklist, fail-open, done vocabulary) lives in:

`skills/code-review/FORENSIC-OBSERVABILITY.md`

(when this pack is installed). This file states only what **setup** must do.

## Classify the bar

| Bar | When | Setup must |
| --- | --- | --- |
| **Full** | HTTP API, jobs, MQ, webhooks, multi-tenant, third-party SDK, state machines | Ensure minimum foundation before agent-ready |
| **Thin** | Pure library / pure functions / no production I/O side effects | Record thin; no foundation build |
| **Partial** | Some logger exists, gaps remain | Close gaps to full or document intentional thin with user OK |

## Minimum foundation (full bar)

1. Unified logger API (project-native; e.g. SLF4J + backend for Java)
2. Levels and sinks for dev/test/prod that actually emit
3. Correlation (request / job / webhook / message id or MDC keys)
4. Structured field habit documented for new code (ids, outcome, before/after)
5. Redaction: secrets and bulk PII stay out of logs
6. **How to read** — one command or platform path in README / `docs/agents/` /
   ops notes so agents and humans share the same evidence channel

## Fail-open (always, any bar that logs)

**[MUST]** Logging, MDC, and metrics must never fail, roll back, or gate
business work. Setup and any logging rule files must state this explicitly when
the project adds logging infrastructure.

## What setup does *not* do

- Does not require a specific vendor (ELK, Loki, CloudWatch, …) unless the repo
  already standardizes one.
- Does not instrument every existing feature path in one setup pass — that is
  implement/review debt paid when paths are touched.
- Does not paste generic "always log" essays into always-loaded `AGENTS.md`.

## After foundation

`/implement` and `/code-review` own decision-boundary instrumentation and
forensic chain review on touched critical paths. See the pack forensic contract.
