---
name: setup-project
description: "Configure this repo for the engineering skills: issue tracker, triage labels, domain docs, repo rules, and a thin AGENTS.md that points at them. Also installs the nightly error notebook. Run once, and re-run to thin an AGENTS.md that has grown."
disable-model-invocation: true
---

# Setup Project

Scaffold the per-repo configuration that the engineering skills assume:

- **Issue tracker**: where issues live (GitHub by default; local markdown is also supported out of the box)
- **Triage labels**: the strings used for the five canonical triage roles
- **Domain docs**: where `GLOSSARY.md` and ADRs live, and the consumer rules for reading them
- **Repo rules**: `docs/rules/`, seeded with the PR packet. Same level as `docs/adr/` and `docs/agents/`; one file per rule, read on demand.
- **A thin router**: `AGENTS.md` keeps a pointer per branch. Material only some work needs moves behind that pointer.
- **The closed loop**: `LESSONS.md` plus a nightly review. Repeated misses graduate into `docs/rules/`.
- **Review rules**: `docs/rules/code-standards.md`, the acceptance a review checks against. Seeded. The nightly review appends graduated lessons. It does not rewrite the seed.

Same tracker, labels, and domain scope as upstream `setup-matt-pocock-skills`. The router thinning and the loop are WEN. `CLAUDE.md` is never authored. Where it exists it is a symlink to `AGENTS.md`, and it stays one.

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write. Re-running thins the router again and refreshes pointers. It does not overwrite `docs/rules/pr.md`, `LESSONS.md`, or a lesson already in the notebook.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `git remote -v` and `.git/config`: is this a GitHub repo? Which one?
- `AGENTS.md` and `CLAUDE.md` at the repo root: does either exist? Is there already an `## Agent skills` section in either?
- `GLOSSARY.md` and `GLOSSARY-MAP.md` at the repo root
- `docs/adr/` and any `src/*/docs/adr/` directories
- `docs/agents/`: does this skill's prior output already exist?
- `docs/rules/`: repo-level rules. `docs/rules/pr.md` is this skill's seed.
- `.scratch/`: a sign that a local-markdown issue tracker convention is already in use
- Is the `triage` skill installed? (a `triage` skill folder alongside this one, or `triage` in your available skills.) This decides whether Section B runs at all.
- Monorepo signals: a `pnpm-workspace.yaml`, a `workspaces` field in `package.json`, or a populated `packages/*` with its own `src/`. These are present only in a genuinely large multi-package repo; their absence means single-context, which is almost every repo.
- `LESSONS.md` at the repo root, and `docs/agents/loop.md`: a prior loop install.
- `AGENTS.md` line count and which sections name a branch only some work enters (a CLI, a sibling repo, a checklist, a command list). That is the thinning input. `CLAUDE.md` is noted only to confirm it is a symlink. Do not read it as a second rules file.

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

**Section C: Domain docs.** Default to **single-context** (one `GLOSSARY.md` + `docs/adr/` at the repo root). This fits almost every repo; write it without asking.

Offer **multi-context** (a root `GLOSSARY-MAP.md` pointing to per-context `GLOSSARY.md` files) only when exploration found monorepo signals. Then confirm which layout they want.

**Section D: Router.** Skip the question when `AGENTS.md` is already only pointers plus the `## Agent skills` block. Otherwise ask exactly one question:

> Thin `AGENTS.md` to a router? Material only some work needs moves behind a pointer. Voice, git identity, and anything every turn needs stay. (recommended: **yes**)

On yes, classify each section before drafting. A section every turn needs stays, as a pointer if it is already one. A section only some work needs is disclosed: the body moves to `docs/agents/` or `docs/rules/`, and `AGENTS.md` keeps one line that names the file and the branch that should reach it. The pointer's leading words are the branch, not a description of the file. One line per branch. Collapse two lines that fire on the same work.

Do not disclose a failure the model already repeats in this repo. Those stay as one line each, until the nightly review has seen the same one on 3 days and moved it. Deleting a repeated miss from the always-loaded file is how it comes back.

Show the before/after line count with the draft. Never create `CLAUDE.md`. Never put a rule in it. A symlink to `AGENTS.md` stays a symlink.

**Section E: Closed loop.** Ask exactly one question:

> Install the nightly error notebook? It reviews the day's commits for rework, what should not have merged, and thin verification. A lesson seen on 3 separate days moves into `docs/rules/`. (recommended: **yes**)

