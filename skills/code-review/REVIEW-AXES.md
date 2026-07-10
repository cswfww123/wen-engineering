# Review Axes

Use these focused briefs when running sub-agents or separate review passes. Keep each pass evidence-first and under the review scope.

## Intent

Read the spec, ticket, legacy PRD/issue, bug report, user-provided path, branch-matching docs, and explicit user decisions before judging the diff.

Look for:

- requested behavior missing from the changed code
- behavior the diff adds that was not requested
- implementation that satisfies the words but violates the agreed intent
- fixes placed at a shallow caller when the issue belongs in a shared owner
- spec, ticket, legacy PRD/issue, or bugfix acceptance criteria with no matching code path

Report only claims tied to a cited intent source. If no intent source exists, say so and skip this axis instead of inventing product requirements.

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
- changed invariants, ordering, error handling, persistence, or data migration behavior
- regressions suggested by git blame, nearby tests, previous PR comments, or comments in modified files
- data-loss risks directly introduced by the diff
- when the diff touches a shared mutable invariant (balance/quota/counter/inventory/state machine), require a concurrency test seam per `.agents/rules/invariants/`; serial-only tests are insufficient

Avoid speculative "could be better" comments. A finding should survive a skeptical second read.

## Performance

Use the project shape from [PROJECT-LENSES.md](PROJECT-LENSES.md). Report risks introduced by the diff that can cause slow queries, page-load regressions, memory growth, OOM, CPU spikes, request timeouts, worker backlog, or diagnosis-blind failures.

Look for:

- query or IO amplification: N+1 access, repeated same-table/query calls in loops, per-row remote calls, or request work that grows from `O(1)` to `O(n)`/`O(n*m)`
- loops that query or call remotely where one bounded lookup, join, batch, or cache read would do
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

For security-relevant changes, trace the affected trust boundary or data flow: where untrusted input enters, where permissions are checked, where data is persisted, logged, returned, exported, or cached. Mark unknowns as unknown; do not infer hidden defenses from names.

Tie each finding to changed code and stack-specific exploitability. Treat auth, crypto, dependency policy, data exposure, and public contract changes as `report-only` unless exact behavior preservation is proven.

## Ponytail

Use this pass only for over-engineering and complexity. The diff's best cleanup outcome is getting shorter.

Look for:

- `delete`: dead code, unused flexibility, speculative feature, or obvious narration.
- `stdlib`: hand-rolled code the standard library already ships.
- `native`: dependency or code doing what the platform already does.
- `yagni`: abstraction with one implementation, config nobody sets, layer with one caller.
- `shrink`: same behavior in fewer lines.

Name what to cut and what replaces it. Do not report correctness, security, performance, or style findings in this axis; route them to their own axes.

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

Auto-fix `auto-fixable` findings only when the user explicitly authorized
review fixes or `/implement` supplied an already-authorized code scope. A
standalone review is report-only. Report everything else.

## Common False Positives

Filter these out unless the user asked for that lens:

- code outside the changed lines unless the diff directly activates the bug
- formatting, import order, type errors, or test failures that CI plainly covers
- broad requests for more tests, comments, documentation, or refactors without a specific missing behavior or rule
- intentional behavior that follows from the PR description or spec
- historical patterns that are ugly but untouched
- micro-optimizations outside a hot path
