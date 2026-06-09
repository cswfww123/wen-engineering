---
name: alignment-review
description: Reviews agent handoff artifacts for intent, evidence, and execution fit. Use when checking PRDs, issues, or test plans.
disable-model-invocation: true
---

# Alignment Review

Review generated planning artifacts before implementation so the next agent does not drift from user intent, repo evidence, or executable scope.

Use this after skills such as `/to-prd`, `/to-issues`, or future test-plan generators, and before `/do-issues`, TDD, or implementation work.

See [CHECKLIST.md](CHECKLIST.md) for detailed review questions.

## Workflow

### 1. Gather The Handoff Packet

Read only the artifacts needed for the review:

- original user request, source issue, PRD source, or grill output
- generated PRD, issue slices, test plan, rollout plan, or acceptance checklist
- relevant repo evidence, glossary, ADRs, and harness rules
- existing related tests, contracts, or implementation seams

If the source material is missing, say what cannot be verified and review only the claims that have evidence.

### 2. Zoom Out

Map the domain objects, modules, callers, data flow, permissions, async boundaries, notifications, and integration seams that matter for the artifact.

Use the project's domain language. Keep this map short enough to support review judgment, not replace the review.

### 3. Check Alignment

Compare the artifact against the source material and repo map:

- does it preserve the user's actual problem, constraints, and explicit out-of-scope boundaries?
- does every material requirement appear in a PRD section, issue slice, test case, or acceptance criterion?
- did the agent invent certainty where the source only supported an assumption?
- does the technical direction fit current module ownership and integration seams?
- are verification points concrete enough for the next agent to prove completion?

### 4. Check Execution Shape

For issue slices, confirm they are vertical tracer bullets through required layers, not horizontal tasks by database, backend, frontend, or tests.

For test plans, confirm each case ties to user-visible behavior or a documented contract, not only implementation details.

For any generated plan, confirm dependencies, blockers, rollback boundaries, and user-owned decisions are explicit.

### 5. Report A Verdict

Lead with one verdict:

- `Pass` - ready for implementation
- `Small Fix` - mostly aligned; list required edits
- `Rework` - missing or misleading enough to regenerate or re-slice
- `Ask User` - blocked by a real product decision

For each finding, use this format:

```markdown
### <verdict area>: <one-line summary>

- **Artifact section**: <which part of the PRD/issue/test plan>
- **Source evidence**: <user request, spec line, or repo evidence that contradicts>
- **Gap**: <what is missing, misleading, or invented>
- **Smallest correction**: <how to fix it>
```

Do not rewrite the whole artifact unless the user asks. Report findings with evidence and corrections, then stop.
