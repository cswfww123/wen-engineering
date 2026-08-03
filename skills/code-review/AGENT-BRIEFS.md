# Agent Briefs

Use these prompts as written with the orchestration ladder in `docs/agents/orchestration.md`. **Hard try** pack `Reviewer` (one instance per axis) and `Verifier` (after candidates); if missing or spawn fails, run the same brief yourself or via the host’s general worker. Missing agents must not abort review. Pass each Reviewer the same review packet: scope, diff commands or diff text, changed files, commit list, standards sources, intent evidence, project shape, and relevant project lenses.

**Paste this axis body into the spawn brief** (plus the shared review packet from `DISPATCH.md`). Subagent context is cold/disposable and often a weaker model — do not assume the worker will open this file on its own.

**Not for design/plan review.** After diagnosis, multi-step fix proposals use the same `Reviewer`/`Verifier` roles with a design packet — see [docs/agents/DESIGN-REVIEW-BRIEF.md](../../docs/agents/DESIGN-REVIEW-BRIEF.md). This file remains **code-delta** axes only.

Preferred execution: launch required axis Reviewers in parallel when the host allows (Standards, Spec/Intent, Correctness; plus UI Fidelity when user-visible UI changed; Performance/Security/Ponytail when warranted). Fallback: sequential axis briefs in the parent. Run the Verification Reviewer / `Verifier` only after collecting candidate findings. Authorized fixes after review use pack `Executor` (see code-review skill Auto-fix), not a second Reviewer.

## Intent Reviewer

Read the intent evidence first, in this **authority order** when multiple sources exist:

1. Active product requirements / PRD / `docs/requirements/*` (product behavior baseline)
2. Eng spec / implementation tickets derived from it
3. Explicit accepted PRD deltas only (`相对 PRD: …` or ticket Out-of-scope with PRD ref)
4. Grill / chat residual for eng seams the product doc does not specify
5. Bug report / user-provided path / branch-matching docs as applicable

Then read the diff. Report only where changed code misses requested behavior, adds unrequested scope, or implements the right requirement in the wrong place.

**Hard rules:**

- Dual-read product baseline and session/ticket AC. Quote the **product-doc line** when a PRD gap exists.
- Matching grill AC does **not** clear an unlabeled product-doc gap. Call that out as missing/partial with fixability `needs-user-decision` (or blocking if `/implement` claimed full product-doc coverage).
- Do not invent product requirements; do not invent authority for unlabeled MVP shrink.

Return under 300 words:

- findings with file/line, intent source, and the violated requirement or decision
- missing requirements, scope creep, and wrong-depth implementations
- **prd-alignment**: `aligned` | `authorized-deltas` | `unauthorized-partial` | `n/a` (no product doc)
- fixability: `auto-fixable`, `report-only`, or `needs-user-decision`
- likely false positives to discard
- whether this axis found no issues or no intent evidence was available

## Standards Reviewer

Read the standards sources, then read the diff. Report changed code that violates documented repo standards **or** matches the Fowler smell baseline in `REVIEW-AXES.md` (paste that baseline into the review packet). Cite the standard file and rule, or name the smell. Documented repo standards can be hard requirements; baseline smells are always judgment calls. A documented repo standard overrides the baseline. Skip anything formatters, linters, typecheckers, or tests plainly enforce.

Return under 300 words:

- findings with file/line, violated rule or smell name, and evidence
- hard violation vs judgment call
- fixability: `auto-fixable`, `report-only`, or `needs-user-decision`
- likely false positives to discard
- whether this axis found no issues

## Correctness Reviewer

Read the diff, then pull only nearby context, comments, tests, blame, or prior PR context needed to confirm concrete bugs. Focus on changed invariants, ordering, error handling, persistence, migrations, and regressions caused by the diff.

