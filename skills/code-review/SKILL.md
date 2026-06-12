---
name: code-review
description: Reviews diffs for standards, correctness, performance, security, and shape. Use for WIP or PR reviews.
---

# Code Review

Review changed code against repo evidence, not personal taste. Default to local changes, keep findings high-confidence, and never change business behavior during review.

See [AGENT-BRIEFS.md](AGENT-BRIEFS.md), [REVIEW-AXES.md](REVIEW-AXES.md), and [PROJECT-LENSES.md](PROJECT-LENSES.md) for reviewer prompts, stack lenses, scoring, and false-positive filters.

## Quick Start

1. Default to local staged and unstaged changes unless the user names a PR, branch, commit, tag, or fixed point.
2. Gather the diff, commit list, changed files, project shape, standards sources, and behavior evidence.
3. Run independent reviewer briefs in parallel when possible, or sequentially with the same prompts when not.
4. Validate and score each finding from 0-100; keep only findings with confidence `>=80`.
5. Auto-fix only verified low-risk local findings when fixes were requested; report larger findings.

## Auto-Fix Behavior Preservation Contract

Every auto-fix this skill applies must satisfy this contract:

- The fix affects **how** the code does something, never **what** it does
- All original features, outputs, return values, error modes, and side effects remain intact
- No business logic, authorization check, validation rule, or data transformation is added, removed, or reordered
- No new external calls, file writes, or state mutations are introduced by a fix

Review findings and suggestions may describe behavior-changing defects, but those findings are **report-only** unless the candidate fix satisfies this contract. If any part of the contract cannot be verified for a candidate fix, keep the finding **report-only**.

## Workflow

### 1. Establish Scope

Use the user's fixed point exactly when they provide one. If they only say "review", inspect the local working tree first.

- For a branch review, compare with `git diff <fixed-point>...HEAD` and list commits with `git log <fixed-point>..HEAD --oneline`.
- For local WIP, review staged and unstaged diffs with `git diff --cached` and `git diff`, plus changed-file status.
- For a GitHub PR, follow `docs/agents/issue-tracker.md` when present and prefer `gh` for PR metadata, diff, comments, and issue links.

For PRs, record whether the PR is closed, draft, automated, very small, or already reviewed by this agent. Do not post a public review in those cases unless the user explicitly confirms.

If there is no PR, no local diff, and no fixed point, ask what to review against.

### 2. Gather Evidence

Collect only the sources needed for the changed files:

- standards: `AGENTS.md`, `CLAUDE.md`, `.agents/rules/**`, `CONTRIBUTING.md`, `STYLE*`, `STANDARDS*`, relevant `CONTEXT.md` files, ADRs, and machine config
- behavior evidence: linked issue, PRD, user-provided path, branch-matching docs under `docs/`, `specs/`, or `.scratch/`
- project shape: setup harness notes, `CONTEXT.md`, `.agents/rules/**`, package/build files, routes, services, migrations, and deployment config
- local context: comments near modified hunks, adjacent helper modules, and relevant git history

When a diff changes behavior across internal calls, public entrypoints, Mapper/DAO queries, converters, permissions, async paths, or side effects, load `/deep-code-trace` on the touched entrypoint before validating correctness, performance, security, or behavior-preservation claims.

Treat formatters, linters, typecheckers, and tests as verification tools. Do not report issues that CI will plainly catch unless the user asked for that kind of review.

### 3. Run Focused Passes

Build one review packet with the diff commands, changed files, commit list, standards sources, behavior evidence, project shape, and relevant stack lenses.

When sub-agents are available, launch the five axis reviewers from [AGENT-BRIEFS.md](AGENT-BRIEFS.md) in parallel in one message so their contexts stay independent. When parallel agents are unavailable, run the same reviewers sequentially. When no agent tool exists, perform the passes yourself in the same order.

- **Standards**: diff compliance with documented repo rules and local instructions
- **Correctness**: bugs visible in the diff, historical intent, modified-line impact, and nearby comments
- **Performance**: slow queries, memory growth, timeouts, resource leaks, and stack-specific load risks
- **Security**: unsafe input, authorization bypasses, data exposure, tenant leaks, and stack-specific exploit risks
- **Shape**: reuse, quality, maintainability, and efficiency issues that matter enough to change

After collecting candidate findings, run the Verification Reviewer from [AGENT-BRIEFS.md](AGENT-BRIEFS.md) once.

### 4. Validate Findings

Before reporting any finding:

- confirm it touches code changed by the diff or is a direct consequence of that change
- cite the rule, spec line, code line, comment, history, or runtime evidence behind it
- check that it is not pre-existing, intentional scope, tooling noise, or a low-impact nit
- score confidence from `0-100` using [REVIEW-AXES.md](REVIEW-AXES.md) and keep only findings with confidence `>=80`

For PR comments, re-check PR eligibility before posting and do not post unless the user explicitly asked you to comment.

### 5. Auto-Fix And Safety

#### Auto-Fix Eligibility

A finding is auto-fixable only when **all** of the following are true:

- Confidence score `>= 80` from the Verification Reviewer
- Impact: local to the changed lines, no cascade effects
- Scope: single function or smaller
- Behavior: the fix preserves exact behavior per the Auto-Fix Behavior Preservation Contract above
- Rollback: the exact fix hunk can be reverted without touching unrelated user changes
- Verification: a test, typecheck, or linter exists to confirm the fix

If even one criterion fails, mark the finding **report-only** and explain why.

#### Never Auto-Fix

Do not auto-fix any finding in these categories, regardless of confidence:

- Public PR reviews or branch audits
- Database migrations or schema changes
- Security architecture (auth, authz, crypto, secrets)
- Business logic, product behavior, or authorization rule changes
- Cross-module refactors
- Changes to public API contracts
- Ambiguous fixes with multiple valid approaches
- Code the user did not author in this session or diff

#### Per-Fix Protocol

When a fix is eligible:

1. Make the **smallest possible edit** — one finding, one hunk
2. Run available verification immediately (tests, typecheck, lint)
3. If verification passes, proceed to the next fix
4. If verification fails or is unavailable, **revert only the fix hunk** and report
5. Never stack multiple fixes without verifying each one

Never use path-level checkout/reset to undo an auto-fix unless the user explicitly approves it; those commands can discard unrelated user-authored changes in the same file.

After all eligible fixes, report what was fixed with verification results, what was skipped and why, and any remaining findings that need user decision.

### 6. Report

Lead with findings, ordered by severity. For each finding use this format:

```markdown
### <severity>: <one-line summary>

- **File**: `path/to/file.ext:line`
- **Evidence**: <what you saw and where>
- **Why it matters**: <concrete impact>
- **Fix direction**: <smallest useful fix>
- **Status**: auto-fixed / report-only / needs-user-decision
```

If no issues survive validation, say so clearly and mention any skipped axis or unrun verification. Keep summaries brief; the review is the product.

For GitHub comments, cite code with full commit SHA links and line ranges so the rendered review stays stable.
