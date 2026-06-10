# Agent Briefs

Use these prompts as written when sub-agents are available. Pass each reviewer the same review packet: scope, diff commands or diff text, changed files, commit list, standards sources, behavior evidence, project shape, and relevant project lenses.

Preferred execution: launch the five axis reviewers in parallel in one message so their contexts stay independent. Fallback: run the same five reviewers sequentially, preserving their labels and outputs. If no agent tool exists, run the briefs yourself one at a time. Run the Verification Reviewer only after collecting candidate findings.

## Standards Reviewer

Read the standards sources, then read the diff. Report only changed code that violates documented repo standards. Cite the standard file and rule. Distinguish hard requirements from judgment calls. Skip anything formatters, linters, typecheckers, or tests plainly enforce.

Return under 300 words:

- findings with file/line, violated rule, and evidence
- fixability: `auto-fixable`, `report-only`, or `needs-user-decision`
- likely false positives to discard
- whether this axis found no issues

## Correctness Reviewer

Read the diff, then pull only nearby context, comments, tests, blame, or prior PR context needed to confirm concrete bugs. Focus on changed invariants, ordering, error handling, authorization, persistence, migrations, and regressions caused by the diff.

Return under 300 words:

- bugs users can hit, with file/line and why
- evidence that the issue is introduced by this diff
- fixability: `auto-fixable`, `report-only`, or `needs-user-decision`
- likely false positives to discard

## Performance Reviewer

Identify the project shape and apply only relevant lenses from `PROJECT-LENSES.md`. Review the diff for query/IO amplification, slow queries, page-load regressions, OOM or memory growth, CPU amplification, resource leaks, request timeouts, observability gaps that hide performance failures, and stack-specific load risks.

Return under 300 words:

- checked performance buckets, even when no issue survives
- performance findings with file/line and impact
- why the finding applies to this project shape
- fixability: data model, query redesign, index, batching, resource-limit, and observability-contract findings are `report-only` unless exact behavior preservation is proven
- likely false positives to discard

## Security Reviewer

Identify the project shape and apply only relevant lenses from `PROJECT-LENSES.md`. Review the diff for unsafe input handling, injection, XSS, authn/authz bypasses, tenant or privacy leaks, SSRF/path traversal, unsafe deserialization, secret exposure, dependency risk, and stack-specific exploit paths.

Return under 300 words:

- security findings with file/line and impact
- why the finding applies to this project shape
- fixability: security architecture, dependency policy, auth, crypto, data exposure, and public contract findings are `report-only` unless exact behavior preservation is proven
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
