# Closed loop

Two layers. The agent tunes itself through the notebook and the nightly
review. The human leads the build through `## Agent skills` in `AGENTS.md`:
what gets built, which slice starts, when a decision is reversed. A loop
does not take a goal the human has not set. The human does not re-derive a
lesson the notebook already holds.

The maintainer keeps direction and the gates. The method was taken from
yetone/magpie as checked on 2026-10-13. Do not re-derive it.

## Router

`AGENTS.md` is a router. It holds pointers, not the material they point at.
Read the file the pointer names before the work it names. A rule lives in one
file. Do not copy it back into `AGENTS.md` to make it easier to find.

A line stays in `AGENTS.md` only when deleting it would make a turn wrong
before any branch is entered, and no other file already says it. A product
description, a stack version, and a procedure for one kind of work do not
qualify. A repeated miss lives in `LESSONS.md`, which is read before any code
change, so it does not need a second copy in the router.

`CLAUDE.md` is not a second rules file. Where the host injects a file named
with `@` (Claude Code does), `CLAUDE.md` holds only:

```markdown
@AGENTS.md
@LESSONS.md
```

That injection is what puts the notebook in context on every turn. Where the
host does not inject `@` (ZCode loads `AGENTS.md` and does not read
`CLAUDE.md`), do not invent the symlink as a substitute. The skills that
change code read `LESSONS.md` before the first edit. Deleting the `@` file to
tidy up removes the injection.

## Lessons

`LESSONS.md` is the error notebook. Read it before changing code.

Each night the day's commits are reviewed for three things only:

1. What was fixed and then had to be fixed again.
2. What should not have merged.
3. What was verified too thinly to support the claim that it was fixed.

A lesson is one sentence, then why, then the evidence (commit, issue, or
session), then `Seen N×` with the dates. Seen counts days, not repeats inside
one day. Also record what was done right, marked `Done right`.

Two speeds:

- **Slow.** Seen on 3 separate days, the lesson moves into
  `docs/rules/code-standards.md` and is deleted from the reading section of
  `LESSONS.md`. The Moved section keeps one line: the rule, the date, the
  file. A later review still checks it, from the standards file. The notebook
  does not grow by accumulation. A miss of a moved rule is a new lesson, not
  a reason to paste the rule back. Project-specific rules stay in
  `docs/rules/`. The files in `docs/` beside that directory are the universal
  mechanism, and a lesson does not graduate into them.
- **Fast.** A miss that shipped broken to a user the same day it was written
  is written into `docs/rules/` that night. It does not wait for 3.

Promotion is not compliance. A promoted rule missed again is recorded under
it, with the commit. Do not delete the miss.

Taste, whether a feature should exist, and which of two designs is better are
not this file's job. Those are the maintainer's, recorded wherever this repo
already records deliberate decisions. A review that finds one reversed leaves
it for the maintainer.

## Nightly review

The schedule is local, not a GitHub cron. It needs the day's commits and a
session long enough to read them. The trigger is recorded in
`docs/agents/loop.md`. Skipped is a missed review, not a quiet day.

The review updates the `reviewed-through` line at the top of `LESSONS.md` to
the last commit it actually read. A review that stops halfway says so.

A bug fix starts by reading `LESSONS.md` for the class, not the sample. A fix
covers every sibling of the pattern. Reproduce the reporter's case on the
surface they use before calling it fixed.

## Acceptance

A change is merged only when the record shows each of these. A check that was
not run is listed as not run, never left out.

1. Put the old code back. The new test fails with a real `FAIL` that names
   the behavior. A compile error or a skip does not count. Restore the change
   and the test passes.
2. Break the code the test guards, on purpose, and the test catches it.
3. A test that fails on the integration branch is a bug to fix now, or an
   issue filed in the same commit. "Fails the same on main" names the sha
   just fetched. It is not a baseline.
4. A platform claim was checked on that platform. A cross-compile is not that
   check.
5. What was not tried against the real system is not built on, and is not
   told to users as working.

Merge only the reviewed head. A push during the review stops the merge.

A release tag waits until that commit's CI finished green. A run cancelled by
the next push is not a pass. Do not tag every commit.

## Sessions

Two sessions never commit from the same checkout. Each works in its own
worktree. After committing, `git show --stat HEAD` lists that session's files
and only those. Before starting a fix another session might be on, say so on
the issue.

## Where this came from

Taken from yetone/magpie as checked on 2026-10-13: a router that holds no
rules, a nightly error notebook, a 3-day promotion into hard rules, and
acceptance that can fail by name. The release cadence was not taken. The
heartbeat is this file plus a trigger that actually runs, not a workflow
file.
