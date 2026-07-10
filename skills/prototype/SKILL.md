---
name: prototype
description: Prototype logic, state, or UI for an explicit question or active Wayfinder ticket.
---

# Prototype

Build one bounded, throwaway evidence artifact that answers a concrete question.
Run only for an explicit matching request or an active, authorized Wayfinder
ticket.

## Bound The Question

State the question, the reaction or observation that will answer it, and the
production surface that must remain unchanged. A Wayfinder caller retains all
tracker claims, relationships, comments, and closure.

## Pick A Branch

Choose the branch from the question being tested:

- Logic/state question: load [LOGIC.md](LOGIC.md).
- UI/product surface question: load [UI.md](UI.md).

If the branch is ambiguous, infer from repo evidence. Backend services,
state machines, data shapes, pricing rules, quotas, and permissions usually use
the logic branch. Pages, components, dashboards, forms, and workflows usually
use the UI branch. State an evidence-backed assumption when the user is not
available.

## Shared Rules

- Put the artifact in the repo's prototype convention or
  `.scratch/<effort-slug>/prototype/<question-slug>/` fallback.
- Mark its path and README as disposable, and reuse installed runtimes and
  dependencies without changing manifests.
- Keep production persistence and existing production behavior unchanged.
  When persistence is the question, confine it to a disposable local file or
  scratch database inside the artifact.
- Build only enough interaction to answer the question. Provide one exact
  command or URL and record the observation in the artifact's `RESULTS.md`.
- Leave tracker state, dependency relationships, canonical specs/ADRs, and
  production promotion to the user-invoked caller.

## Return

Report:

- `Artifact`: prototype directory and `RESULTS.md`
- `Try it`: exact command or URL
- `Answer`: what the prototype proved and what remains uncertain
- `Disposition`: `keep`, `delete`, or `promote`, with a reason

`Promote` recommends extracting the validated decision later; it does not
authorize production edits, tracker mutation, or canonical publication.
