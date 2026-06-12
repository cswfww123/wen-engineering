---
name: to-issues
description: Breaks a PRD into vertical-slice issues. Use when user asks for to-issues or AFK implementation issues.
disable-model-invocation: true
---

# To Issues

Break a plan, spec, or PRD into independently grabbable tracer-bullet issues.

The issue tracker and triage label vocabulary should come from `/setup-project-harness`.

## Process

### 1. Gather Context

Work from the current conversation. If the user passes an issue number, URL, or path, fetch it from the configured issue tracker and read its body and comments.

### 2. Explore The Codebase

If you have not already explored the codebase, do so enough to understand the current shape. Use the project's domain glossary vocabulary and respect relevant ADRs.

When the vertical slice boundaries depend on existing behavior, load `/deep-code-trace` for the relevant entrypoint before deciding blockers, integration layers, prefactoring, or test seams.

Look for useful prefactoring opportunities. Make the change easy, then make the easy change.

### 3. Draft Vertical Slices

Break the plan into tracer-bullet issues. Each issue is a thin vertical slice through all required integration layers, not a horizontal slice of one layer.

Each slice should:

- deliver a narrow but complete path through the system
- be demoable or verifiable on its own
- put any required prefactoring before dependent behavior

### 4. Quiz The User

Present the proposed breakdown as a numbered list. For each slice, show:

- title
- blocked-by relationships
- user stories covered, if the source material has them

Ask whether the granularity feels right, dependencies are correct, and any slices should merge or split.

Iterate until the user approves the breakdown.

### 5. Publish Issues

Publish each approved slice to the configured issue tracker. Publish blockers first so later issues can reference real identifiers.

Use the correct `ready-for-agent` triage label unless instructed otherwise. Do not close or modify any parent issue.

## Issue Template

```md
## Parent

<Reference to the parent issue, if the source was an existing issue. Omit otherwise.>

## What To Build

<Concise end-to-end behavior for this vertical slice. Avoid layer-by-layer implementation notes.>

Avoid specific file paths or code snippets because they go stale quickly.

Exception: if a prototype produced a concise snippet that encodes a decision more precisely than prose can, inline only the decision-rich part and label it as prototype-derived.

## Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked By

- <Blocking ticket reference>

Or: None - can start immediately
```

## Recommended Next Step

After issues are published:

1. Run `/alignment-review` to check that issue slices match the PRD and are truly vertical
2. Run `/to-test-plan` to define test cases while requirements are fresh
3. Then run `/do-issues` to start implementation
