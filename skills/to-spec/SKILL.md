---
name: to-spec
description: Turn settled context into a non-runnable spec with stable requirements.
disable-model-invocation: true
---

# To Spec

Synthesize settled intent and repo evidence into a **non-runnable** parent for
multi-ticket work. Destination only — never executable work.

Requires tracker ops from `/setup-project-harness`. Adapter:
`docs/agents/issue-tracker.md`. Routing / anti-invention: `docs/lifecycle.md`.

## Readiness Gate

Confirm before drafting (missing user-owned decision = gap; do not invent
Expected or product value):

- problem, outcome, users, scope, out of scope clear
- core behavior, main flows, material failure paths settled
- deps / permissions / migrations / integrations / rollout named when relevant
- implementation and test choices backed by repo evidence
- remaining unknowns explicitly non-blocking

**Layer scope:** `frontend` | `backend` | `full-stack` | `non-UI`. Prefer durable
delivery inputs over chat paraphrase (`docs/handoff-package.md`). Preserve
stable source IDs.

Stop and list gaps (do not invent) when:

- UI work lacks field/rule structure or required design pin (**skip** if backend-only)
- published API/event work lacks request/response/error/authz expectations
  (**skip** if pure UI on a pinned external contract)

If not ready: route per `docs/lifecycle.md` (HEAVY PM, `/product-fog`,
`/grilling`, `/wayfinder`, `/research`, `/prototype`).

Bug-report source: [BUG-REPORT-CONVERSION.md](BUG-REPORT-CONVERSION.md)
before drafting (scope disposition + Origin reuse).

## Process

1. Read discussion and sources; preserve historical links (never rename). Keep
   bug-report repro/parent visible when applicable.
2. Read domain context, ADRs, code; trace entrypoints when claims depend on
   current behavior.
3. Run readiness gate. Separate evidence, decisions, assumptions, open questions.
4. Assign stable `REQ-###` (observable behavior + acceptance boundary) and
   `DEC-###` for implementation decisions enabling tickets must reference.
5. Sketch fewest useful test seams for the **layer in scope**; map verification
   notes; record out-of-scope layers and integration owners.
6. Load [TEMPLATE.md](TEMPLATE.md); draft. Link delivery sources. Do not invent
   UI or API beyond stated contracts.
7. Present draft, assumptions, gaps. Explicit approval in-thread counts; else wait.
8. Publish: load [PUBLISH.md](PUBLISH.md).

## Completion

Approved canonical artifact exists; every material requirement has a stable ID;
`/to-tickets` can slice without recovering chat history.

Optional: `/alignment-review`, then `/to-tickets`. System QA → optional
`wen-test` (`/to-test-plan`, `/qa-run`).
