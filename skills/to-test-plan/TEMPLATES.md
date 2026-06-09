# To Test Plan Templates

Use these templates when `/to-test-plan` needs concrete artifact shapes.

## Test Plan Template

```md
# Test Plan: <feature name>

## Sources

- PRD: <link or path>
- Issues: <links or paths>
- Repo evidence: <brief list>

## Project Test Surface

- Surface: Frontend / Backend / Full-stack / CLI / Library / Job
- Supported evidence: Screenshot / Console / Network / API response / DB state / Log / Event / File output
- Unsupported surfaces: <what will not be tested and why>
- Assumptions: <only if evidence is incomplete>

## Coverage Matrix

| Requirement / Issue | Behavior Or Contract | Test Cases | Evidence | Status |
| --- | --- | --- | --- | --- |
| <REQ-1> | <what must be true> | TC-XXX-001 | <evidence type> | Covered / Blocked / Out of scope |

## Test Cases

<Use the test case template below.>

## Smoke Scope

- <P0 cases that prove the feature did not break at a glance>

## Regression Scope

- <existing flows or contracts that could be affected>

## Automation Plan

| Case | Recommendation | Level | Notes |
| --- | --- | --- | --- |
| TC-XXX-001 | Must automate / Should automate / Manual | Unit / Integration / API / UI / E2E | <why> |

## Open Testing Gaps

- <missing data, environment, credentials, unclear requirement, unavailable seam>
```

## Test Case Template

```md
### TC-<FEATURE>-001: <title>

- Linked requirement / issue: <PRD section, issue id, or acceptance criterion>
- Module / feature: <domain term>
- Scenario type: Positive / Negative / Boundary / Permission / Exception / Performance / Regression / Smoke
- Priority: P0 / P1 / P2
- Applicable surface: Frontend / Backend / Full-stack / CLI / Library / Job
- Verification level: Unit / Integration / API / UI / E2E / Manual QA
- Automation recommendation: Must automate / Should automate / Manual only
- Preconditions: <environment, account, permissions, data state>
- Test data: <inputs or data table>
- Steps:
  1. <step>
  2. <step>
- Expected results:
  - <observable user or caller result>
  - <response, data state, event, log, file output, or UI evidence if relevant>
- Evidence type: Screenshot / Console / Network / API response / DB state / Log / Event / File output
- Cleanup: <data or state to reset>
- Risk notes: <why this case matters, optional>
```

## Scenario Type Guide

- `Positive`: expected successful behavior.
- `Negative`: invalid input, denied action, failed dependency, or rejected state.
- `Boundary`: empty, one, many, max, min, null, Unicode, date/time, size, or rate edges.
- `Permission`: role, tenant, ownership, auth, or visibility enforcement.
- `Exception`: timeout, retry, partial failure, network error, queue failure, or rollback behavior.
- `Performance`: response time, query shape, load, batch size, memory, or resource limits.
- `Regression`: behavior that previously worked or is adjacent to changed code.
- `Smoke`: smallest high-signal proof that the main path still works.
