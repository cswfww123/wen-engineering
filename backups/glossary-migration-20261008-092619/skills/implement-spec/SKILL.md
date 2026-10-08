---
name: implement-spec
description: "Implement a specification in code: run its ticket graph with parallel Executors, then accept, review, merge, and close each ticket."
disable-model-invocation: true
---

You have been provided a spec. This spec should have tickets associated with it, describing how to implement the spec.

The goal is the entire spec committed on the branch the user is already on. Do not create a branch, do not open a PR, and do not push, unless the user explicitly asked for a PR or a push in this session.

The tickets are not a list of steps. They are a **task graph** with blocking relationships between them. This means there is always a **frontier** of tickets which are ready to be grabbed.

Each ticket runs the `/implement` protocol; this skill adds the graph, concurrency, and package close. Load `/implement` [SKILL.md](../implement/SKILL.md) and [DISPATCH.md](../implement/DISPATCH.md) once. **The parent plans and accepts every ticket; Executors only type** — they are usually weaker models that execute the brief literally.

## Steps

1. **Map the graph.** Read the spec and tickets: blocking edges, `Covers`, the spec's Testing Decisions, and each ticket's Behavior gate / pin rows.

2. **Record once.** Current branch = integration branch (stay on it in the main checkout; no integration branch, no push, no PR) and its HEAD = run start. Intent (`/implement` §0): product baseline path, design source paths, accepted `相对 PRD` deltas. Confirmed test seams = the spec's Testing Decisions + each ticket's Behavior gate; ask the user only for a ticket that names none.

3. (optional) **Explore** with an exploration subagent. It saves notes in a directory outside the repo. The parent reads them to write briefs; Executors do not.

4. **Brief each frontier ticket** — `/implement` §1 plan, written as the DISPATCH **Implementation brief**. Paste the decision-critical text (AC with literal values, Covered pin rows, test names + expected values, walkthrough table); point to the spec only as extra. One ticket per brief.

5. **Dispatch in parallel** — each Executor in its own local worktree `worktree/<ticket>`, never pushed. Run tickets concurrently only when their **Edit only** lists are disjoint; overlapping tickets queue.

6. **Per returned ticket, in order:**
   1. `/implement` §3 **Accept**. A failed check → new brief with the failure; after 2 rejections the parent takes the ticket over or leaves it `blocked`.
   2. Commit in the worktree.
   3. `/code-review` **Pick weight** for this ticket's diff (`none` or `light`; a ticket that is itself `full`-sized gets `full`). Verdict not `Pass` → Fix-list brief, then Accept again.
   4. **Merge** — the parent, serially, one ticket at a time, per [WORKTREE.md](../implement/WORKTREE.md).
   5. **Close** that ticket per `/implement` §6: comment result + evidence + commit link, close, read back. Unfinished ticket stays open. The spec itself waits for step 9.

7. **Recompute the frontier** after each close and brief the newly unblocked tickets (back to step 4).

8. **Branch review.** All tickets closed → `/code-review` `full` on the integration branch since the run start. Fix eligible findings only — code-review **Fix eligibility** owns which never auto-fix; those route to the user — via one Fix-list brief, then Accept, commit, merge the same way.

9. **Close the package.** Confirm every finished ticket reads back `closed`; close any merged-but-open one; name any left open and why. PRD- or design-pin-sourced package → prd-walk ([PRD-AUTHORITY.md](../to-spec/PRD-AUTHORITY.md) §5, pin rows included). Every in-scope child closed and no `缺` → set the parent spec `delivered` by the tracker's closeout sequence (`docs/agents/issue-tracker.md`) and read it back; otherwise say what holds it open. PR or push only on explicit ask.

10. **Clean up** every worktree and local branch this run created: `git worktree remove`, then `git branch -D`. Keep `master`, `main`, `test`, `develop`, the current branch, other sessions' worktrees/branches, and every remote branch.
