---
name: implement-spec
description: "Implement a specification in code."
disable-model-invocation: true
---

You have been provided a spec. This spec should have tickets associated with it, describing how to implement the spec.

The goal is the entire spec committed on the branch the user is already on. Do not create a branch, do not open a PR, and do not push, unless the user explicitly asked for a PR or a push in this session.

The tickets are not a list of steps. They are a **task graph** with blocking relationships between them. This means there is always a **frontier** of tickets which are ready to be grabbed.

Communication to and from subagents should be sparse. Communicate primarily through **context pointers**: to the spec, tickets, research notes, and previous commits. Don't duplicate information already available via pointers.

**Implementer subagents** should be run in the background where possible for **maximum concurrency**.

## Steps

1. Read the spec and tickets. Read enough to understand the task graph.

2. (optional) Use an **exploration subagent** to conduct any exploration required by the tickets - relevant codebase files or external documentation. Ensure the exploration subagent can save files - it should save its markdown notes in a directory outside the repo, accessible by all future subagents. This lets **implementer subagents** focus on implementation rather than exploration.

3. Record the user's current branch. That branch is the integration branch. Stay on it in the main checkout. Do not create an integration branch. Do not `git push`. Do not open, update, or mark a PR ready.

4. Use **implementer subagents** to implement each ticket. Each implementer subagent works in its own **local** worktree, on its own **local** branch. Those branches must not be pushed to any remote. Name them so cleanup can find them (for example `worktree/<ticket>`).

5. Once an **implementer subagent** completes, merge its work into the current branch with a **merger subagent**. Merge locally only. Then close **that ticket** if its acceptance criteria are met and it has no leftover 残差 / 下张票收口 / partial on a `Covers` SRC. Comment the commit (or merge) link and the verification result, close it, and read it back. A merged ticket that stays open looks undone. Do not close a ticket whose slice is unfinished, and do not close the parent spec here.

6. If this changes the **frontier** of available tickets, kick off more **implementer subagents** to work on the new tickets. This allows for maximum concurrency.

7. Once all tickets are complete, run /code-review on the current branch. Fix all issues raised by the code review in a single **implementer subagent**, then merge that fix back the same way.

8. Commit the finished work on the current branch if it is not already committed. Confirm every finished implementation ticket from this run is **closed** and was read back as closed. Close any that were merged but left open. Leave a ticket open only when its slice is unfinished, and say which. Do not close the parent spec unless every in-scope child is closed and the spec's own closeout rule (`docs/agents/issue-tracker.md`) passes — including prd-walk when this is a PRD-sourced package. A PR or a push happens only when the user explicitly asks.

9. Clean up every worktree and local branch this run created. `git worktree remove` each one, then `git branch -D` its branch. Do not leave them for the user. Do not delete `master`, `test`, `develop`, `main`, the current branch, or any branch you did not create in this run. Do not delete remote branches.
