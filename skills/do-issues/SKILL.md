---
name: do-issues
description: Works ready vertical-slice issues one at a time. Use when resuming to-issues work or picking next AFK issue.
---

# Do Issues

Work through a generated issue set as an AFK implementation loop.

Each issue is one tracer-bullet vertical slice. Finish and verify the slice in front of you before picking another one.

## What To Do

Find the current requirement's issue set, choose the highest-priority unblocked AFK issue that is not complete, implement it with `/tdd`, update the issue, then repeat until no runnable AFK issues remain or the user's iteration limit is reached.

Never start two issues at once. Never skip verification before marking an issue complete.

## Finding The Issue Set

Read the repo context first:

- `CONTEXT.md`, or `CONTEXT-MAP.md` plus the relevant context file
- `docs/agents/issue-tracker.md`
- `docs/agents/triage-labels.md`

Treat those files as the source of truth for where issues live and how to list, read, update, comment on, and complete them. Do not assume GitHub, GitLab, local markdown, `.scratch/`, or any other tracker shape unless the repo config says so.

If the user passed a PRD path, feature slug, issue path, or issue number, start there.

If not, use the issue tracker doc's find-current-work or list-issues instructions. Prefer the most recently active unfinished requirement. If multiple active requirement sets look equally current, ask one concise question with the candidate references.

Read the parent PRD, spec, or source issue before selecting an implementation issue. Do not close or modify a parent issue unless the user explicitly asks.

## Selecting The Next Issue

An issue is complete if its `Status:` is `complete`, `completed`, `done`, or `closed`, or if every acceptance criterion is checked and comments show verified completion.

An issue is runnable when:

- `Type:` is `AFK`, or the issue clearly does not require human judgment
- `Status:` is missing, `ready-for-agent`, `todo`, `open`, or `in-progress`
- `Blocked by` is `None` / `None - can start immediately`, or every referenced blocker is complete
- it does not require unresolved external access, product judgment, design review, or user clarification

Prefer issues in this order:

1. Explicit `Priority:` if present
2. Lowest issue number, because `/to-issues` publishes blockers first
3. Oldest unfinished issue if numbering is missing

If the next issue is HITL, blocked, or underspecified, leave it untouched, add a short note only if useful, and continue to the next runnable AFK issue. If none remain, report the blocker.

## Execution Loop

For each selected issue:

1. Mark it `Status: in-progress` unless it already is.
2. If the issue modifies existing behavior, load `/deep-code-trace` on the relevant entrypoint before choosing the public interface and test seam.
3. Load `/tdd` and derive behavior tests from the acceptance criteria and public interface.
4. Run the failing test first and confirm RED.
5. Implement only enough code to pass that behavior.
6. Confirm GREEN, then repeat for the next behavior.
7. Refactor only after all tests for the slice are green.
8. Run the project's required verification commands before claiming completion.

Respect project instructions for verification, commits, docs, OpenAPI, SQL, and generated artifacts.

## Updating The Issue

After a verified slice:

- set `Status:` to the local completed status already used nearby, otherwise `complete`
- check off acceptance criteria that are now satisfied
- append a concise `## Comments` entry with what changed and exact verification commands and results
- leave unfinished or unverified criteria unchecked

If verification fails, keep `Status: in-progress`, append the failure only if useful for the next agent, and keep working unless the blocker is genuinely external.

Commit only when the user or project workflow asks for per-issue commits.

## Stop Conditions

Stop when:

- all runnable AFK issues are complete
- the user's iteration limit is reached
- every remaining issue is blocked, HITL, or needs information
- a destructive or external-access decision is required

When stopping, report the current feature directory, completed issues, remaining blocked issues, and verification evidence.

## After All Issues Complete

When all runnable AFK issues are done, validation is usually the next concern:

- `/code-review` — review the local changes
- `/qa-run` — validate the feature against the test plan

Use any, in any order; this skill prescribes no sequence.
