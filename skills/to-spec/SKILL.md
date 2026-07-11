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

- **Product / market / need gap** (worth-doing, target user, stakeholder inner
  need, unvalidated product intent): stop and recommend `/pm-intake` (PM
  workspace). Do not invent Expected behavior or product value here.
- **Engineering gap** (seams, contracts, migration, testability): recommend
  `/grill-with-docs`, technical `/wayfinder` when multi-session, or targeted
  `/research` / `/prototype`; resume `/to-spec` after it is settled.

Prefer PM Build/Bet handoff artifacts (PRD, `REQ-*` / `AC-*`, evidence IDs)
over chat paraphrase when available. See `docs/boundaries.md`.

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
5. Sketch the fewest useful test seams. Prefer the highest existing public seam
   and record why any new seam is necessary.
6. Load [TEMPLATE.md](TEMPLATE.md) and draft the spec. Include only
   decision-rich prototype excerpts and link the full evidence artifact.
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
