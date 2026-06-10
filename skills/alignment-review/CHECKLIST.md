# Alignment Review Checklist

Use this only when the core workflow needs sharper review prompts.

## Requirement Fidelity

- Does the artifact answer the user's actual request, not a nearby generic version?
- Are all explicit constraints, exclusions, actors, states, and edge cases represented?
- Are ambiguous points marked as assumptions or user questions instead of hidden decisions?
- Does the solution preserve the user's preferred level of backend, frontend, product, or operational scope?
- Are non-functional constraints such as security, observability, compatibility, accessibility, performance, retention, or migration called out when the source or repo risk requires them?

## Repo Evidence

- Which existing modules, routes, jobs, tables, contracts, tests, or runtime surfaces prove the current shape?
- Does the plan reuse established ownership boundaries and vocabulary?
- Are new abstractions justified by repeated complexity or existing local patterns?
- Are claims about behavior backed by code, docs, tracker comments, runtime evidence, or user-provided facts?

## PRD Review

- Problem statement is from the user's perspective.
- Solution matches the agreed behavior and does not smuggle in extra product scope.
- User stories cover the complete behavior surface.
- Implementation decisions state module, contract, schema, API, and interaction choices without stale file-path detail.
- Rollout, config, migration, monitoring, manual operation, and rollback decisions are explicit when they affect release safety.
- Testing decisions identify the highest useful seams and prior art.
- Out-of-scope items prevent predictable drift.

## Issue Slice Review

- Each issue delivers a narrow complete path through the system.
- Each issue keeps a stable link back to the PRD requirement, source issue, or acceptance criterion it satisfies.
- Each issue is demoable or verifiable alone.
- Slices are not horizontal tasks such as only schema, only API, only UI, or only tests.
- Required prefactoring comes before dependent behavior and has a clear payoff.
- Blocked-by relationships are minimal, accurate, and publishable.
- Acceptance criteria are observable and do not depend on reading the agent's mind.

## Test Plan Review

- Each test case maps to a requirement, contract, regression, or risk.
- Traceability is stable enough to follow `source requirement -> issue/test case -> QA evidence`.
- Every material requirement is covered by at least one case, explicitly blocked, or explicitly out of scope.
- Positive, negative, boundary, permission, error, async, migration, performance, and regression coverage are present where the source or repo risk calls for them.
- Tests use the highest stable seam available in the repo.
- The plan avoids brittle checks of private implementation details unless that is the actual contract.
- Expected results and evidence types are concrete enough for `/qa-run` to decide pass, fail, blocked, or not run without rereading the whole planning thread.
- Missing test data, fixtures, permissions, or environment assumptions are called out.

## Verdict Calibration

- Use `Pass` only when remaining risk is ordinary implementation risk.
- Use `Small Fix` when specific edits can repair the artifact without changing its shape.
- Use `Rework` when the artifact omits key scope, slices horizontally, or rests on a wrong architecture assumption.
- Use `Ask User` only when evidence cannot decide a product or taste question.
