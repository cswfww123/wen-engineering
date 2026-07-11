# WEN Engineering Lifecycle

This is the routing source of truth for WEN skills. The route follows the shape
of the work; it is not a form every request must complete.

This repo is for **production coding**: settled product intent becomes
verifiable engineering work. Product, market, and inner-need discovery belong
in the companion PM workspace (`wen-pm` / `/pm-intake`). See
[boundaries.md](boundaries.md).

## Choose The Entry

### Product or market fog (reject into PM)

Stop the engineering lifecycle and recommend PM discovery when material
uncertainty is about:

- whether the work is worth doing, for whom, or what outcome to optimize
- customer or stakeholder inner need, interviews, opportunity framing
- market positioning, pricing, GTM, or unvalidated product bets
- "what they really meant" after a rejected implementation, when intended
  behavior is still product-ambiguous

Do not open `/wayfinder`, `/to-spec`, or `/implement` to invent product answers.
Hand off to `/pm-intake` (or the project's PM process) with the gap named.

### Clear, bounded work

Use `/implement` directly when product intent is settled enough to code and one
context can hold the task and its acceptance boundary. Do not create a spec or
tickets just to satisfy the lifecycle.

### Settled, multi-slice work (default multi-session path)

Use this route when the destination is understood but implementation needs more
than one independently verifiable slice:

```text
settled product package -> /to-spec -> /to-tickets -> /implement -> /qa-run
```

Prefer the PM handoff package (Product Delivery Contract, `SCN-*`, UI contract +
pin when visual). See [handoff-package.md](handoff-package.md).

- `/to-spec` records stable requirements and technical/testing decisions;
  preserves PM IDs; refuses incomplete UI packages.
- `/to-tickets` creates one-context tracer bullets with blocking edges and UI
  subset fields when needed.
- `/implement` claims one runnable ticket, runs behavior (+ UI fidelity) gates,
  and stops unless the user explicitly requested a bounded multi-ticket loop.
- `/qa-run` judges completion with the same dual gates when UI is in scope.

Use `/grill-with-docs` first when the plan needs same-session technical
sharpening (seams, terms, ADRs) but is not multi-session fog.
Use `/alignment-review` before implementation when intent, coverage, slicing,
or repo fit is risky. Use `/to-test-plan` while requirements are fresh when QA
needs a durable coverage artifact. Use `/qa-run` after implementation when
release completion needs runtime evidence.

### Technical multi-session fog (advanced, rare)

Use `/wayfinder` **only** when product intent is already settled (or the work is
purely engineering: migration, platform, performance, reliability) and the
**technical route** is still too foggy for an honest `/to-spec` in one session:

```text
settled product + technical fog -> /wayfinder -> /to-spec -> /to-tickets
```

Wayfinder maps **engineering** discovery, not product discovery and not
destination implementation. Each session resolves at most one research,
prototype, grilling, or prerequisite ticket, gated by that ticket's Resolution
Signal. If the opening breadth-first pass finds no real technical fog, skip the
map and use the settled route. If the fog is product/market/need, stop and
route to PM instead.

### Bugs and regressions

Use `/diagnosing-bugs` to build a tight reproducer and prove the root cause.
Diagnosis-only requests leave tracked production files unchanged. An explicitly
authorized direct fix uses a fixed point, regression coverage, verification,
and code review. A named non-runnable bug report remains diagnosis-only until a
user-invoked workflow converts it.

After diagnosis, use explicit `/implement` when one context fits. When an
accepted parent spec already covers a broader defect, use `/to-tickets` and keep
that spec as every replacement's parent. Use `/to-spec` followed by
`/to-tickets` only for genuinely new/out-of-scope work, recording that scope
disposition before resolving the intake. If the "bug" is really rejected product
intent, route to PM discovery rather than inventing Expected behavior here.

## Artifact Model

- **Spec** (`Kind: spec`) is a non-runnable parent artifact. It may be stored as
  a tracker issue, but it is not an implementation ticket.
- **Implementation ticket** (`Kind: implementation-ticket`) is normally one
  vertical slice. The named expand-contract exception permits a mechanical,
  behavior-preserving enabling ticket with compatibility evidence.
  `Mode: AFK` tickets may enter the implementation frontier.
- **Wayfinder map** (`Kind: wayfinder-map`) indexes technical discovery decisions.
- **Wayfinder ticket** (`Kind: wayfinder-ticket`) resolves engineering uncertainty
  and is never consumed by `/implement` as a code ticket.
- **Bug report** (`Kind: bug-report`) is a confirmed but not yet one-context
  defect intake. It stays `needs-triage` and outside every execution frontier
  until an explicit `/implement` run converts a bounded, settled report or the
  work is specified and sliced. Conversion claims the report, reuses exact
  `Origin` matches, and records canonical replacements before resolution.
- **Implementation frontier** is the open, unblocked, unclaimed `AFK` set.
- **Human frontier** is the open, unblocked, unclaimed `HITL` set. A human may
  resolve a manual-only gate directly with evidence. Only a code-bearing HITL
  ticket may explicitly pair with `/implement`, using the evidence loop for its
  actual change plus verification and review. Once the gate is settled, the
  adapter may reclassify remaining work to `AFK`.
- **Discovery frontier** is the open, unblocked, unclaimed child-ticket set of
  one technical Wayfinder map. It never uses `ready-for-agent`.

GitHub and GitLab still store tracker objects as issues. Ticket is the neutral
workflow term above those adapters.

## One Ticket, One Reviewable Delta

Before editing a ticket, claim it and record a baseline that can isolate its
delta. A dirty or shared working tree is acceptable only when the ticket's diff
can still be proven independently. Otherwise use an isolated worktree or stop.

The implementation completion gate is:

```text
claim -> behavior test or compatibility baseline -> simplify -> verification -> code review -> close
```

`/code-review` remains independently useful; `/implement` loads it as a shared
discipline instead of duplicating its review rules. Blocking findings must be
resolved and verification rerun before the ticket closes. Commits remain
controlled by the user or project workflow.

The parent spec remains accepted and open while its child graph runs. After all
in-scope implementation and human tickets and converted replacements resolve,
and every child bug report is resolved or explicitly out of scope with evidence,
a `Complete` `/qa-run` records requirement evidence, marks the spec `delivered`,
and closes it. When a project does not require QA, an explicit human closeout
applies the same evidence gate. `/implement` never closes the parent spec.

## Context And Concurrency

- Keep the alignment-to-ticket conversation together while it remains inside
  the model's useful context window.
- Start implementation tickets in fresh contexts. A parent orchestrator may
  run several only when every ticket has an isolated delta and fresh worker.
- A claim coordinates workers; it is not automatically an atomic lock. If the
  tracker cannot distinguish workers or provide safe claiming, work serially.
- Bug-report conversion uses the same read/claim/re-read discipline plus an
  exact `Origin` lookup; non-atomic or shared-identity conversions run serially.
- Recompute affected frontiers after every resolution, mode transition, or
  completed implementation.

## Support Disciplines

`/research` and `/prototype` may run from an explicit matching request or an
active Wayfinder ticket. They may create bounded, reversible evidence artifacts
inside the authorized scope. They do not mutate tracker state, dependencies,
manifests, production persistence, or existing production behavior; the parent
orchestration owns claims, publication, and closure.

Use them for **engineering** questions (contracts, APIs, disposable seam
probes). Product prototypes that test market or user value belong in PM.

## Legacy Compatibility

New local artifacts use `SPEC.md`, `tickets/`, and `bugs/`. Existing `PRD.md`,
`issues/`, PRD links, and issue sets remain valid inputs. Never rename
historical artifacts in place merely to adopt the new vocabulary.
