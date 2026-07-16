# Fog, Scope, and Names

Progressive extract of the **Fog of war**, **Out of scope**, **Refer by name**,
and HITL rules in [SKILL.md](SKILL.md). **SKILL.md is canonical** (Matt base).
If this file and SKILL.md disagree, follow SKILL.md.

Load when fog vs ticket / scope / naming is unclear. Tracker field shapes:
[TEMPLATES.md](TEMPLATES.md).

## Plan the way, don't charge the destination

Wayfinding finds a **route**. Tickets resolve **decisions**. The map is done
when the way is clear — nothing left to decide before someone does the work.
The pull to "just build" is usually the signal to hand off. `task` is the only
type that *does* something, and only to **unblock a decision**, never to ship
the destination (unless Notes explicitly override).

## Refer by name

Every map and ticket has a **name** (title). In narration and Decisions-so-far,
refer by that name, never by a bare id/number/slug. Wrap a link around the name
when useful.

## Map is an index

| Section | Holds |
| --- | --- |
| Destination | What "done finding the way" looks like |
| Notes | Domain, skills to consult, standing preferences |
| Decisions so far | Closed tickets: named link + one-line gist |
| Not yet specified | In-scope fog not sharp enough to ticket |
| Out of scope | Beyond this destination; closed mis-scoped tickets |

Open tickets live in the **tracker query**, not the map body. A decision lives
in exactly one place — its ticket's resolution comment.

## Fog or ticket?

The test is whether you can **state the question precisely now** — not whether
you can answer it.

- **Ticket when** the question is already sharp — even if blocked
- **Not yet specified when** you cannot phrase it that sharply — do not pre-slice
- **Out of scope when** past the destination — close mis-scoped tickets; never put
  them in Decisions so far

## HITL means human

For grilling and prototype tickets, the agent never stands in for the human. A
grilling agent that answers its own *decisions* has broken the contract (facts
may be looked up). Research tickets prefer a `/research` subagent.
