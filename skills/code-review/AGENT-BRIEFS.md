# Agent Briefs

Use these prompts as written with the orchestration ladder in `docs/agents/orchestration.md`. **Hard try** pack `Reviewer` (one instance per axis) and `Verifier` (after candidates); if missing or spawn fails, run the same brief yourself or via the host’s general worker. Missing agents must not abort review. Pass each Reviewer the same review packet: scope, diff commands or diff text, changed files, commit list, standards sources, intent evidence, project shape, and relevant project lenses.

**Paste this axis body into the spawn brief** (plus the shared review packet from `DISPATCH.md`). Subagent context is cold/disposable and often a weaker model — do not assume the worker will open this file on its own.

**Not for design/plan review.** After diagnosis, multi-step fix proposals use the same `Reviewer`/`Verifier` roles with a design packet — see [docs/agents/DESIGN-REVIEW-BRIEF.md](../../docs/agents/DESIGN-REVIEW-BRIEF.md). This file remains **code-delta** axes only.

Preferred execution: spawn only the workers **Pick weight** in [SKILL.md](SKILL.md) names. **Light** — one Slice Reviewer; Verifier only if that Reviewer filed candidates. **Full** — parallel Standards, Spec/Intent, Correctness; plus UI Fidelity when the packet marks it in scope; Performance/Security/Ponytail when warranted; then Verifier. Fallback: sequential briefs in the parent. Authorized fixes after review use pack `Executor` (see code-review skill Auto-fix), not a second Reviewer.

## Slice Reviewer

**Run when** `review-weight` is `light`. One worker for the whole delta — do not also spawn Standards / Spec / Correctness / UI Fidelity on the same slice.

Read the **full** diff and the intent evidence. Report:

1. Missing AC, or the right requirement implemented in the wrong place
2. Extra hunks the AC did not ask for (scope creep — blocking on `/implement`)
3. User-hittable breaks on the changed paths
4. Incomplete production surface / log-unsafe on production paths ([INCOMPLETE-SURFACE.md](INCOMPLETE-SURFACE.md)). Pure local visibility/default/copy of existing chrome with no async: `incomplete-surface: n/a`, `observability: n/a`
5. Same-surface lookalike on UI chrome ([SAME-SURFACE.md](SAME-SURFACE.md)): extra filter/picker/search beside an owner must extend that owner. Hide-arrow / padding CSS on a second `Select` is blocking, not a style nit. `ui-fidelity: n/a` does not waive. Non-UI: `same-surface: n/a`

Return under 300 words:

- findings with file:line, evidence, fixability, confidence
- extra hunks (or `none`)
- incomplete-surface: `clean` | findings | `n/a`
- observability: `n/a` | `instrumented` | `foundation-missing` | `quiet-path` | `log-unsafe` | findings
- same-surface: `owner-extended` | `new-no-sibling` | findings | `n/a`
- axis result: `issues found` | `clean`

## Intent Reviewer

Read the intent evidence first, in this **authority order** when multiple sources exist:

1. Active product requirements / PRD / `docs/requirements/*` (product behavior baseline)
2. Eng spec / implementation tickets derived from it
3. Explicit accepted PRD deltas only (`相对 PRD: …` or ticket Out-of-scope with PRD ref)
4. Grill / chat residual for eng seams the product doc does not specify
5. Bug report / user-provided path / branch-matching docs as applicable

Then read the diff. Report only where changed code misses requested behavior, adds unrequested scope, or implements the right requirement in the wrong place (including a same-surface lookalike: extra filters in a new widget beside the owner — [SAME-SURFACE.md](SAME-SURFACE.md)).

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

Review changed code only for over-engineering and complexity that should be cut before merge. Climb the ladder; stop at the first rung that holds. Look for dead code, unused flexibility, speculative abstractions, **reimplemented in-repo helpers/patterns** (`reuse` — including same-surface chrome lookalikes), reimplemented stdlib or **platform** features (`native` is `<input type="date">` / CSS, not the project's owner), one-implementation layers, needless dependencies, and verbose code that can shrink **after** it is in the right owner. A short second `Select` beside `CommonQuickFilters` is `reuse` missed, not `shrink` / `native`.

Return under 300 words:

- issues worth fixing even if behavior is correct
- the smallest fix direction, using `delete`, `reuse`, `stdlib`, `native`, `yagni`, or `shrink`
- fixability: small local cleanup may be `auto-fixable`; refactors are `report-only`
- likely false positives to discard

## UI Fidelity Reviewer

**Run when** the review packet marks UI Fidelity in scope (full weight **and** new/restyled chrome or a design pin — see [SKILL.md](SKILL.md) Pick weight). Otherwise return `skipped` with reason `not-in-scope`.

Read [REVIEW-AXES.md](REVIEW-AXES.md) **UI Fidelity** (paste that section into the brief if the worker cannot open files). Then read the pin/UI contract evidence from the packet and the UI-related hunks of the diff.

**Hard rules:**

- Do **not** Pass this axis on vibe ("looks close"). Require pin + evidence (screenshot path and/or checklist vs pin).
- No design pin **and** no explicit checklist-only waiver → blocking delivery gap.
- Missing empty/error/loading states that the UI contract or pin specifies → findings.
- Token drift vs package `DESIGN.md` when that file exists → findings unless accepted design delta.
- A restyled lookalike (hide-arrow / padding on a second widget) is **not** fidelity. Same-surface miss — [SAME-SURFACE.md](SAME-SURFACE.md) — do not Pass because it now *looks* like the owner.

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

**Same-surface lookalikes block Pass** on light and full when the diff adds or restyles chrome beside an owner of that family ([SAME-SURFACE.md](SAME-SURFACE.md)). Hide-arrow CSS is not a fix.

Return only findings with confidence `>=80`, each with:

- score
- file/line
- evidence
- why it is not a false positive
- fixability: `auto-fixable`, `report-only`, or `needs-user-decision`

Verdict: `Pass` only with zero validated blocking findings (including incomplete surface, quiet path, log-unsafe, **same-surface lookalike**, **unauthorized product-doc partial** when a PRD/requirements doc was in the review packet, and **in-scope UI Fidelity failure / missing evidence**). Report **observability** when the diff touches applicable paths. Report **prd-alignment** when a product doc was in evidence. Report **ui-fidelity** when that axis ran. Report **same-surface** when chrome changed. Otherwise `Changes Required` or `Needs User Decision`.
