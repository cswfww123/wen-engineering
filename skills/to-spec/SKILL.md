---
name: to-spec
description: Turn settled context into a non-runnable spec with stable requirements.
disable-model-invocation: true
---

# To Spec

Synthesize settled user intent and repo evidence into the canonical parent for
multi-ticket work. A spec describes the destination; it is never runnable work.

This skill requires the tracker and artifact operations configured by
`/setup-project-harness`. Read `docs/agents/issue-tracker.md` before publishing.

## Readiness Gate

Confirm every item before drafting:

- problem, outcome, affected users, scope, and out of scope are clear
- core behavior, main flows, and material failure paths are settled
- dependencies, permissions, migrations, integrations, and rollout constraints
  are named when relevant
- implementation and testing decisions are supported by repo evidence
- remaining unknowns are explicitly non-blocking

Treat a missing or contradictory user-owned decision as a readiness gap.

- **Product / market / need gap**: stop and hand to the product/design owner or
  the team's product process (optional `/pm-intake` only if `wen-pm` is in use).
  Do not invent Expected behavior or product value here.
- **Engineering gap** (seams, contracts, migration, testability): recommend
  `/grill-with-docs`, technical `/wayfinder` when multi-session, or targeted
  `/research` / `/prototype`; resume `/to-spec` after it is settled.
- **UI package gap** (this work changes user-visible UI without field/rule
  structure or a pinned delivery design version): stop and list gaps for the
  product/design owner. Do not invent fields or copy from screenshots alone.
  **Skip this check for backend-only / non-UI specs.**
- **API package gap** (this work changes a published API/event without stated
  request/response/error/authz expectations): stop and list gaps. **Skip for
  pure UI tickets that only consume a pinned external contract/mocks.**

State the **layer scope**: `frontend` | `backend` | `full-stack` | `non-UI`.
Prefer durable delivery inputs from any source (optional `wen-pm` package,
other PRD, in-repo docs, ticket AC) over chat paraphrase. See
`docs/handoff-package.md`. Preserve stable source IDs when present.

## Bug Report Source

When the explicit source is a `bug-report`, first decide its scope disposition.
If an accepted parent spec already covers the defect, stop and recommend
`/to-tickets` against that parent. Use this route only when the work is genuinely
new, outside the original scope, or requires a new accepted requirement set.

Before drafting, read the report, inspect `Converted to`, and search exact
`Origin` fields for an existing replacement. Reuse one canonical replacement;
never publish a duplicate. Record why the report is moving out of its original
scope. If that disposition is not evidence-backed, keep the report open so its
original parent remains blocked.

## Process

1. Read the current discussion and any source docs, issues, prior specs, or
   legacy PRDs. Preserve their links; never rename historical artifacts. Keep a
   source bug report's reproduction, QA evidence, and original parent visible.
2. Read the relevant domain context, ADRs, and code. Trace the entrypoint when a
   claim depends on current behavior, ownership, data flow, or side effects.
3. Run the readiness gate. Separate evidence, accepted decisions, assumptions,
   and open questions instead of turning uncertainty into requirements.
4. Choose stable `REQ-###` identifiers. Each requirement states observable
   behavior and an acceptance boundary. Give a stable `DEC-###` identifier to
   any implementation decision an enabling ticket must reference.
5. Sketch the fewest useful test seams for the **layer in scope**. Prefer the
   highest existing public seam. Map scenarios and UI rules or API contract
   items onto verification notes when present. Record out-of-scope layers and
   integration owners (e.g. FE-only consuming API@v).
6. Load [TEMPLATE.md](TEMPLATE.md) and draft the spec. Link delivery sources
   (PRD/docs/design pin/OpenAPI as applicable). Do not invent UI beyond the UI
   contract or API beyond the stated contract.
7. Present the draft, assumptions, and evidence gaps. Treat explicit approval
   already given in the current discussion as approval; otherwise wait for it.
8. Immediately before publication, claim and re-read a bug-report source through
   the adapter, then repeat the exact `Origin` search. Reuse an equivalent
   canonical spec if another worker already created it. For every normal source,
   and for bug intake without a replacement, publish the approved draft through
   the configured adapter as `Kind: spec`, `Runnable: no`, `Status: accepted`,
   and `Origin: <bug-report | none>`. Leave executable triage roles such as
   `ready-for-agent` for implementation tickets, then read the canonical spec
   back and report its path or URL.
9. For a bug-report source, only after that read-back write the canonical spec
   reference and evidence-backed scope disposition to both the report and its
   original source. Read both back, set the report's `Converted to`, resolve it
   as superseded, read it back, and release the conversion claim. If publication
   or read-back fails, leave the report open and release the claim when stopping;
   retain it only while a recoverable conversion is actively continuing.

## Completion

The spec is complete when the approved canonical artifact exists, every
material requirement has a stable ID, and `/to-tickets` can slice it without
recovering decisions from chat history.

Recommend `/alignment-review` when independent intent review is valuable, then
`/to-tickets` for an approved spec and `/to-test-plan` for delivery coverage.
