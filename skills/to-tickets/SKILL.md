---
name: to-tickets
description: Turn an approved spec into a dependency-aware set of executable tickets.
disable-model-invocation: true
---

# To Tickets

Turn an approved spec into tracer-bullet tickets whose dependency graph exposes
the implementation frontier.

This skill requires the tracker operations configured by
`/setup-project-harness`. Read `docs/agents/issue-tracker.md` and
`docs/agents/triage-labels.md` before publishing.

## Gather Evidence

1. Read the approved `SPEC.md` or tracker spec, including comments and linked
   evidence. A legacy `PRD.md` remains valid input when it has stable source
   references; otherwise use `/to-spec` to supersede it without renaming it.
2. Read relevant domain context and ADRs. Trace the current entrypoint when
   slice boundaries, blockers, integration layers, or test seams depend on code.
3. Confirm the source is settled. Route unresolved product decisions back to
   the spec rather than hiding them inside implementation tickets.

When the explicit source also includes a `bug-report`, use this route only when
its accepted parent spec already covers the defect and no new requirement or
scope decision is needed. Read its `Converted to` pointer and search exact
ticket `Origin` fields before drafting; reuse any canonical replacements. If the
defect is genuinely new or outside that spec, stop and recommend `/to-spec`.

## Draft The Graph

Break the work into narrow vertical slices. Every implementation ticket
normally must:

- deliver observable end-to-end behavior through every layer it needs
- fit implementation, tests, simplification, verification, and review in one
  fresh agent context
- be independently demoable or verifiable when its blockers are complete
- declare `Kind`, `Mode`, `Covers`, and `Blocked by`
- cover one or more stable requirement IDs or legacy source references with
  concrete acceptance criteria; only an expand-contract enabling ticket may
  use `Covers: none`, and then it must declare `Supports` source IDs plus a
  stable `Decision` source
- use only genuine prerequisite edges; the graph must be acyclic

The only mechanical exception is the behavior-preserving expand-contract branch
in [EXPAND-CONTRACT.md](EXPAND-CONTRACT.md); it requires compatibility evidence
and the explicit `Covers`/`Supports`/`Decision` trace described there.

Use `Mode: AFK` only when an agent can finish without live judgment. Use
`Mode: HITL` for a manual or user-owned gate; it stays outside the AFK frontier.

Fold a small prerequisite prefactor into the first vertical slice it unlocks.
When one mechanical refactor fans across the codebase and no vertical slice can
stay green, use the sole enabling-ticket exception in
[EXPAND-CONTRACT.md](EXPAND-CONTRACT.md).

Load [TEMPLATE.md](TEMPLATE.md) while drafting and publishing tickets.

## Get Approval

Present a numbered draft. For each ticket show title, `Mode`, `Covers`, what it
delivers, and `Blocked by`. Also show:

- uncovered or deliberately deferred requirements
- the initial implementation frontier: open, unblocked, unclaimed `AFK` tickets
- the initial human frontier: open, unblocked, unclaimed `HITL` tickets
- any slice too large for one fresh context

`Supports` does not count as requirement coverage; it only explains why a
behavior-preserving enabling ticket exists.

Ask the user to approve granularity, coverage, modes, and blocking edges.
Iterate until approved; explicit approval already given in the current
discussion satisfies this gate.

## Publish

1. For a bug-report source, claim it through the adapter, re-read ownership, and
   repeat the exact `Origin` search. If another worker converted it, reuse that
   graph and do not publish duplicates. Use serial conversion when claims are
   not atomic or workers share one identity.
2. Create only missing tickets in dependency order so blockers have stable
   identities. Every replacement uses `Origin: <bug-report>`.
3. Attach each ticket to the existing accepted spec parent. Prefer native parent
   and blocking relationships; use body fields only when the configured adapter
   lacks them. Keep one source of truth for each relationship.
4. Apply `ready-for-agent` only to open `AFK` implementation tickets. Use the
   configured `ready-for-human` role for `HITL` tickets.
5. Leave the parent spec open and non-runnable.
6. Query the tracker after publication and report the canonical ticket set,
   requirement coverage, and actual implementation/human frontiers.
7. For a bug-report source, only after the full graph reads back, write every
   canonical replacement to `Converted to`, record
   `covered-by-existing-parent` as the scope disposition, resolve the report, read it
   back, and release the conversion claim. The original spec stays blocked by
   the open replacement tickets. On failure, keep the report open; release the
   claim when conversion is no longer actively continuing.

## Completion

The ticket set is complete when every in-scope requirement is covered or
explicitly deferred, the graph is acyclic, each ticket fits one fresh context,
and the tracker can identify both implementation and human frontiers without
rereading the planning chat.

Recommend `/alignment-review` before execution when the breakdown needs an
independent check. `/implement` works one implementation-frontier ticket per
fresh context, or one explicitly named code-bearing paired HITL ticket.
