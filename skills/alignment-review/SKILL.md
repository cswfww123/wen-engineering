---
name: alignment-review
description: Reviews specs, tickets, and test plans for intent, coverage, evidence, and execution fit.
disable-model-invocation: true
---

# Alignment Review

Review generated planning artifacts before implementation or QA so the next agent does not drift from user intent, requirement coverage, repo evidence, or executable scope.

Use this after `/to-spec`, `/to-tickets`, or `/to-test-plan` when intent,
coverage, slicing, or repo fit is risky. It may precede `/to-tickets`,
`/implement`, TDD, or `/qa-run` according to the artifact under review.

See [CHECKLIST.md](CHECKLIST.md) for detailed review questions.

## Workflow

### 1. Gather The Handoff Packet

Read only the artifacts needed for the review:

- original user request, source issue, legacy PRD, or grill/Wayfinder output
- generated spec, implementation tickets, test plan, rollout plan, or acceptance checklist
- relevant repo evidence, glossary, ADRs, and harness rules
- existing related tests, contracts, or implementation seams
- code review or QA results when reviewing a revised test plan after implementation

If the artifact's fit depends on actual code behavior, trace the relevant entrypoint before judging module ownership, integration seams, data flow, permissions, or async side effects.

If the source material is missing, say what cannot be verified and review only the claims that have evidence.

### 2. Zoom Out

Map the domain objects, modules, callers, data flow, permissions, async boundaries, notifications, and integration seams that matter for the artifact.

Use the project's domain language. Keep this map short enough to support review judgment, not replace the review.

### 3. Check Alignment

Compare the artifact against the source material and repo map:

- does it preserve the user's actual problem, constraints, and explicit out-of-scope boundaries?
- does every material requirement have a stable spec ID or legacy source reference and appear in a ticket `Covers`, test case, or explicit acceptance criterion?
- does every material risk or regression concern appear in a test case, acceptance criterion, or explicit out-of-scope/blocker note?
- is there a stable traceability chain from source requirement to ticket or test case, and later to QA evidence?
- did the agent invent certainty where the source only supported an assumption?
- does the technical direction fit current module ownership and integration seams?
- are verification points concrete enough for the next agent to prove completion?

### 4. Check Execution Shape

For implementation tickets, confirm behavior work is a one-context vertical
tracer bullet through required layers, not a horizontal task by database,
backend, frontend, or tests. Permit a mechanical ticket only under the named
expand-contract branch: `Covers: none`, stable `Supports` and `Decision`, plus
compatibility and behavior-preservation evidence. Confirm `Kind`, `Mode`,
parent, trace fields, blockers, verification seam, initial
implementation/human frontiers, and an acyclic graph.

For test plans, confirm each case ties to user-visible behavior or a documented contract, not only implementation details. Check the coverage matrix requirement-by-requirement: positive, negative, boundary, permission, error, async, migration, performance, and regression coverage should be present when the source or repo risk calls for it.

When the source or repo risk calls for non-functional coverage, check security, observability, compatibility, data retention/export, accessibility, performance, migration, and operational acceptance. Do not invent these as universal requirements.

If a material requirement has no runnable case, explicit blocker, or out-of-scope decision, the verdict cannot be `Pass`. If the test plan is correct but execution is still unknown, hand that completion judgment to `/qa-run`.

For any generated plan, confirm dependencies, blockers, rollout order, config or manual steps, monitoring/alert checks, rollback boundaries, and user-owned decisions are explicit when they affect execution.

### 5. Report A Verdict

Lead with one verdict:

- `Pass` - ready for the next declared lifecycle step; name that step
- `Small Fix` - mostly aligned; list required edits
- `Rework` - missing or misleading enough to regenerate or re-slice
- `Ask User` - blocked by a real product decision

For each finding, use this format:

```markdown
### <verdict area>: <one-line summary>

- **Artifact section**: <which part of the spec/ticket/test plan>
- **Source evidence**: <user request, spec line, or repo evidence that contradicts>
- **Gap**: <what is missing, misleading, or invented>
- **Smallest correction**: <how to fix it>
```

Do not rewrite the whole artifact unless the user asks. Report findings with evidence and corrections, then stop.
