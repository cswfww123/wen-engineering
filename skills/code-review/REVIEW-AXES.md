# Review Axes

Use these focused briefs when running sub-agents or separate review passes. Keep each pass evidence-first and under the review scope.

## Standards

Read the relevant standards docs before reading the diff. Report only places where changed code violates a documented rule.

Include:

- changed file and line
- rule source and the applicable rule
- whether the rule is a hard requirement or a judgment call

Skip issues enforced by automatic tooling unless the documented rule adds context that tooling cannot check.

## Correctness

Read the diff first, then pull local context only where it can confirm or disprove a concrete risk.

Look for:

- bugs that a user can hit in normal or edge-case flows
- null/undefined dereferences, unchecked optional values, or partial-result assumptions introduced by changed data flow
- changed invariants, ordering, error handling, authorization, persistence, or data migration behavior
- regressions suggested by git blame, nearby tests, previous PR comments, or comments in modified files
- security or data-loss risks directly introduced by the diff
- when the diff touches a shared mutable invariant (balance/quota/counter/inventory/state machine), require a concurrency test seam per `.agents/rules/invariants/`; serial-only tests are insufficient

Avoid speculative "could be better" comments. A finding should survive a skeptical second read.

## Performance

Use the project shape from [PROJECT-LENSES.md](PROJECT-LENSES.md). Report risks introduced by the diff that can cause slow queries, page-load regressions, memory growth, OOM, CPU spikes, request timeouts, worker backlog, or diagnosis-blind failures.

Look for:

- query or IO amplification: N+1 access, repeated same-table/query calls in loops, per-row remote calls, or request work that grows from `O(1)` to `O(n)`/`O(n*m)`
- unbounded work on hot paths, missing pagination, missing filters, missing indexes, full scans, or unnecessary network waterfalls
- memory pressure and OOM risks: whole-file/result loading, unbounded lists/maps/caches/queues, large materialized joins, or missing streaming/backpressure
- CPU or serialization amplification: nested loops over growing inputs, repeated parsing/encoding, expensive transforms in render/request paths, or avoidable recomputation
- resource leaks: leaked timers/listeners/subscriptions, unreleased handles, runaway background work, or missing cleanup
- async throughput risks: non-idempotent retries, unbounded queues, missing dead-letter/poison-message handling, lock contention, or task fanout without backpressure
- missing deadlines, cancellation, retries with backoff, circuit-breaking, or rate limits on external calls
- observability gaps that hide performance failures: swallowed errors, missing job/request identifiers, missing timing/error metrics, or high-cardinality labels introduced by the diff

Tie each finding to the current stack. Do not demand backend mitigations in a pure frontend app or frontend bundle work in a pure backend service.

For applicable project shapes, explicitly check each performance bucket above. If no issue survives validation, say which buckets were checked instead of staying silent. Treat query redesign, index changes, batching changes, resource-limit changes, and observability-contract changes as `report-only` unless the exact behavior, ordering, filtering, authorization, transaction, and rollout effects are proven unchanged.

## Security

Use the project shape from [PROJECT-LENSES.md](PROJECT-LENSES.md). Report risks introduced by the diff that can cause exploitable input handling, authorization bypass, data exposure, tenant leaks, or supply-chain exposure.

Look for:

- injection, XSS, authn/authz bypass, tenant leaks, unsafe redirects, path traversal, SSRF, secret exposure, or unsafe deserialization
- sensitive data in logs, metrics, traces, errors, caches, URLs, client bundles, or exported files
- dependency changes that add unnecessary privilege, risky transitive code, unpinned sources, license/policy exposure, or large runtime attack surface
- broken security assumptions across frontend/backend seams, background jobs, migrations, or third-party callbacks

Tie each finding to changed code and stack-specific exploitability. Treat auth, crypto, dependency policy, data exposure, and public contract changes as `report-only` unless exact behavior preservation is proven.

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
