---
name: wayfinder
description: Clear foggy multi-session coding work into a discovery map; resolve one ticket until an honest spec is writable.
disable-model-invocation: true
---

# Wayfinder

Find a route to a named coding destination when the route is too foggy for an
honest `/to-spec` and too large for one session. Map indexes decisions;
discovery tickets own detail. **Find the way** — do not ship the destination.

**LIGHT L4.** Prefer `/grilling` for same-session work. Routing /
anti-invention: `docs/lifecycle.md`. Requires Wayfinder ops from
`/setup-project-harness` — read `docs/agents/issue-tracker.md` first.

Mode: no map → **Chart**; map id/path/URL → **Resolve**. At most **one**
discovery ticket per session. Charting never also resolves.

Load [FOG.md](FOG.md) when fog vs ticket / scope / naming is unclear.
Load [TEMPLATES.md](TEMPLATES.md) when charting or graduating tickets.

## Operating Rules

- **Plan, don't implement.** Urge to "just build" → hand off, not expand.
- **Destination fixes scope.** Name it first (honest spec, locked architecture/
  data decision, or migration readiness) — not a merged feature.
- **Fog or ticket?** Precise question → ticket. Dim → `Not yet specified`. Do
  not pre-slice fog ([FOG.md](FOG.md)).
- **Map is an index.** Open tickets via tracker query. `Decisions so far` =
  named links + one-line gists (title/name, never bare `#42`).
- **One answer, one place.** Resolution comment holds detail; map never restates.
- **HITL means human.** Grilling/prototype never answer for the user.
- **Never invent** Expected / market / user value; **never implement** the
  destination (disposable `/prototype` only when authorized).

## Disciplines

| Discipline | Mode | Use when |
| --- | --- | --- |
| `research` | AFK | Primary sources outside the tree |
| `prototype` | HITL | Disposable artifact for reaction |
| `grilling` | HITL | User-owned product/scope/trade-off (default) |
| `task` | AFK or HITL | Prerequisite that unblocks a **decision**, not delivery |

## Chart

1. Name destination with user. Still fuzzy → short `/grilling` until
   destination and out-of-scope are stable (domain habit: AGENTS / domain.md).
2. Breadth-first across coding surface (boundary, seams, data/auth, contracts,
   migration, testability, failures). Precise → candidate tickets; imprecise →
   `Not yet specified`; beyond destination → `Out of scope`.
3. No multi-session fog left → **stop without tracker state**; report
   `/to-spec` or `/implement`.
4. Publish one non-runnable map (destination, notes, fog, out-of-scope).
5. Create only sharp questions as child tickets, each with `Resolution Signal`.
   Identities first, then blocking edges. Smallest set that unblocks honest spec.
6. Query discovery frontier; stop.

## Resolve

1. Load map body; **claim map**; re-read ownership (serial if adapter cannot
   distinguish workers).
2. Query discovery frontier. Empty → terminal closeout if no fog, else release
   claim, report fog, stop. Else take named/first ticket; **claim it**; re-read.
3. Resolve exactly that ticket:
   - `research` / AFK → `/research`
   - `prototype` / HITL → `/prototype` + user reaction
   - `grilling` / HITL → one evidence-backed question at a time (repo first)
   - `task` → only ticket-authorized inspection/disposable setup; never destination delivery
4. Gate on `Resolution Signal`. Insufficient → partial evidence, keep open,
   release claims, report blocker, stop. Sufficient → one resolution comment,
   close ticket, append one named pointer to `Decisions so far`.
5. Graduate precise fog into tickets; remove from `Not yet specified`. Close
   mis-scoped → `Out of scope` with reason (never into Decisions). Unclear →
   [FOG.md](FOG.md).
6. Recompute frontier. Frontier + fog empty → terminal evidence, `Status:
   resolved`, close map, read back mutations, release claim, stop.

`/research` and `/prototype` return evidence only. Wayfinder owns claims,
relationships, comments, closure, and map updates.

## Completion

No unresolved decision blocks the destination; no in-scope fog remains. Read
back resolved map. Recommend `/to-spec` (or `/implement` if one-context).
Destination implementation is always outside the map.
