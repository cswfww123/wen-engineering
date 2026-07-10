---
name: to-test-plan
description: Create traceable test plans and cases from specs or tickets.
disable-model-invocation: true
---

# To Test Plan

Turn a spec, ticket set, plan, or legacy PRD/issue set into a traceable test plan
and test-case design artifact.

This skill creates the tests to run later. It does not execute them, fill actual results, or report pass/fail.

The issue tracker and artifact location should come from `/setup-project-harness`.

See [TEMPLATES.md](TEMPLATES.md) for the test plan, test case, and surface reference templates.

## Process

### 1. Gather Sources

Read only what is needed:

- the spec, source ticket/issue, plan, approved `/to-tickets` output, or legacy PRD/issue set
- `CONTEXT.md`, or `CONTEXT-MAP.md` plus relevant context files
- `docs/agents/issue-tracker.md` and `docs/agents/domain.md` when present
- existing tests, API docs, fixtures, or similar feature plans that show local testing seams

If the correct test seam or risk coverage depends on hidden behavior, trace the relevant entrypoint before designing cases.

If the source has no explicit requirements or acceptance criteria, mark that as a gap and derive cases only from evidence.

### 2. Identify The Project Test Surface

Classify the feature by supported test surface:

- `Frontend`: pages, routes, components, browser state, forms, accessibility, responsive behavior, console/network evidence
- `Backend`: APIs, services, persistence, permissions, jobs, queues, cache, logs, migrations, performance
- `Full-stack`: UI action through API, persistence, async side effects, and user-visible result
- `CLI`: commands, flags, stdin/stdout, files, exit codes, config
- `Library`: public functions, contracts, types, errors, compatibility
- `Job`: schedulers, batch inputs, idempotency, retries, observability

Do not invent UI cases for backend-only work, DB assertions for frontend-only work, or E2E flows when the repo has no reachable surface. Record assumptions instead.

### 3. Map Coverage

Create a compact coverage matrix:

- every material requirement or acceptance criterion
- stable requirement IDs and ticket `Covers` references that can be reused by `/alignment-review` and `/qa-run`
- the behavior, contract, or risk it needs to prove
- one or more test case IDs that cover it
- the evidence type needed to judge pass/fail
- uncovered or blocked requirements

Do not count an enabling ticket's `Supports` field as requirement coverage.
Cover the referenced requirement through a behavior ticket or explicit source
acceptance boundary; verify the enabling ticket separately for compatibility.

Prefer the highest stable seam that exists in the repo. Use public behavior and documented contracts, not private implementation details.

### 4. Design Test Cases

For each vertical slice, write cases that cover:

- positive paths
- negative paths
- boundary and equivalence-class data
- permissions, tenant, role, or ownership rules
- error, timeout, retry, empty-state, and concurrency risks when relevant
- smoke and regression candidates
- performance or load checks only where the requirement or risk justifies them

Keep each case executable by a human or agent. Give concrete test data when possible, but avoid secrets and production-only data.

### 5. Separate Design From Execution

Do not include empty `Actual Result` or `Status` fields in the design artifact. Those belong to `/qa-run`.

For each case include:

- case ID, title, linked requirement or issue, and source reference
- scenario type, priority, applicable surface, verification level
- automation recommendation
- preconditions, test data, steps, expected results, evidence type, cleanup, and risk notes

### 6. Publish The Artifact

Use the configured tracker shape:

- local markdown tracker: write `TEST-PLAN.md` next to the spec/ticket set; legacy PRD/issue directories remain valid inputs
- GitHub/GitLab issue tracker: comment on the parent spec/ticket unless project docs specify a child issue
- other tracker: follow `docs/agents/issue-tracker.md`

If the repo does not define where test plans live, show the artifact draft and ask where to publish it.

After publishing, `/alignment-review` can review requirement coverage and test-case completeness; `/qa-run` executes the plan later. Use either in any order; this skill prescribes no sequence.

## Done Means

- every material requirement is covered, explicitly out of scope, or marked blocked
- test cases match the actual project test surface
- automation and manual QA responsibilities are separated
- `/qa-run` can execute the artifact without rereading the whole planning conversation
