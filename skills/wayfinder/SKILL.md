---
name: wayfinder
description: Chart and resolve discovery work for large, foggy, multi-session efforts.
disable-model-invocation: true
---

# Wayfinder

Find a route to a named destination when the route is too foggy for a spec and
too large for one session. The map indexes decisions; discovery tickets own the
detail.

This skill requires the Wayfinder operations configured by
`/setup-project-harness`: map and ticket storage, parent, blocking, discovery frontier,
claim, resolution, and closure. Read `docs/agents/issue-tracker.md` first.

Choose one mode:

- no map supplied: **Chart**
- map path, URL, or identifier supplied: **Resolve**

Resolve at most one discovery ticket in a session. Charting never also resolves
a ticket.

## Chart

1. Name the destination with the user: the spec, decision, or prerequisite
   state this effort must make possible. The destination fixes scope.
2. Explore breadth-first. Separate:
   - precise questions that can become live discovery tickets
   - in-scope fog that is not yet precise enough to ticket
   - work beyond the destination
3. If exploration finds no multi-session fog, stop before creating tracker
   state. Report that the work can proceed to `/to-spec` or `/implement`.
4. Load [TEMPLATES.md](TEMPLATES.md). Publish one non-runnable map with the
   destination, notes, unresolved fog, and out-of-scope boundary.
5. Create only questions precise enough to answer now as child discovery
   tickets. Create identities first, then wire genuine blocking edges.
6. Query and report the discovery frontier, then stop for this session.

The map lists no open tickets; the tracker query is their source of truth. Its
`Decisions so far` section contains only named links plus one-line gists. The
linked resolution remains the detail source.

## Resolve

1. Load the map's low-resolution body, claim the map, and re-read ownership.
   The map claim serializes updates to its decision index; if the adapter cannot
   distinguish workers or lock the map, resolve that map serially.
2. Query the map's discovery frontier. If it is empty, either perform terminal
   closeout when no fog remains, or release the map claim and report the
   still-imprecise fog; then stop. Otherwise choose the named ticket, or the
   first in tracker order, claim it, and re-read ownership. Load full ticket
   bodies only when they become relevant.
3. Resolve exactly that ticket:
   - `research` / `AFK`: load `/research`
   - `prototype` / `HITL`: load `/prototype` and get the user's reaction
   - `grilling` / `HITL`: ask one evidence-backed question at a time
   - `task`: perform only read-only inspection or a disposable evidence setup
     already authorized by the ticket
4. Check the ticket's `Resolution Signal`. If the evidence or user reaction is
   insufficient, record partial evidence, keep the ticket open, release child
   and map claims, report the blocker, and stop. Otherwise record one resolution
   comment, close the ticket, and append one named context pointer to
   `Decisions so far`.
5. Graduate newly precise fog into tickets, create identities before edges, and
   remove each graduated item from `Not yet specified`. Close and move any
   newly out-of-scope ticket to the map's boundary.
6. Recompute the discovery frontier. If it and `Not yet specified` are empty,
   record terminal evidence, set the map to `Status: resolved`, and close it.
   Read back every map/graph mutation, release the map claim, report the updated
   state, and stop. A later session resolves the next discovery ticket.

`/research` and `/prototype` return evidence only. Wayfinder owns tracker
claims, relationships, comments, closure, and map updates.

A prerequisite that needs external, production, manifest, canonical-doc, or
behavior-changing repo mutation stays unresolved. Record the required action
and hand it to a separately authorized workflow; Wayfinder never implements the
destination.

## Completion

Wayfinding ends when no unresolved decision blocks the destination and no
in-scope fog remains. Record terminal evidence, set the map to
`Status: resolved`, close its tracker object, and read it back. Report the
resolved map and recommend an explicit `/to-spec`; destination implementation
is always outside the map.