**Also scan for incomplete production surface** ([INCOMPLETE-SURFACE.md](INCOMPLETE-SURFACE.md)): deferred markers for real logic, stubs on live paths, dual-source domain facts across sibling channels, config stand-ins, **quiet critical path**, **log-unsafe**. Any hit on a production path is **blocking** (confidence often `100` when a comment admits deferral).

**Forensic log chain** ([FORENSIC-OBSERVABILITY.md](FORENSIC-OBSERVABILITY.md)): on external/async/webhook/MQ/third-party/state-machine paths the diff touches, check whether correlatable decision-boundary logs cover ingress → branch/skip → external outcome (including empty) → before/after → user-visible why. **Logging must be fail-open** — a log/MDC/metrics failure must never fail or gate business. Quiet path and log-unsafe are blocking, not style.

Return under 300 words:

- bugs users can hit, with file/line and why
- incomplete-surface hits (or explicit `clean`)
- observability: `instrumented` | `foundation-missing` | `quiet-path` | `log-unsafe` | `n/a` | findings
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

## UI Fidelity Reviewer

**Run when** the review packet says the diff changes user-visible UI (or ticket Layer is frontend / full-stack with UI subset). Otherwise return `skipped` with reason `non-UI`.

Read [REVIEW-AXES.md](REVIEW-AXES.md) **UI Fidelity** (paste that section into the brief if the worker cannot open files). Then read the pin/UI contract evidence from the packet and the UI-related hunks of the diff.

**Hard rules:**

- Do **not** Pass this axis on vibe ("looks close"). Require pin + evidence (screenshot path and/or checklist vs pin).
- No design pin **and** no explicit checklist-only waiver → blocking delivery gap.
- Missing empty/error/loading states that the UI contract or pin specifies → findings.
- Token drift vs package `DESIGN.md` when that file exists → findings unless accepted design delta.

Return under 300 words:

- **ui-fidelity**: `pass` | `fail` | `skipped` | `blocked-no-pin`
- design pin / checklist-only waiver / DESIGN.md paths used (or missing)
- evidence cited: screenshot path(s) and/or checklist items
- findings with concrete visual mismatches (layout, type, color, states) or missing evidence
- fixability: `auto-fixable`, `report-only`, or `needs-user-decision`

## Verification Reviewer

Run this after collecting findings. For each candidate, assign a `0-100` confidence score using `REVIEW-AXES.md`. Re-read the exact changed lines and cited evidence. Reject candidates that are invented, pre-existing, outside the diff, contradicted by context, likely intentional, or covered by CI.

**Incomplete production surface is never "likely intentional"** just because a TODO comment exists — shipping deferred real logic on a live path is a **blocking** failure. Quiet critical paths and log-unsafe logging are the same class. Completion claims fail while any remain. See [INCOMPLETE-SURFACE.md](INCOMPLETE-SURFACE.md) and [FORENSIC-OBSERVABILITY.md](FORENSIC-OBSERVABILITY.md).

**Logging fail-open:** if a log/MDC/metrics path can fail the business, that is blocking — not a style preference.

**UI Fidelity (when that axis was in scope):** empty evidence, missing pin without checklist-only waiver, or `ui-fidelity: fail` / `blocked-no-pin` **blocks** overall `Pass`. Do not accept parent prose alone ("fidelity OK") without pin/screenshot/checklist paths in the packet or candidates.

Return only findings with confidence `>=80`, each with:

- score
- file/line
- evidence
- why it is not a false positive
- fixability: `auto-fixable`, `report-only`, or `needs-user-decision`

Verdict: `Pass` only with zero validated blocking findings (including incomplete surface, quiet path, log-unsafe, **unauthorized product-doc partial** when a PRD/requirements doc was in the review packet, and **in-scope UI Fidelity failure / missing evidence**). Report **observability** when the diff touches applicable paths. Report **prd-alignment** when a product doc was in evidence. Report **ui-fidelity** when that axis ran. Otherwise `Changes Required` or `Needs User Decision`.
