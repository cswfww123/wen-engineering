---
name: code-review
description: Reviews local diffs or PRs for completion, regressions, performance, and safety. Use for WIP or PR reviews.
---

# Code Review

Review changed code against repo evidence, not personal taste. Default to local changes, keep findings high-confidence, and never change business behavior during review.

See [AGENT-BRIEFS.md](AGENT-BRIEFS.md), [REVIEW-AXES.md](REVIEW-AXES.md), and [PROJECT-LENSES.md](PROJECT-LENSES.md) for reviewer prompts, stack lenses, scoring, and false-positive filters.

## Quick Start

1. Default to local staged and unstaged changes unless the user names a PR, branch, commit, tag, or fixed point.
2. Gather the diff, commit list, changed files, project shape, standards sources, and spec source.
3. Run independent reviewer briefs in parallel when possible, or sequentially with the same prompts when not.
4. Validate and score each finding from 0-100; keep only findings with confidence `>=80`.
5. Auto-fix only verified low-risk local findings when fixes were requested; report larger findings.

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
- spec: linked issue, PRD, user-provided path, branch-matching docs under `docs/`, `specs/`, or `.scratch/`
- project shape: setup harness notes, `CONTEXT.md`, `.agents/rules/**`, package/build files, routes, services, migrations, and deployment config
- local context: comments near modified hunks, adjacent helper modules, and relevant git history

Treat formatters, linters, typecheckers, and tests as verification tools. Do not report issues that CI will plainly catch unless the user asked for that kind of review.

### 3. Run Focused Passes

Build one review packet with the diff commands, changed files, commit list, standards sources, spec source, project shape, and relevant stack lenses.

When sub-agents are available, launch the five axis reviewers from [AGENT-BRIEFS.md](AGENT-BRIEFS.md) in parallel in one message. When parallel agents are unavailable, run the same reviewers sequentially. When no agent tool exists, perform the passes yourself in the same order:

- **Standards**: diff compliance with documented repo rules and local instructions
- **Completion**: every requested capability is actually wired, tested where appropriate, and not merely claimed complete
- **Correctness**: bugs visible in the diff, historical intent, modified-line impact, and nearby comments
- **Performance/Security**: slow queries, memory growth, timeouts, unsafe input, data exposure, and stack-specific load risks
- **Shape**: reuse, quality, maintainability, and efficiency issues that matter enough to change

After collecting candidate findings, run the Verification Reviewer from [AGENT-BRIEFS.md](AGENT-BRIEFS.md) once.

Skip Completion only when no request, issue, PRD, branch intent, or conversation summary is available and the user confirms there is none.

### 4. Validate Findings

Before reporting any finding:

- confirm it touches code changed by the diff or is a direct consequence of that change
- cite the rule, spec line, code line, comment, history, or runtime evidence behind it
- check that it is not pre-existing, intentional scope, tooling noise, or a low-impact nit
- score confidence from `0-100` using [REVIEW-AXES.md](REVIEW-AXES.md) and keep only findings with confidence `>=80`

For PR comments, re-check PR eligibility before posting and do not post unless the user explicitly asked you to comment.

### 5. Auto-Fix And Safety

Auto-fix only after review, only in local working-tree reviews, and only when the user requested fixes or safe auto-fix. Never auto-fix public PR reviews, branch audits, destructive changes, migrations, broad refactors, ambiguous product behavior, or security architecture changes.

An issue is auto-fixable only when Verification marks it confidence `>=80`, impact small, scope local, rollback obvious, and expected behavior unchanged. Make the smallest edit, then run the relevant verification. If verification is unavailable or fails, stop and report.

### 6. Report

Lead with findings, ordered by severity. For each finding include:

- file and line
- why it matters
- evidence source
- smallest useful fix direction
- whether it was auto-fixed, skipped as too large, or needs user decision

If no issues survive validation, say so clearly and mention any skipped axis or unrun verification. Keep summaries brief; the review is the product.

For GitHub comments, cite code with full commit SHA links and line ranges so the rendered review stays stable.
