---
name: prototype
description: Bounded throwaway logic/state or UI evidence for an explicit question or active Wayfinder ticket.
---

# Prototype

One disposable artifact that answers one concrete question. Only for an explicit request or active authorized Wayfinder ticket. Caller keeps tracker claims, relationships, comments, and closure.

## Bound

State the question, the observation that answers it, and the production surface that must stay unchanged.

## Branch

- Logic/state → [LOGIC.md](LOGIC.md)
- UI/product surface → [UI.md](UI.md)

If ambiguous: services, state machines, data shapes, pricing, quotas, permissions → logic; pages, components, dashboards, forms, workflows → UI. State the assumption when the user is AFK.

## Shared Rules

- Path: project prototype convention or `.scratch/<effort-slug>/prototype/<question-slug>/`
- Mark path + README disposable; reuse installed runtimes — no manifest changes
- Production persistence and behavior unchanged; if persistence is the question, confine to disposable local file/DB inside the artifact
- Only enough interaction to answer; one exact command or URL; record observation in `RESULTS.md`
- No tracker, dependency, canonical spec/ADR, or production promotion from this skill

## Return

- `Artifact`: directory + `RESULTS.md`
- `Try it`: exact command or URL
- `Answer`: proved vs still uncertain
- `Disposition`: `keep` | `delete` | `promote` (+ reason)

`Promote` recommends later extraction; it does not authorize production edits, tracker mutation, or canonical publication.
