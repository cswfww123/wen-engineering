# QA Run Templates

Use these templates when `/qa-run` needs concrete artifact shapes.

## QA Report Template

```md
# QA Report: <feature name>

## Sources

- Test plan: <link or path>
- PRD / parent issue: <link or path>
- Code review: <link or path, optional>
- Branch / commit: <branch, sha>

## Environment

- Surface: Frontend / Backend / Full-stack / CLI / Library / Job
- Target: <base URL, command, service, or environment>
- Data: <fixture, seeded account, mocked service, or data note>
- Limitations: <blocked credentials, unavailable service, unsafe destructive case>

## Summary

| Status | Count |
| --- | ---: |
| Pass | 0 |
| Fail | 0 |
| Blocked | 0 |
| Not Run | 0 |

## Coverage

| Priority / Type | Planned | Run | Passed | Failed | Blocked |
| --- | ---: | ---: | ---: | ---: | ---: |
| P0 | 0 | 0 | 0 | 0 | 0 |
| Positive | 0 | 0 | 0 | 0 | 0 |
| Negative | 0 | 0 | 0 | 0 | 0 |
| Boundary | 0 | 0 | 0 | 0 | 0 |
| Permission | 0 | 0 | 0 | 0 | 0 |
| Regression | 0 | 0 | 0 | 0 | 0 |

## Results

<Use the execution result template for each case, or a table for simple pass-only runs.>

## Bugs

| Bug | Test Case | Severity | Status |
| --- | --- | --- | --- |
| <issue link> | TC-XXX-001 | P0 / P1 / P2 / P3 | Open / Existing / Deferred / Verified / Reopened |

## Smoke Result

Pass / Fail / Blocked, with evidence.

## Regression Result

Pass / Fail / Blocked, with affected areas.

## Retest Result

| Bug | Original Case | Result | Evidence |
| --- | --- | --- | --- |
| <issue link> | TC-XXX-001 | Verified / Reopened / Blocked | <link or excerpt> |

## Performance And Observability

- <response time, query behavior, job duration, logs, metrics, or "Not tested">

## Release Recommendation

Ship / Ship With Known Risk / Do Not Ship / Blocked

Reason: <short evidence-based reason>
```

## Execution Result Template

```md
### TC-<FEATURE>-001: <title>

- Status: Pass / Fail / Blocked / Not Run
- Executed at: <datetime>
- Environment: <local/staging/prod-like, branch, commit, config>
- Actual result: <observed behavior>
- Evidence:
  - Screenshot / log / API response / DB state / command output: <link or excerpt>
- Bug: <issue link or None>
- Notes: <blocked reason, data issue, or retest note>
```

## Retest Result Template

```md
### <Bug issue>: <title>

- Result: Verified / Reopened / Blocked
- Retested at: <datetime>
- Environment: <local/staging/prod-like, branch, commit, config>
- Original failing case: <TC id or repro steps>
- Fix verification:
  - [ ] Original failing case no longer reproduces
  - [ ] Related regression scope passes
  - [ ] Regression automation added or explicitly deferred
- Actual result: <observed behavior after the fix>
- Evidence:
  - Screenshot / log / API response / DB state / command output: <link or excerpt>
- Issue update: <closed, commented, reopened, or left blocked>
- Notes: <remaining risk, product-owned question, or blocker>
```

## Bug Issue Template

```md
## What Happened

<Actual behavior observed during QA.>

## Expected

<Expected behavior from the test case, PRD, issue, or documented contract.>

## Steps To Reproduce

1. <step>
2. <step>
3. <step>

## Evidence

- Test case: <TC id>
- QA report: <link or path>
- Screenshot / log / API response / DB state: <link or excerpt>

## Environment

- Branch / commit: <branch, sha>
- Target: <URL, service, command, or environment>
- Data / config: <safe details only>

## Severity

P0 / P1 / P2 / P3

## Fix Verification

- [ ] Original failing test case passes
- [ ] Related regression scope passes
- [ ] Regression automation added or explicitly deferred
```

## Severity Guide

- `P0`: blocks release, data loss, security exposure, payment/auth failure, or core path unusable.
- `P1`: important path broken with no reasonable workaround.
- `P2`: secondary path broken, workaround exists, or limited user impact.
- `P3`: cosmetic, copy, minor UX, or low-risk observability issue.
