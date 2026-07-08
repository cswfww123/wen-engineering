---
name: to-prd
description: Turn settled discussion into a PRD and publish it to the issue tracker.
disable-model-invocation: true
---

# To PRD

Turn settled context and codebase understanding into a PRD. Do not interview the user; synthesize what is already known.

The issue tracker and triage label vocabulary should come from `/setup-project-harness`.

## Readiness Gate

Before writing or publishing the PRD, confirm the source is settled enough:

- problem, outcome, and target user are clear
- scope and out of scope are explicit
- core behavior and main flows are specified
- material edge cases or error paths are covered or explicitly deferred
- dependencies, integrations, migrations, or permissions are named when relevant
- remaining unknowns are explicitly non-blocking assumptions or follow-up questions

If any item is missing, contradictory, or blocked on a user-owned decision, stop. Report the gaps and recommend `/grill-with-docs` or targeted repo evidence gathering instead of turning guesses into PRD decisions.

## Process

1. Synthesize from the current discussion, user-provided docs, existing PRDs, issues, or other durable repo artifacts.
2. Explore the repo to understand the current state if needed. Use glossary vocabulary and respect relevant ADRs.
3. If current-state claims depend on actual code behavior, trace the relevant entrypoint before recording modules, interfaces, interactions, permissions, migrations, or test seams.
4. Run the readiness gate above.
5. Sketch the test seams for the feature. Prefer existing seams, use the highest seam possible, and keep the number of seams as low as practical.
6. Ask about test seams only when the choice is user-owned or repo evidence is insufficient. Otherwise record the chosen seams and assumptions in the PRD.
7. Write the PRD using the template below.
8. Publish it to the project issue tracker and apply the `ready-for-agent` triage label.

## PRD Template

```md
## Problem Statement

The problem the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

1. As an <actor>, I want a <feature>, so that <benefit>.

Make this list extensive enough to cover the feature.

## Implementation Decisions

- Modules or interfaces that will be built or modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do not include specific file paths or code snippets because they go stale quickly.

Exception: if a prototype produced a concise snippet that encodes a decision more precisely than prose can, inline only the decision-rich part and label it as prototype-derived.

## Testing Decisions

- What makes a good test for this feature
- Which modules or seams will be tested
- Prior art for similar tests in the codebase

## Out Of Scope

What is explicitly outside this PRD.

## Further Notes

Any further notes about the feature.
```

## Related Skills

- `/alignment-review` — check the PRD preserves user intent and fits the codebase
- `/to-issues` — break the PRD into vertical-slice issues
- `/to-test-plan` — derive traceable test cases from the PRD

Use any, in any order; this skill prescribes no sequence.
