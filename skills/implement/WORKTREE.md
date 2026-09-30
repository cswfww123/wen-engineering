# Worktree isolation (implement §0c, §4)

Default for runs that edit production code: work in a **local worktree** so
concurrent sessions on one repo cannot overwrite each other.

## Setup (run start)

- Record the current branch at run start — it is the **integration branch**.
  Create the worktree from its HEAD; branch name `worktree/<ticket-or-slug>`.
- Local only: never push. Place the worktree **outside** the repo working tree
  (e.g. a sibling directory) so the main checkout stays clean.
- `git worktree list` first: never reuse another session's worktree or branch
  name; suffix `-2` on collision. This run cleans up only what it created.
- Executor briefs carry the **worktree root**; every path in the brief resolves
  against it (see [DISPATCH.md](DISPATCH.md)). If verify needs installed
  dependencies, provision them inside the worktree (e.g. `npm ci`). If the
  environment cannot be provisioned, soft-fail back to the main checkout,
  report the fallback, and flag the concurrent-session collision risk.

## Stay in the main checkout (no worktree) when

- the run is docs/config-only with nothing to verify
- commit is not authorized (an uncommitted delta cannot ride the merge-back)
- the user asked to work in place

## Merge back and clean up (after review weight applied + Done criteria hold)

1. Merge the integration branch **into** the worktree branch first, resolve,
   and re-run verify — a concurrent session may have landed meanwhile.
2. Merge the worktree branch into the integration branch in the main checkout.
   Local merge only: no push, no PR.
3. Then close the ticket (implement §5) — never before the merge lands.
4. Clean up in the same run: `git worktree remove` each worktree this run
   created, then `git branch -D` its branch. Keep other sessions' worktrees and
   branches, `main`/`master`/`test`/`develop`, the current branch, and anything
   on a remote.

After the merge (or commit), `git status` in the main checkout is clean except
files declared unrelated before the commit (e.g. local `.scratch/`). Uncommitted
leftovers of reverted hunks fail Done.
