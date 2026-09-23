---
name: setup-project
description: "Configure this repo for the engineering skills: set up its issue tracker, triage label vocabulary, domain doc layout, and repo-level rules. Run once before first use of the other engineering skills."
disable-model-invocation: true
---

# Setup Project

Scaffold the per-repo configuration that the engineering skills assume:

- **Issue tracker**: where issues live (GitHub by default; local markdown is also supported out of the box)
- **Triage labels**: the strings used for the five canonical triage roles
- **Domain docs**: where `CONTEXT.md` and ADRs live, and the consumer rules for reading them
- **Repo rules**: `docs/rules/`, seeded with the PR packet. Same level as `docs/adr/` and `docs/agents/`; one file per rule, read on demand.

Same scope as upstream `setup-matt-pocock-skills`. It does **not** rewrite `AGENTS.md` / `CLAUDE.md`. Those files are user-authored; when their prose needs writing or editing, use `writing-for-agents`.

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `git remote -v` and `.git/config`: is this a GitHub repo? Which one?
- `AGENTS.md` and `CLAUDE.md` at the repo root: does either exist? Is there already an `## Agent skills` section in either?
- `CONTEXT.md` and `CONTEXT-MAP.md` at the repo root
- `docs/adr/` and any `src/*/docs/adr/` directories
- `docs/agents/`: does this skill's prior output already exist?
- `docs/rules/`: repo-level rules. `docs/rules/pr.md` is this skill's seed.
- `.scratch/`: a sign that a local-markdown issue tracker convention is already in use
- Is the `triage` skill installed? (a `triage` skill folder alongside this one, or `triage` in your available skills.) This decides whether Section B runs at all.
- Monorepo signals: a `pnpm-workspace.yaml`, a `workspaces` field in `package.json`, or a populated `packages/*` with its own `src/`. These are present only in a genuinely large multi-package repo; their absence means single-context, which is almost every repo.

### 2. Present findings and ask

Summarise what's present and what's missing. Then take the sections in order. One section, one answer, then the next.

Lead each section with the recommended answer so the user can accept it in a word. Give a one-line explainer only when the choice genuinely branches; skip the section entirely when exploration already settled it (Section B when `triage` isn't installed, Section C when there's no monorepo).

**Section A: Issue tracker.**

> Explainer: The "issue tracker" is where issues live for this repo. Skills like `to-tickets`, `triage`, and `to-spec` read from and write to it. They need to know whether to call `gh issue create`, write a markdown file under `.scratch/`, or follow some other workflow you describe. Pick the place you actually track work for this repo.

Default posture: these skills were designed for GitHub. If a `git remote` points at GitHub, propose that. If a `git remote` points at GitLab (`gitlab.com` or a self-hosted host), propose GitLab. Otherwise (or if the user prefers), offer:

- **GitHub**: issues live in the repo's GitHub Issues (uses the `gh` CLI)
- **GitLab**: issues live in the repo's GitLab Issues (uses the [`glab`](https://gitlab.com/gitlab-org/cli) CLI)
- **Local markdown**: issues live as files under `.scratch/<feature>/` in this repo (good for solo projects or repos without a remote)
- **Other** (Jira, Linear, etc.): ask the user to describe the workflow in one paragraph; the skill will record it as freeform prose

Record the choice in `docs/agents/issue-tracker.md`. The GitHub and GitLab templates carry a "PRs as a request surface" flag, defaulted **off**. Leave it off and don't raise it: a user who wants external PRs in the triage queue can flip the flag in the file later.

**Section B: Triage label vocabulary.** Skip this section entirely if the `triage` skill isn't installed (exploration told you), since an uninstalled skill needs no labels.

If it is installed, ask exactly one question:

> Do you want to keep the default triage labels? (recommended: **yes**)

The defaults are the five canonical roles, each label string equal to its name: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. On **yes**, write them as-is. Only if the user says no, usually because their tracker already uses other names (e.g. `bug:triage` for `needs-triage`), collect the overrides so `triage` applies existing labels instead of creating duplicates.

**Section C: Domain docs.** Default to **single-context** (one `CONTEXT.md` + `docs/adr/` at the repo root). This fits almost every repo; write it without asking.

Offer **multi-context** (a root `CONTEXT-MAP.md` pointing to per-context `CONTEXT.md` files) only when exploration found monorepo signals. Then confirm which layout they want.

### 3. Confirm and edit

Show the user a draft of:

- The `## Agent skills` block, only when a root `AGENTS.md` or `CLAUDE.md` already exists (see step 4)
- The contents of `docs/agents/issue-tracker.md`, `docs/agents/domain.md`, and `docs/agents/triage-labels.md` (the last only when `triage` is installed)
- `docs/rules/pr.md`, copied from the seed. Show it with the other drafts; it is a repo rule, not a per-repo choice, so it is not a section to ask about.

Let them edit before writing.

### 4. Write

Write the docs files using the seed templates in this skill folder as a starting point:

- [issue-tracker-github.md](./issue-tracker-github.md): GitHub issue tracker
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md): GitLab issue tracker
- [issue-tracker-local.md](./issue-tracker-local.md): local-markdown issue tracker
- [triage-labels.md](./triage-labels.md): label mapping (only if `triage` is installed)
- [domain.md](./domain.md): domain doc consumer rules + layout
- [pr.md](./pr.md): the PR packet, written to `docs/rules/pr.md`

For "other" issue trackers, write `docs/agents/issue-tracker.md` from scratch using the user's description.

Always write `docs/rules/pr.md` from [pr.md](./pr.md). `docs/rules/` is the repo-level rules directory, a peer of `docs/adr/` and `docs/agents/`: one rule per file, reached by a pointer, not loaded every turn. On re-run, leave an existing `docs/rules/pr.md` in place; the repo's copy wins over the seed.

**Do not author `AGENTS.md` or `CLAUDE.md`.** Do not create either file. Do not replace, reformat, or rewrite sections outside `## Agent skills`. Body prose is the user's; when they want that prose written or revised, use `writing-for-agents`.

If `AGENTS.md` or `CLAUDE.md` already exists, insert or update **only** this block in place. Prefer the file that already has an `## Agent skills` heading; if neither does, edit `AGENTS.md` when it exists, otherwise `CLAUDE.md`. If an `## Agent skills` block already exists, update its contents in-place rather than appending a duplicate.

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.

### Domain docs

[one-line summary of layout: "single-context" or "multi-context"]. See `docs/agents/domain.md`.

### Repo rules

Repo-level rules live in `docs/rules/`, one file per rule. Read the matching file before the work it names.

- `docs/rules/pr.md` — writing or updating a PR/MR description.
```

Include the `### Triage labels` sub-block, and write `docs/agents/triage-labels.md`, only when `triage` is installed and Section B ran. When it isn't, both are omitted.

If neither root file exists, stop after the `docs/agents/` and `docs/rules/` files. Tell the user to add the block themselves, or to write the file with `writing-for-agents`. The PR rule still needs its pointer: without the block above, nothing reaches `docs/rules/pr.md`.

### 5. Done

Tell the user the setup is complete and which engineering skills will now read from these files. Mention they can edit `docs/agents/*.md` and `docs/rules/*.md` directly later; re-running this skill is only necessary if they want to switch issue trackers or restart from scratch. A re-run does not overwrite `docs/rules/pr.md`. If `AGENTS.md` / `CLAUDE.md` still needs prose, point at `writing-for-agents` — do not draft that prose here.