On yes, write `LESSONS.md` from [lessons.md](./lessons.md) only when the file is absent. Write `docs/agents/loop.md` from [loop.md](./loop.md); on re-run, refresh it from the seed and keep any trigger line the repo added. Ask for the hour the review should run, in the user's local time. The default is 03:00. Record that hour in `docs/agents/loop.md`. Do not create the schedule yourself — creating it is the host's cron tool, and the skill tells the user the exact prompt to hand the next session so the review actually starts. A file with no trigger is a frozen notebook. Say that.

### 3. Confirm and edit

Show the user a draft of:

- The `## Agent skills` block (including the fixed `### Work routing` sub-block and, when Section E ran, `### Loop`)
- The thinned `AGENTS.md`, when Section D ran, with the line count before and after
- The contents of `docs/agents/issue-tracker.md`, `docs/agents/domain.md`, and `docs/agents/triage-labels.md` (the last only when `triage` is installed)
- `docs/agents/loop.md`, when Section E ran
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
- [code-standards.md](./code-standards.md): the review rules, written to `docs/rules/code-standards.md`

For "other" issue trackers, write `docs/agents/issue-tracker.md` from scratch using the user's description.

Always write `docs/rules/pr.md` from [pr.md](./pr.md) and `docs/rules/code-standards.md` from [code-standards.md](./code-standards.md). `docs/rules/` is the repo-level rules directory, a peer of `docs/adr/` and `docs/agents/`: one rule per file, reached by a pointer, not loaded every turn. On re-run, leave an existing `docs/rules/pr.md` and an existing `docs/rules/code-standards.md` in place. The repo's copy wins over the seed. Graduated lessons append to the repo's copy. They never replace it.

**Author `AGENTS.md` only as a router.** Create it when it is missing: the block below plus one pointer per branch Section D disclosed. When it exists, replace each disclosed section with its pointer line, and insert or update the block in place. Do not append a second copy. Do not invent voice, product rules, or a checklist the repo did not already have. Prose that is not a pointer is still `writing-for-agents`.

**Do not author `CLAUDE.md`.** Do not create it, do not edit it, do not follow it when it is a symlink. A rule written there is a second copy.

```markdown
## Agent skills

### Work routing

Route incoming work yourself; do not ask the user which skill to use. Bug → `/diagnosing-bugs`. Fuzzy product need (worth-doing, market) → stop, needs PM. Clear AC or one slice → `/implement`. Any other requirement, product doc included → `/grill-code`. Enter the chosen skill by reading its `SKILL.md`. Mid-flow hops still wait for the user's order (grill close gate, `/implement` | 「开干」). Full routing: `ask-process/LIFECYCLE.md` in the skills root.

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.

### Domain docs

[one-line summary of layout: "single-context" or "multi-context"]. See `docs/agents/domain.md`.

### Repo rules

Repo-level rules live in `docs/rules/`, one file per rule. Read the matching file before the work it names.

- `docs/rules/pr.md` — writing or updating a PR/MR description.
- `docs/rules/code-standards.md` — reviewing or merging a change. Read it before the review, not instead of the repo's other rules.

### Loop

Read `LESSONS.md` before changing code. The nightly review and the promotion rule are in `docs/agents/loop.md`.
```

Include `### Loop` only when Section E ran. Omit it when the user declined the notebook, so the pointer does not name a file that was not written.

Include the `### Triage labels` sub-block, and write `docs/agents/triage-labels.md`, only when `triage` is installed and Section B ran. When it isn't, both are omitted.

Always include `### Work routing` verbatim. It is a pack rule, not a per-repo choice, so it is not a section to ask about. It is the only always-loaded carrier of agent-owned entry routing in a target repo: the router skill is user-invoked and `LIFECYCLE.md` is reached only through this line.

When `AGENTS.md` was missing and Section D was skipped, still write the block into a new `AGENTS.md`. A repo with no router cannot reach `docs/rules/` or the notebook. Do not write that block into `CLAUDE.md` instead.

### 5. Done

Tell the user the setup is complete and which engineering skills will now read from these files. Mention they can edit `docs/agents/*.md` and `docs/rules/*.md` directly later. A re-run thins the router again and does not overwrite `docs/rules/pr.md` or `LESSONS.md`.

When Section E ran, end with the one prompt that starts the review, using the hour they chose. The prompt tells a session in this repo to read `docs/agents/loop.md`, review commits since the `reviewed-through` line, and write lessons in the shape `LESSONS.md` specifies. Tell them to hand that prompt to the host's scheduled-task tool. Do not create the schedule from this skill. A notebook with no trigger is not installed. Say so if they decline the schedule.
