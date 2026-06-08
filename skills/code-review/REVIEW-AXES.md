# Review Axes

Use these focused briefs when running sub-agents or separate review passes. Keep each pass evidence-first and under the review scope.

## Standards

Read the relevant standards docs before reading the diff. Report only places where changed code violates a documented rule.

Include:

- changed file and line
- rule source and the applicable rule
- whether the rule is a hard requirement or a judgment call

Skip issues enforced by automatic tooling unless the documented rule adds context that tooling cannot check.

## Completion

Read the originating issue, PRD, design note, user-provided request, branch name, and conversation summary before reading the diff. This axis exists to catch false "done" claims.

Look for:

- required behavior missing or only partially implemented
- behavior that contradicts the spec
- behavior added outside the requested scope
- implementation that appears to satisfy the words but fails the intent
- UI, API, persistence, background job, migration, or test wiring that was requested but never connected
- TODOs, placeholders, mocked paths, dead branches, or unreachable screens presented as finished work

Quote or cite the spec line for every finding. If there is no spec, report that this axis was skipped instead of inventing requirements.

## Correctness

Read the diff first, then pull local context only where it can confirm or disprove a concrete risk.

Look for:

- bugs that a user can hit in normal or edge-case flows
- changed invariants, ordering, error handling, authorization, persistence, or data migration behavior
- regressions suggested by git blame, nearby tests, previous PR comments, or comments in modified files
- security or data-loss risks directly introduced by the diff

Avoid speculative "could be better" comments. A finding should survive a skeptical second read.

## Performance And Security

Use the project shape from [PROJECT-LENSES.md](PROJECT-LENSES.md). Report risks introduced by the diff that can cause slow queries, page-load regressions, memory growth, request timeouts, data leaks, or exploitable input handling.

Look for:

- unbounded work on hot paths, N+1 queries, missing pagination, missing indexes, or unnecessary network waterfalls
- whole-file/result loading, unbounded caches/queues, leaked timers/listeners/subscriptions, or missing cleanup
- missing deadlines, cancellation, retries with backoff, or circuit-breaking on external calls
- injection, XSS, authz bypass, tenant leaks, unsafe redirects, path traversal, SSRF, secret exposure, or unsafe deserialization

Tie each finding to the current stack. Do not demand backend mitigations in a pure frontend app or frontend bundle work in a pure backend service.

## Shape

Use this pass for issues worth fixing even when behavior is probably correct.

Look for:

- duplicate logic where an existing helper or adapter already fits
- parameter sprawl, redundant state, leaky interfaces, or copy-paste variation
- stringly-typed code where local constants, types, or enums already exist
- unnecessary work, missed concurrency, hot-path bloat, or unclear ownership that is not covered by Performance And Security
- comments that narrate what obvious code does instead of preserving non-obvious why

Do not turn this axis into a style critique. Report only issues with clear maintenance, locality, or performance cost.

## Confidence Rubric

Score each candidate finding before reporting it:

- `0`: false positive, pre-existing issue, or contradicted by local evidence
- `25`: possible issue, but unverified or mostly stylistic
- `50`: real concern, but low impact or unlikely in practice
- `80`: likely real, important enough to fix, and directly tied to changed code
- `100`: definitely real, frequent, and directly proven

Report only findings with confidence `>=80`. For public PR comments, use the stricter bar: report only findings that would still feel fair after the author pushes back.

## Fixability Rubric

Use after confidence scoring:

- `auto-fixable`: local change, small impact, no business behavior choice, rollback obvious, verification available
- `report-only`: broad refactor, migration, security architecture, data model/query redesign, public API behavior, or risky rollout
- `needs-user-decision`: product behavior, tradeoff, unclear intent, or multiple valid fixes

Auto-fix only `auto-fixable` findings in local reviews when fixes were requested. Report everything else.

## Common False Positives

Filter these out unless the user asked for that lens:

- code outside the changed lines unless the diff directly activates the bug
- formatting, import order, type errors, or test failures that CI plainly covers
- broad requests for more tests, comments, documentation, or refactors without a specific missing behavior or rule
- intentional behavior that follows from the PR description or spec
- historical patterns that are ugly but untouched
- micro-optimizations outside a hot path
