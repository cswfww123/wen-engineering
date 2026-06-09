---
name: qa-run
description: Runs or retests QA cases and records results. Use after code-review, bug fixes, smoke, regression, or QA.
---

# QA Run

Execute or retest QA cases against finished code, record evidence, and file durable bug issues for confirmed defects.

This skill is report-first. Do not fix implementation code unless the user explicitly asks for a fix loop.

The issue tracker and artifact location should come from `/setup-project-harness`.

See [TEMPLATES.md](TEMPLATES.md) for QA report, execution result, retest result, and bug issue templates.

## Process

### 1. Gather The QA Packet

Read only what is needed:

- the test plan from `/to-test-plan`, or bug issues with `Fix Verification` steps
- the PRD, parent issue, issue set, or acceptance criteria
- code review results and changed-file diff when available
- `CONTEXT.md`, `docs/agents/issue-tracker.md`, and relevant `.agents/rules/**`
- project commands for tests, builds, dev servers, smoke checks, and single-test runs

If the user asks to verify fixed bugs, enter retest mode. If no test plan exists, create a minimal temporary checklist from the PRD/issues and report that a real `/to-test-plan` artifact is missing.

### 2. Confirm Scope And Surface

Use the test plan's project test surface. If it is missing, classify the surface as `Frontend`, `Backend`, `Full-stack`, `CLI`, `Library`, or `Job` from repo evidence.

Do not run impossible checks:

- no frontend surface means no browser/UI QA
- no backend surface means no DB/API assertions
- no runnable app means no E2E claim
- no safe environment means destructive cases are `Blocked`

### 3. Choose The Mode

Choose one mode:

- `Full QA`: validate a completed feature against a test plan.
- `Retest Fixed Bugs`: verify fixed bug issues by reading the original failing case, linked QA report, fix notes, `Fix Verification`, and current diff.

Do not use retest mode for product acceptance questions that were never specified. Mark those as human-owned decisions.

### 4. Prepare The Run

Record:

- branch, commit, environment, base URL or command target
- test data and credentials source, redacting secrets
- build/test commands that were run or intentionally skipped
- known environment limitations

Run smoke checks first. Stop and report if the environment is not viable enough to test the feature.

### 5. Execute Cases

Run cases in priority order:

1. P0 smoke and main path
2. P0/P1 negative and permission paths
3. boundary, exception, and regression cases
4. performance checks when the plan requires them
5. P2 manual or cosmetic checks

For each case, record status as `Pass`, `Fail`, `Blocked`, or `Not Run` with concrete evidence.

In retest mode, rerun the original failing case first, then related regression scope. Record each bug as `Verified`, `Reopened`, or `Blocked`. Close or mark the bug verified only when project tracker rules allow it.

### 6. Triage Failures

For each failed or blocked case, classify the cause:

- confirmed product or code defect: create or link a bug issue
- unclear requirement: mark `Blocked` and ask the smallest product question
- environment or data problem: keep it in the QA report unless it needs engineering work
- test case problem: note the correction needed; do not hide the failed run

Bug issues must describe user-visible behavior or documented contract breakage, not private implementation details.

### 7. Report Quality

Write a QA report with:

- coverage summary by priority and scenario type
- pass/fail/blocked/not-run counts
- bugs filed or linked
- smoke and regression results
- performance or observability notes when tested
- release recommendation: `Ship`, `Ship With Known Risk`, `Do Not Ship`, or `Blocked`

For retest mode, include bugs verified, reopened, and blocked, plus evidence and remaining release risk.

### 8. Handoff

If bugs were filed or reopened, point the next agent to the bug issue, original test case, `/do-issues`, and `/tdd`.

If the user explicitly asks QA to fix issues now, switch from report-first QA into the normal implementation flow: one bug issue at a time, with a regression test at the correct seam.

## Done Means

- every runnable planned case has a recorded result or blocker
- every confirmed defect has a linked bug issue
- every retested fixed bug is `Verified`, `Reopened`, or `Blocked`
- evidence is sufficient for a developer to reproduce failures
- release risk is explicit and tied to test results
