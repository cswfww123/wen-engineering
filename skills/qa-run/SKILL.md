---
name: qa-run
description: Execute QA cases, record evidence, judge completion, and file confirmed defects.
disable-model-invocation: true
---

# QA Run

Execute or retest QA cases against finished code, record evidence, judge requirement completion, and file durable defect artifacts for confirmed defects.

This skill is report-first. Do not fix implementation code unless the user explicitly asks for a fix loop.

The issue tracker and artifact location should come from `/setup-project-harness`.

See [TEMPLATES.md](TEMPLATES.md) for QA report, execution result, retest result, and bug issue templates.

## Process

### 1. Gather The QA Packet

Read only what is needed:

- the test plan from `/to-test-plan`, or bug issues with `Fix Verification` steps
- the spec, implementation tickets, legacy PRD/issue set, or acceptance criteria
- `/alignment-review` results for the spec, ticket set, or test plan when available
- code review results and changed-file diff when available
- `CONTEXT.md`, `docs/agents/issue-tracker.md`, and relevant `.agents/rules/**`
- project commands for tests, builds, dev servers, smoke checks, and single-test runs

If the user asks to verify fixed bugs, enter retest mode. If no test plan exists,
create a minimal temporary checklist from the spec/tickets or legacy PRD/issues
and report that a real `/to-test-plan` artifact is missing.

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

### 6. Assess Completion

Use the accepted spec/tickets/test plan as the completion source. Follow stable
requirement IDs through ticket `Covers` fields into cases and evidence; for
legacy inputs, follow the test plan's stable source reference or acceptance
criterion instead. Do not invent new requirements during QA; if execution
reveals a missing requirement or case, mark it as a plan gap and recommend
`/alignment-review`.

When the surface is visual and a PM UI contract / delivery prototype pin is in
the handoff package (`docs/handoff-package.md`), also run a **fidelity pass**:
field set/labels, requiredness, RULE show/hide paths, and listed UI states
against the pin. Behavior-green alone is not `Complete` for UI scope.

Classify the feature:

- `Complete`: every material requirement has passing evidence, UI fidelity
  passes when applicable, and no required P0/P1 case is failed, blocked, or not run.
- `Incomplete`: at least one material requirement failed or lacks passing evidence because of product/code behavior, or UI fidelity fails against the contract/pin.
- `Blocked`: completion cannot be judged because the environment, data, permissions, or dependency access is unavailable.
- `Not Assessable`: the source/test plan is missing or misaligned enough that QA cannot fairly judge completion.

### 7. Triage Failures

For each failed or blocked case, classify the cause:

- confirmed product or code defect: create or link a bug issue
- UI **implementation** drift vs pin/contract: defect (fix in eng)
- UI **contract** gap (missing/wrong FLD/RULE/pin vs real intent): do not invent
  Expected; mark blocked/incomplete and recommend PM `/pm-intake` or `to-prd` update
- unclear requirement: mark `Blocked` and ask the smallest product question
- environment or data problem: keep it in the QA report unless it needs engineering work
- test case problem: note the correction needed; do not hide the failed run

When a failure looks like product or code behavior and the responsible path is not obvious from the test evidence, trace the failing entrypoint before filing or reopening a bug.

Publish a confirmed defect directly as `Kind: implementation-ticket` only when
the fix, regression test, verification, and review fit one fresh context. Give
it subtype `bug`, a stable source/test `Covers` reference, parent, blockers,
verification seam, and the configured readiness role. When a source spec
exists, make it the parent and preserve the failing ticket/test as `Origin`, so
the bug blocks spec closeout. Use `Mode: AFK` only when no live judgment remains;
use `HITL` for a named user-owned gate.

If the defect needs more diagnosis, slicing, or more than one context, publish
`Kind: bug-report`, `Runnable: no`, `Status: needs-triage`, and no readiness
label. Keep the same parent, origin, reproduction, and evidence. It remains a
source for `/diagnosing-bugs` and explicit conversion; it never enters a
frontier as intake. Use `/implement` when one context now fits. When an accepted
parent spec already covers the defect, use `/to-tickets` to create replacements
under that parent. Use `/to-spec` followed by `/to-tickets` only for genuinely
new or out-of-scope work, and record that scope disposition on the report.

Describe user-visible behavior or a documented contract breakage, not private
implementation details.

### 8. Report Quality

Write a QA report with:

- coverage summary by priority and scenario type
- completion verdict: `Complete`, `Incomplete`, `Blocked`, or `Not Assessable`
- requirement-by-requirement completion summary
- pass/fail/blocked/not-run counts
- bugs filed or linked
- smoke and regression results
- performance or observability notes when tested
- release recommendation: `Ship`, `Ship With Known Risk`, `Do Not Ship`, or `Blocked`

For retest mode, include bugs verified, reopened, and blocked, plus evidence and remaining release risk.

### 9. Publish Evidence And Close Out

Publish the QA report through `docs/agents/issue-tracker.md` and read it back:

- local Markdown: write a new `qa-reports/<run-id>.md` beside the source
  lifecycle artifacts and link it from the source; never overwrite an earlier run
- GitHub/GitLab: attach the report to the source spec, ticket, bug, or test
  artifact through the configured comment/note operation and link any larger
  repo artifact
- other tracker: use its configured QA-evidence operation

Return the canonical path or URL. When a source spec exists, only a `Complete`
verdict with every in-scope implementation/human ticket resolved and every
child bug report resolved, converted, or explicitly moved out of scope with
evidence may mark it `Status: delivered`. A converted in-scope report remains a
closeout blocker until all replacement tickets resolve; read the whole child
set through the adapter before recording requirement-level evidence and closing
the spec.
For lifecycles where QA is optional, leave spec closeout to the explicit human
operation in the adapter. Never close the parent for `Incomplete`, `Blocked`,
or `Not Assessable`.

After publication, update every bug filed or reopened during this run with the
canonical QA-report path/URL and read it back. The report links the bugs; the
bugs must link the report.

### 10. Handoff

If bugs were filed or reopened, the bug issue and original test case are the anchors for whoever fixes them. `/implement` and `/tdd` are common fix skills; this skill does not require them.

Finish the QA report before any fix loop. If the same user request explicitly
invoked `/implement` and authorized both QA and fixes, hand one bug ticket at a
time to that workflow with its failing case and regression seam. Otherwise
recommend a separate, explicit `/implement` run; do not silently start another
user-invoked workflow.

## Done Means

- every runnable planned case has a recorded result or blocker
- every material requirement has a completion status or the whole run is marked `Not Assessable`
- every confirmed defect has a linked bug issue
- every retested fixed bug is `Verified`, `Reopened`, or `Blocked`
- evidence is sufficient for a developer to reproduce failures
- release risk is explicit and tied to test results
- the QA report has a read-back canonical path or URL
- every filed or reopened bug links that canonical QA report
- a source spec, when present, is correctly delivered/closed or explicitly left open
- no open in-scope bug report or unresolved replacement was skipped by closeout
