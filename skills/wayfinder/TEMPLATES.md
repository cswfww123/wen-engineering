# Wayfinder Templates

Load when charting, graduating fog, or publishing a new discovery ticket.
Use the adapter's native parent, dependency, claim, and status fields when
available; body fields are the fallback.

## Map

```markdown
Kind: wayfinder-map
ID: <stable tracker reference or local ID>
Runnable: no
Status: active | resolved
Claimed by: none
Claimed at: none

# Wayfinder: <destination name>

## Destination

<The production coding state this map finds a route toward — usually an honest
spec, a locked architecture/data decision, or a migration readiness gate.
One or two lines; every session orients here first.>

## Notes

- Domain and affected systems
- Repo evidence conventions (paths, ADRs, invariants)
- Skills every resolve session should consult
- Standing preferences for this effort (tracker, language, risk appetite)

## Decisions So Far

- [<resolved ticket name>](<resolution reference>) — <one-line gist>

## Not Yet Specified

- <In-scope fog whose precise question is not visible yet>

## Out Of Scope

- <Boundary plus reason; link closed mis-scoped tickets when relevant>
```

Keep open tickets out of the map body. Query children for the live graph.
Refer to tickets by name in narration and in `Decisions So Far`.

## Discovery Ticket

```markdown
Kind: wayfinder-ticket
Subtype: n/a
ID: <stable tracker reference or local ID>
Runnable: no
Mode: AFK | HITL
Discipline: research | prototype | grilling | task
Origin: none
Parent: <map reference>
Blocked by: None | <discovery ticket references>
Covers: none
Supports: none
Decision: none
Status: open
Claimed by: none
Claimed at: none
Resolution: pending

# <Short question name>

## Question

<One precise uncertainty whose answer moves toward the destination.
Sized to one agent session. Prefer coding-shaped questions: ownership boundary,
contract, migration path, failure mode, test seam, or user-owned product/scope/
trade-off decision. Never invent the answer — HITL disciplines record the user.>

## Resolution Signal

<What evidence or user decision makes the answer sufficient — measurable enough
that a later session can judge pass/fail without re-arguing the ticket.>

## Notes

<Constraints, evidence pointers, authorized disposable setup. Keep the answer
out of the body until closure.>
```

Put the answer in the resolution comment. Link research or prototype artifacts.
The map receives only a named pointer and a one-line gist.

## Discipline Picker

Choose the smallest discipline that can satisfy the Resolution Signal:

| Discipline | Mode | Produce | Do not use for |
| --- | --- | --- | --- |
| `research` | AFK | Cited primary-source artifact via `/research` | Settling taste, UX feel, or user-owned trade-offs |
| `prototype` | HITL | Disposable artifact + user reaction via `/prototype` | Production code, shared schema, or permanent UI |
| `grilling` | HITL | Recorded user decision (repo evidence first) | Questions the codebase already answers |
| `task` | AFK/HITL | Facts from a prerequisite action that unblocks a decision | Delivering the destination or shipping a slice |

`task` earns its place only by unblocking a later decision (access, sample data,
read-only inspection, authorized disposable setup). It is never a disguised
implementation ticket.

## Resolution Signal Patterns

Write signals as checkable outcomes, not effort:

- **Contract:** "Chosen API/event shape with error cases listed and one rejected alternative."
- **Ownership:** "Named module/service owns the invariant; callers and write paths identified in repo."
- **Migration:** "Expand/contract or cutover steps listed with rollback and dual-read/write window if needed."
- **AuthZ:** "Who can do what, on which resource, with the denial path named."
- **Failure:** "Partial failure, retry, and idempotency expectations stated for the critical path."
- **Test seam:** "Public behavior or concurrency seam named so `/to-tickets` can require a test."
- **Product / scope trade-off:** "User chose Recommended or an alternative after one framed question; Expected/out-of-scope recorded."
- **User trade-off:** "User picked Recommended or an alternative after one framed question."
- **Research:** "Primary sources cited; version/date noted; applicability limits listed."
- **Prototype:** "User reacted to the disposable artifact; keep/change decision recorded."

Reject weak signals such as "look into X", "research options", or "discuss with team"
without a stated sufficiency bar.

## Fog Graduation

Full model: [FOG.md](FOG.md).

- **Ticket when** the question can be stated precisely now — even if blocked.
- **Not yet specified when** only a dim area is visible. One fog line may later
  become several tickets, one ticket, or none.
- **Out of scope when** the work sits past the destination. Close any live
  ticket that lands there; do not treat scope cuts as decisions on the route.
