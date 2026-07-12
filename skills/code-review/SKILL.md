---
name: code-review
description: Reviews diffs for intent, bugs, ponytail complexity, performance, security, and standards.
---

# Code Review

Review changed code against repo evidence. Default to local changes; keep findings high-confidence (`>=80`). Standalone review is report-only. Auto-fix only when the user authorized review fixes or `/implement` supplied an already-authorized code-change scope.

When `/implement` loads this skill, use its recorded ticket fixed point and return a completion verdict; `/implement` owns tracker state.

Load on demand: [AGENT-BRIEFS.md](AGENT-BRIEFS.md), [REVIEW-AXES.md](REVIEW-AXES.md), [PROJECT-LENSES.md](PROJECT-LENSES.md).
Subagent dispatch: `docs/agents/orchestration.md` (required try / soft fail).

## Workflow

### 1. Scope

- Use the user's fixed point when given; otherwise local staged + unstaged (`git diff --cached`, `git diff`) and status.
- Branch: `git diff <fixed-point>...HEAD` and `git log <fixed-point>..HEAD --oneline`.
- GitHub PR: follow `docs/agents/issue-tracker.md` when present; prefer `gh` for metadata/diff/comments. Do not post a public review on closed, draft, automated, very small, or already-reviewed-by-this-agent PRs unless the user confirms.
- If no PR, no local diff, and no fixed point — ask what to review against.

### 2. Evidence

Collect only what the changed files need: standards (`AGENTS.md`, `.agents/rules/**`, `CONTEXT.md`, ADRs, machine config), intent (spec/ticket/legacy source/user decisions), project shape for touched paths, and nearby comments/history. When behavior crosses entrypoints, Mapper/DAO, converters, permissions, async, or side effects, trace the entrypoint first.

Treat formatters, linters, typecheckers, and tests as verification tools — do not re-report what CI plainly catches unless the user asked.

### 3. Passes (hard try Reviewer)

Build one review packet (diff commands, files, commits, standards, intent, shape, stack lenses). Axes: **Intent**, **Correctness**, **Ponytail**, **Performance**, **Security**, **Standards** — detail in [REVIEW-AXES.md](REVIEW-AXES.md) and [AGENT-BRIEFS.md](AGENT-BRIEFS.md).

For each axis:

1. **Try** project agent `Reviewer` with the full packet + that axis brief (launch all six in parallel when the Agent tool allows).
2. If `Reviewer` missing / spawn fails → parent runs that axis brief in-session (or sequential).
3. **Never** abort review because `Reviewer` is undefined.

### 4. Validate (hard try Verifier)

After candidates are collected:

1. **Try** project agent `Verifier` with candidates + same fixed point / packet.
2. If missing / spawn fails → parent runs the Verification Reviewer brief from [AGENT-BRIEFS.md](AGENT-BRIEFS.md).
3. Keep a finding only when it: touches the diff (or is a direct consequence); cites rule/spec/code/history/runtime evidence; is not pre-existing, intentional scope, tooling noise, or a low-impact nit; scores confidence `>=80` per [REVIEW-AXES.md](REVIEW-AXES.md).
4. Re-check PR eligibility before posting comments.

### 5. Auto-fix (hard try Executor when authorized)

**Authority required:** user asked to fix (“修一下”, “fix these”, …), or `/implement` authorized in-scope fixes for this fixed point. Without authority → report-only; skip this section.

**Contract** — every applied fix must change **how**, never **what**: preserve features, outputs, return values, error modes, and side effects; do not add/remove/reorder business logic, authz, validation, or data transforms; introduce no new external calls, file writes, or state mutations. If any part cannot be verified, stay report-only.

**Eligible only if all hold:** authority; confidence `>=80`; local to changed lines, single function or smaller; behavior contract satisfied; exact hunk revertible; a test/typecheck/lint can confirm.

Prefer auto-fixing eligible Ponytail and Standards. Correctness/Performance/Security only when mechanical, local, and behavior-preserving.

**Never auto-fix:** public PR/branch audits; migrations/schema; security architecture; business logic or product behavior; cross-module refactors; public API contracts; ambiguous multi-approach fixes; code outside this session/diff.

**Dispatch:**

1. **Try** project agent `Executor` with: fixed point, eligible findings (file/line, fix direction), fix contract above, verify commands, **no tracker authority**.
2. Else built-in `general-purpose` with the same brief.
3. Else parent applies fixes in-session.
4. **Never** abort because `Executor` is missing.

**Per fix (whoever applies):** one finding, one hunk → verify immediately → on failure revert only that hunk → never path-level checkout/reset without user approval. After all eligible fixes, report fixed/skipped/remaining. If fixes landed, re-run Validate (`Verifier` ladder) on the new diff when practical.

### 6. Report

Findings first, by severity:

```markdown
### <severity>: <one-line summary>

- **File**: `path/to/file.ext:line`
- **Evidence**: <what you saw and where>
- **Why it matters**: <concrete impact>
- **Fix direction**: <smallest useful fix>
- **Status**: auto-fixed / report-only / needs-user-decision
```

Verdict:

- `Pass` — no validated blocking finding; every auto-fix verified
- `Changes Required` — a validated finding blocks completion
- `Needs User Decision` — behavior/trade-off evidence cannot decide

If nothing survives validation, say so and note skipped axes or unrun verification. Note which agents ran or which fallback was used. This skill never closes a ticket. For GitHub comments, cite full commit SHA links and line ranges.
