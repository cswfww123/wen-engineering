# Wayfinder Templates

Load these templates only when charting or publishing newly surfaced tickets.
Use the configured adapter's native parent, dependency, claim, and status
fields where available; body fields are the fallback.

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

<The state, decision, or spec this map is finding a route toward.>

## Notes

<Constraints, evidence conventions, and tracker adapter conventions.>

## Decisions So Far

- [<resolved ticket name>](<resolution reference>) — <one-line gist>

## Not Yet Specified

- <In-scope fog whose precise question is not visible yet>

## Out Of Scope

- <Boundary plus reason>
```

Keep open tickets out of the map body. Query child tickets for the live graph.

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

# <Question as a short name>

## Question

<One precise uncertainty whose answer moves toward the destination.>

## Resolution Signal

<What evidence or user decision makes the answer sufficient.>

## Notes

<Relevant constraints or evidence pointers; keep the answer out until closure.>
```

Put the answer in the resolution comment and link any research or prototype
artifact. The map receives only a named pointer and a one-line gist.
