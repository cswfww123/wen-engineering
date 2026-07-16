# Wayfinder Templates

Load when charting, graduating fog, or publishing a new decision ticket.
Use the adapter's native parent, dependency, claim, and status fields when
available; body fields are the fallback.

Short human pastes: [CONTINUE.md](CONTINUE.md).

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

- tracker: local-markdown | github | …
- root: .scratch/<slug>/   (local) or parent issue (remote)
- Domain and affected systems (one line)
- Skills: only those resolve truly needs
- Standing preferences (language, risk); keep short

## Session handoff

```text
tracker: local-markdown
map: .scratch/<slug>/WAYFINDER.md
status: active
next_ticket: <path or none>
next_discipline: research | grill-me | task | prototype | none
next_paste: /wayfinder .scratch/<slug>/WAYFINDER.md
post_map_paste: /to-spec .scratch/<slug>/
do_not_reread: FOG.md, TEMPLATES.md, full wayfinder SKILL (unless handoff broken)
notes: <≤2 lines of orientation for the next agent>
```

## Decisions So Far

- [<resolved ticket name>](<resolution reference>) — <one-line gist>

## Not Yet Specified

- <In-scope fog whose precise question is not visible yet>

## Out Of Scope

- <Boundary plus reason; link closed mis-scoped tickets when relevant>
```

Keep open tickets out of the map body. Query children for the live graph.
Refer to tickets by name in narration and in `Decisions So Far`.

**Session handoff** is required after Chart and after every Resolve stop.
`next_paste` is what the human copies into a new chat — one line.

## Decision Ticket

```markdown
Kind: wayfinder-ticket
Subtype: n/a
ID: <stable tracker reference or local ID>
Runnable: no
Mode: AFK | HITL
Discipline: research | prototype | grill-me | task
Origin: none
Parent: <map reference>
Blocked by: None | <decision ticket references>
Covers: none
Supports: none
Decision: none
Status: open
Claimed by: none
Claimed at: none
Resolution: pending

# <Short question name>

## Question

<One precise uncertainty whose answer is a *decision* (or facts a later decision
needs). Sized to one agent session. Prefer coding-shaped questions: ownership
boundary, contract, migration path, failure mode, test seam, or user-owned
product/scope/trade-off. Never invent the answer — HITL disciplines record the
user; research returns cited primary sources.>

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
| `research` | AFK | Cited primary-source artifact via `/research` subagent | Settling taste, UX feel, or user-owned trade-offs |
| `prototype` | HITL | Disposable artifact + user reaction via `/prototype` | Production code, shared schema, or permanent UI |
| `grill-me` | HITL | Recorded user decision via `/grilling` (repo facts first); **batch/diff** for tables | Questions the codebase or production config already answers |
| `task` | AFK/HITL | Facts from a prerequisite action that unblocks a decision | Delivering the destination or shipping a slice |

`task` earns its place only by unblocking a later decision (access, sample data,
production path verification, read-only inspection). It is never a disguised
implementation ticket.

**Chart budget:** first publish ≤5 open tickets. Prefer research/task; grill only
what a human must own.

## Resolution Signal Patterns

Write signals as checkable outcomes, not effort:

- **Contract:** "Chosen API/event shape with error cases listed and one rejected alternative."
- **Ownership:** "Named module/service owns the invariant; callers and write paths identified in repo."
- **Runtime / production:** "Live ingress URL or config key verified (file path, gateway, or owner confirmation); code-only guesses rejected."
- **Migration:** "Expand/contract or cutover steps listed with rollback and dual-read/write window if needed."
- **AuthZ:** "Who can do what, on which resource, with the denial path named."
- **Failure:** "Partial failure, retry, and idempotency expectations stated for the critical path."
- **Test seam:** "Public behavior or concurrency seam named so `/to-tickets` can require a test."
- **Product / scope trade-off:** "User chose Recommended or an alternative after one framed question; Expected/out-of-scope recorded."
- **Mapping table:** "Recommended full table posted; user accepted or replied with row-level diffs only."
- **User trade-off:** "User picked Recommended or an alternative after one framed question."
- **Research:** "Primary sources cited; version/date noted; applicability limits listed."
- **Prototype:** "User reacted to the disposable artifact; keep/change decision recorded."

Reject weak signals such as "look into X", "research options", or "discuss with team"
without a stated sufficiency bar. Reject "Controller exists in module Y" as proof of
**production** ownership without runtime evidence.

## Fog Graduation

Full model: [FOG.md](FOG.md).

- **Ticket when** the question can be stated precisely now — even if blocked.
- **Not yet specified when** only a dim area is visible. One fog line may later
  become several tickets, one ticket, or none. Do not pre-slice a full backlog.
- **Out of scope when** the work sits past the destination (including second
  epics such as broad architecture cleanup). Close any live ticket that lands
  there; do not treat scope cuts as decisions on the route.
