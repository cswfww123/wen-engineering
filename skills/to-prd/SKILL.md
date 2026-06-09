---
name: to-prd
description: Turns discussion into a PRD and publishes it to the issue tracker. Use when user asks for to-prd or PRD synthesis.
disable-model-invocation: true
---

# To PRD

Turn settled context and codebase understanding into a PRD. Do not interview the user; synthesize what is already known.

The issue tracker and triage label vocabulary should come from `/setup-project-harness`.

## Process

1. If this came from a large grill, read `docs/grilling/<slug>/PRD-SOURCE.md`. If grill topic docs exist but `PRD-SOURCE.md` is missing, run `/finish-grill` first.
2. Explore the repo to understand the current state if needed. Use glossary vocabulary and respect relevant ADRs.
3. Sketch the test seams for the feature. Prefer existing seams, use the highest seam possible, and keep the number of seams as low as practical.
4. Check with the user that those seams match expectations.
5. Write the PRD using the template below.
6. Publish it to the project issue tracker and apply the `ready-for-agent` triage label.

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

## Recommended Next Step

After the PRD is published:

1. Run `/alignment-review` to check that the PRD preserves user intent and fits the codebase
2. Then run `/to-issues` to break the PRD into vertical-slice implementation issues
