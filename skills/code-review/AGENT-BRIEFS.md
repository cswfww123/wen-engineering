# Agent Briefs

Use these prompts as written when sub-agents are available. Pass each reviewer the same review packet: scope, diff commands or diff text, changed files, commit list, standards sources, intent evidence, project shape, and relevant project lenses.

Preferred execution: launch the six axis reviewers in parallel in one message so their contexts stay independent. Fallback: run the same six reviewers sequentially, preserving their labels and outputs. If no agent tool exists, run the briefs yourself one at a time. Run the Verification Reviewer only after collecting candidate findings.

## Intent Reviewer

Read the intent evidence first: PRD, issue, bug report, spec, user-provided path, branch-matching docs, and explicit user decisions. Then read the diff. Report only where changed code misses requested behavior, adds unrequested scope, or implements the right requirement in the wrong place.

Return under 300 words:

- findings with file/line, intent source, and the violated requirement or decision
- missing requirements, scope creep, and wrong-depth implementations
- fixability: `auto-fixable`, `report-only`, or `needs-user-decision`
- likely false positives to discard
- whether this axis found no issues or no intent evidence was available

## Standards Reviewer

Read the standards sources, then read the diff. Report only changed code that violates documented repo standards. Cite the standard file and rule. Distinguish hard requirements from judgment calls. Skip anything formatters, linters, typecheckers, or tests plainly enforce.

Return under 300 words:

- findings with file/line, violated rule, and evidence
- fixability: `auto-fixable`, `report-only`, or `needs-user-decision`
- likely false positives to discard
- whether this axis found no issues

## Correctness Reviewer

Read the diff, then pull only nearby context, comments, tests, blame, or prior PR context needed to confirm concrete bugs. Focus on changed invariants, ordering, error handling, persistence, migrations, and regressions caused by the diff.

Return under 300 words:

- bugs users can hit, with file/line and why
- evidence that the issue is introduced by this diff
- fixability: `auto-fixable`, `report-only`, or `needs-user-decision`
- likely false positives to discard

## Performance Reviewer

Identify the project shape and apply only relevant lenses from `PROJECT-LENSES.md`. Review the diff for query/IO amplification, slow queries, page-load regressions, OOM or memory growth, CPU amplification, resource leaks, request timeouts, observability gaps that hide performance failures, and stack-specific load risks. Flag loops that query or call remotely when one bounded lookup, join, batch, or cache read would do.

Return under 300 words:

- checked performance buckets, even when no issue survives
- performance findings with file/line and impact
- why the finding applies to this project shape
- fixability: data model, query redesign, index, batching, resource-limit, and observability-contract findings are `report-only` unless exact behavior preservation is proven
- likely false positives to discard

## Security Reviewer

Identify the project shape and apply only relevant lenses from `PROJECT-LENSES.md`. For security-relevant diffs, map the touched trust boundary or data flow before judging it. Review unsafe input handling, injection, XSS, authn/authz bypasses, tenant or privacy leaks, SSRF/path traversal, unsafe deserialization, secret exposure, dependency risk, and stack-specific exploit paths.

Return under 300 words:

- security findings with file/line and impact
- why the finding applies to this project shape
- fixability: security architecture, dependency policy, auth, crypto, data exposure, and public contract findings are `report-only` unless exact behavior preservation is proven
- likely false positives to discard

## Ponytail Reviewer

Review changed code only for over-engineering and complexity that should be cut before merge. Look for dead code, unused flexibility, speculative abstractions, one-implementation layers, reimplemented stdlib or native platform features, needless dependencies, and verbose code that can shrink without behavior changes.

Return under 300 words:

- issues worth fixing even if behavior is correct
- the smallest fix direction, using `delete`, `stdlib`, `native`, `yagni`, or `shrink`
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
