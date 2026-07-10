# WEN lifecycle: Wayfinder, specs, tickets, and frontier execution

Status: accepted

Supersedes in part:

- ADR 0001's unimplemented `profiles/` routing layer and absolute prohibition on
  one skill loading another skill as a completion discipline
- ADR 0003's treatment of every durable artifact as user-invoked, refined below

## Context

The planning commands used product- and tracker-specific names even though
their artifacts were broader. `to-prd` already recorded implementation and
testing decisions, while `to-issues` targeted GitHub/GitLab language despite
supporting local Markdown and custom trackers.

Large, foggy work also lacked a durable discovery structure. The project rule
routed every multi-session effort through the same settled-plan path, so agents
either guessed a spec too early or carried too much unresolved context.

ADR 0001 said route order would live in `profiles/`, but no profile layer or
profile-aware sync shipped. ADR 0003 correctly protected shared state changes,
but its durable-artifact boundary also prevented scoped research and prototype
disciplines from composing under an authorized orchestration.

## Decision

### 1. Use one artifact language

- `/to-spec` replaces `/to-prd`.
- `/to-tickets` replaces `/to-issues`.
- A **spec** is a non-runnable parent with stable requirement identifiers.
- A **ticket** is a tracker-neutral work unit; GitHub/GitLab entities remain
  issues at the adapter boundary.
- Old PRDs and issue sets remain readable and are never renamed in place.
- The old command skills are removed rather than kept as duplicate aliases.

### 2. Keep artifact kinds disjoint

The lifecycle uses five kinds:

- `spec`
- `implementation-ticket`
- `wayfinder-map`
- `wayfinder-ticket`
- `bug-report`

Only an open, `AFK`, unblocked, unclaimed `implementation-ticket` may enter the
implementation frontier. A spec or Wayfinder ticket is never executable merely
because its physical tracker object is an issue.

Open, unblocked `HITL` implementation tickets form a separate human frontier.
Manual-only gates resolve directly after the human action and evidence. Only
code-bearing HITL tickets use a paired `/implement` run with an actual-change
verification/review gate; remaining work may be reclassified to `AFK` after the
named human-owned decision is recorded.
Wayfinder child tickets use a separate discovery frontier scoped to one map.
Confirmed defects that do not yet fit one context remain non-runnable
`bug-report` intake artifacts with `needs-triage` until explicitly converted or
specified and sliced. Conversion claims the report, reuses exact `Origin`
matches, and records canonical replacements before resolving intake. Covered
defects keep the accepted source spec as replacement parent; genuinely new or
out-of-scope work records an evidence-backed move to a new spec.

### 3. Route by work shape

`docs/lifecycle.md` is the active routing source of truth:

- bounded clear work -> `/implement`
- settled multi-slice work -> `/to-spec` -> `/to-tickets`
- huge foggy work -> `/wayfinder`, then join the settled route when clear
- bugs -> `/diagnosing-bugs`

Diagnosis-only bug requests preserve tracked production files. A fix branch
requires explicit code-change authority and the same fixed-point,
verification, and review expectations as other bounded code work.

Skills stay independently invokable. A user-invoked orchestration may load a
model-invoked discipline when that discipline is a completion gate; this is
composition, not a duplicated command chain.

### 4. Make implementation one reviewable ticket

`/implement` claims one implementation-frontier ticket or explicitly named
code-bearing paired HITL ticket, establishes an isolated diff baseline,
runs TDD for behavior or a GREEN compatibility baseline for a mechanical
expand-contract ticket, then simplification, project verification, and the
independent `/code-review` discipline before updating/closing the ticket. It starts another
ticket only when the user requested a bounded loop and every ticket gets a
fresh context and isolated delta.

Claims coordinate work but are not assumed to be distributed locks. Adapters
must document their actual guarantee. If worker identity or atomic claiming is
unavailable, execution is serial. Bug-report conversion uses the same
read/claim/re-read discipline plus exact replacement lookup.

Wayfinder resolution also claims the map before its child because the decision
index is shared last-write-wins state. A map resolves serially unless its
adapter provides atomic compare-and-swap updates.

### 5. Prefer native tracker relationships

Parent and blocking relationships use native tracker features when the current
CLI/API/tier supports them. Body fields are the fallback, not a competing second
truth. Every tracker adapter defines spec/ticket operations, typed frontiers,
claim, release, idempotent bug-report conversion, completion including child
reports and replacements, Wayfinder map operations, and legacy discovery.

### 6. Allow bounded support artifacts

`/research` and `/prototype` are model-invoked support disciplines so an active
Wayfinder ticket can load them. They may run only for an explicit matching
request or an already-authorized ticket and may create bounded, reversible
evidence artifacts.

They do not mutate tracker state, relationships, manifests, production
persistence, or existing production behavior. The calling user-invoked
orchestration owns shared publication, claims, and closure. Each run reports the
artifact path and its keep/delete/promote disposition.

### 7. Retire command names safely

The sync layer records `to-prd` and `to-issues` as retired names. Managed copies
are removed. A forced migration cannot import them back from an older
agent-specific directory. An unmarked retired canonical copy blocks normal sync;
`--force` backs it up outside the active skills root before removal.

## Consequences

- The lifecycle covers discovery, specification, slicing, implementation,
  review, testing, and QA without forcing every small task through every step.
- Requirement IDs can trace `spec -> ticket -> test case -> QA evidence`.
- Wayfinder requires a complete tracker capability contract, not only a prompt.
- Existing downstream artifacts continue working, while old slash commands are
  intentionally breaking and must be migrated.
- Research/prototype gain composability but carry a narrower side-effect
  contract than user-invoked orchestration.
- Historical ADR language remains intact; this ADR records the changed decision.
