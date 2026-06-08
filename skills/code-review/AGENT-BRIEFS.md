# Agent Briefs

Use these prompts as written when sub-agents are available. Pass each reviewer the same review packet: scope, diff commands or diff text, changed files, commit list, standards sources, spec source, project shape, and relevant project lenses.

Preferred execution: launch the five axis reviewers in parallel in one message so their contexts stay independent. Fallback: run the same five reviewers sequentially, preserving their labels and outputs. If no agent tool exists, run the briefs yourself one at a time. Run the Verification Reviewer only after collecting candidate findings.

## Standards Reviewer

Read the standards sources, then read the diff. Report only changed code that violates documented repo standards. Cite the standard file and rule. Distinguish hard requirements from judgment calls. Skip anything formatters, linters, typecheckers, or tests plainly enforce.

Return under 300 words:

- findings with file/line, violated rule, and evidence
- fixability: `auto-fixable`, `report-only`, or `needs-user-decision`
- likely false positives to discard
- whether this axis found no issues

## Completion Reviewer

Read the request, issue, PRD, branch intent, or conversation summary before the diff. Check whether every requested capability is actually wired through the UI/API/persistence/jobs/migrations/tests that the project shape requires. Look for TODOs, placeholders, mocks, dead branches, unreachable screens, or partial paths presented as finished.

Return under 300 words:

- missing, partial, incorrect, or out-of-scope requirements
- the source line or request phrase each finding depends on
- fixability: usually `report-only` unless the missing wiring is tiny and local
- whether this axis was skipped because no spec source exists

## Correctness Reviewer

Read the diff, then pull only nearby context, comments, tests, blame, or prior PR context needed to confirm concrete bugs. Focus on changed invariants, ordering, error handling, authorization, persistence, migrations, and regressions caused by the diff.

Return under 300 words:

- bugs users can hit, with file/line and why
- evidence that the issue is introduced by this diff
- fixability: `auto-fixable`, `report-only`, or `needs-user-decision`
- likely false positives to discard

## Performance And Security Reviewer

Identify the project shape and apply only relevant lenses from `PROJECT-LENSES.md`. Review the diff for slow queries, page-load regressions, memory growth, request timeouts, data leaks, unsafe input handling, authz bypasses, and stack-specific load risks.

Return under 300 words:

- performance or security findings with file/line and impact
- why the finding applies to this project shape
- fixability: security architecture, data model, and query redesign findings are `report-only`
- likely false positives to discard

## Shape Reviewer

Review changed code for meaningful reuse, quality, maintainability, and efficiency issues. Look for duplicate helpers, parameter sprawl, redundant state, leaky interfaces, stringly-typed code where local types exist, unclear ownership, and unnecessary obvious comments.

Return under 300 words:

- issues worth fixing even if behavior is probably correct
- the smallest fix direction
- fixability: small local cleanup may be `auto-fixable`; refactors are `report-only`
- likely false positives to discard

## Verification Reviewer

Run this after collecting findings. For each candidate, assign a `0-100` confidence score using `REVIEW-AXES.md`. Re-read the exact changed lines and cited evidence. Reject candidates that are invented, pre-existing, outside the diff, contradicted by context, likely intentional, or covered by CI.

Return only findings with confidence `>=80`, each with:

- score
- file/line
- evidence
- why it is not a false positive
- fixability: `auto-fixable`, `report-only`, or `needs-user-decision`
