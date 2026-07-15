# Alignment Review Checklist

Use this only when the core workflow needs sharper review prompts.

## Requirement Fidelity

- Does the artifact answer the user's actual request, not a nearby generic version?
- Are all explicit constraints, exclusions, actors, states, and edge cases represented?
- Are ambiguous points marked as assumptions or user questions instead of hidden decisions?
- Does the solution preserve the user's preferred level of backend, frontend, product, or operational scope?
- Are non-functional constraints such as security, observability, compatibility, accessibility, performance, retention, or migration called out when the source or repo risk requires them?

## Repo Evidence

- Which existing modules, routes, jobs, tables, contracts, tests, or runtime surfaces prove the current shape?
- Does the plan reuse established ownership boundaries and vocabulary?
- Are new abstractions justified by repeated complexity or existing local patterns?
- Are claims about behavior backed by code, docs, tracker comments, runtime evidence, or user-provided facts?

## Spec Review

- Problem statement is from the user's perspective.
- Solution matches the agreed behavior and does not smuggle in extra product scope.
- Requirements and Main Flows cover the complete behavior surface.
- Implementation decisions state module, contract, schema, API, and interaction choices without stale file-path detail.
- Rollout, config, migration, monitoring, manual operation, and rollback decisions are explicit when they affect release safety.
- Testing decisions identify the highest useful seams and prior art.
- Out-of-scope items prevent predictable drift.

## Implementation Ticket Review

- Each ticket has `Kind: implementation-ticket` and an explicit AFK/HITL mode.
- Each behavior ticket delivers a narrow complete path through the system in one fresh context; only the named expand-contract exception may be mechanical.
- Each ticket's `Covers` field links to stable spec requirements or a legacy source criterion.
- `Covers: none` appears only on an expand-contract enabling ticket with `Supports`, a stable `Decision` source, and behavior-preservation verification; `Supports` is not counted as requirement coverage.
- Each ticket is demoable or verifiable alone through its named verification seam.
- Slices are not horizontal tasks such as only schema, only API, only UI, or only tests.
- Small prefactoring is folded into the first vertical slice; only the named expand-contract exception becomes a separate enabling ticket.
- Blocked-by relationships are minimal, acyclic, accurate, and publishable.
- The reported implementation frontier contains only open, unblocked, unclaimed AFK tickets.
- The reported human frontier contains only open, unblocked, unclaimed HITL tickets with a named judgment or manual gate.
- Acceptance criteria are observable and do not depend on reading the agent's mind.

## Verdict Calibration

- Use `Pass` only when remaining risk is ordinary implementation risk.
- Use `Small Fix` when specific edits can repair the artifact without changing its shape.
- Use `Rework` when the artifact omits key scope, slices horizontally, or rests on a wrong architecture assumption.
- Use `Ask User` only when evidence cannot decide a product or taste question.
