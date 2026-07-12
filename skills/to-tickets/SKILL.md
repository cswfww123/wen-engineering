---
name: to-tickets
description: Turn an approved spec into a dependency-aware set of executable tickets.
disable-model-invocation: true
---

# To Tickets

Turn an approved spec into tracer-bullet tickets whose graph exposes the
implementation frontier.

Requires tracker ops from `/setup-project-harness`. Adapter:
`docs/agents/issue-tracker.md`, labels: `docs/agents/triage-labels.md`.
Routing / anti-invention: `docs/lifecycle.md`.

## Gather Evidence

1. Read the approved spec (or legacy `PRD.md` with stable source refs; else
   `/to-spec` first without renaming history).
2. Read domain context/ADRs; trace entrypoints when slice boundaries, blockers,
   seams, or integrations depend on code.
3. Unresolved product decisions → back to the spec, not hidden in tickets.

Bug-report source: only when an accepted parent **already covers** the defect —
see [BUG-REPORT-CONVERSION.md](BUG-REPORT-CONVERSION.md).
Otherwise stop → `/to-spec`.

## Draft The Graph

Narrow vertical slices. Each implementation ticket normally:

- delivers observable end-to-end behavior through every layer it needs
- fits implement + tests + simplify + verify + review in **one fresh context**
- is independently demoable when blockers complete
- declares `Kind`, `Mode`, `Covers`, `Blocked by`
- covers one+ stable requirement/source IDs with concrete AC
- uses only genuine prerequisite edges (acyclic graph)

**Only mechanical exception:** behavior-preserving expand-contract in
[EXPAND-CONTRACT.md](EXPAND-CONTRACT.md) (`Covers: none` + `Supports` +
`Decision` + compatibility evidence).

- `Mode: AFK` — agent can finish without live judgment (implementation frontier)
- `Mode: HITL` — manual/user gate (human frontier; outside AFK frontier)
- Fold a small prefactor into the first vertical slice it unlocks
- Fan-out mechanical refactor with no green vertical slice → expand-contract only

Load [TEMPLATE.md](TEMPLATE.md) while drafting.

## Get Approval

Numbered draft per ticket: title, `Mode`, `Covers`, delivery, `Blocked by`. Also:

- uncovered or deferred requirements
- initial AFK and HITL frontiers
- any slice too large for one fresh context

`Supports` is not requirement coverage. Iterate until approved (in-thread
approval counts).

## Publish

Load [PUBLISH.md](PUBLISH.md).

## Completion

Every in-scope requirement covered or explicitly deferred; graph acyclic; each
ticket fits one fresh context; tracker can identify both frontiers without the
planning chat.

Optional: `/alignment-review`. `/implement` takes one implementation-frontier
ticket per fresh context (or one explicitly named code-bearing HITL ticket).
