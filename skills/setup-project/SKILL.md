---
name: setup-project
description: "Configure this repo in the magpie layout: CLAUDE.md injects AGENTS.md and LESSONS.md, AGENTS.md only routes, and the universal loop docs live in docs/. Project-specific rules stay in docs/rules/. Re-run moves leftover AGENTS.md body behind pointers."
disable-model-invocation: true
---

# Setup Project

Two layers, and they do not compete. Magpie is the agent tuning itself: the notebook, the nightly review, the promotion into hard rules. Matt is the human-led build: grill, spec, tickets, implement, the person deciding what gets built. A line that serves one layer is not a duplicate of a line that serves the other. Do not delete either to make the file smaller.

Scaffold the per-repo configuration that the engineering skills assume:

- **Issue tracker**: where issues live (GitHub by default; local markdown is also supported out of the box)
- **Triage labels**: the strings used for the five canonical triage roles
- **Domain docs**: where `GLOSSARY.md` and ADRs live, and the consumer rules for reading them
- **The magpie layout**, the same files in the same places. Universal mechanism is seeded. A project-specific rule is not.

| File | What it is |
| --- | --- |
| `CLAUDE.md` | `@AGENTS.md` and `@LESSONS.md`. Nothing else. |
| `AGENTS.md` | A router. No product description, no stack version, no procedure. |
| `LESSONS.md` | The error notebook. Empty until a miss is recorded. |
| `docs/contributors.md` | Harm checks before any community run. |
| `docs/release.md` | No tag until that commit's CI finished green. |
| `docs/nightly-review.md` | The heartbeat. What the night looks for, and the two speeds. |
| `docs/decisions.md` | What the notebook does not decide. The maintainer's table starts empty. |
| `docs/loops.md` | Build, review, release. |
| `docs/subsystems/README.md` | Empty until the first subsystem has a behavior an agent would re-derive wrong. |

Project-specific, and the only place a repo's own rules go:

- `docs/rules/`, seeded with the PR packet and `docs/rules/code-standards.md`. Language, layers, and review teeth live here, not in the layout above. A graduated lesson appends here.

Same tracker, labels, and domain scope as upstream `setup-matt-pocock-skills`. The layout matches wen-loop, which was checked against yetone/magpie on 2026-10-13. Do not seed `docs/imported-lessons.md` or `docs/provenance.md`. Those are evidence about magpie, not a mechanism a target repo runs.

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

**Section D: Router.** Do not skip this because a previous run already added pointers. Pointers sitting above an unmoved body are the failure this section exists to fix. Ask exactly one question, including on a re-run:

> Move `AGENTS.md` down to a router? A line stays only when deleting it would make a turn wrong before any branch is entered. Everything else moves behind a pointer, body included. (recommended: **yes**)

On yes, classify every section, then show the draft. The completion criterion is the move list, not the line count: each moved section names its old heading, its new file, and the one pointer that replaces it. A section with no destination was not classified. Do not write until the user accepts that list.

A line stays only when both are true: it changes what the model does on a turn that has not entered a branch, and no other file already says it. Voice the user set (a form of address) stays. A product description does not stay: it is a cache of `GLOSSARY.md` or the build file, and the two copies drift. A stack version in `pom.xml` or `package.json` does not stay. A procedure for one kind of work does not stay, even when that work is common.

A repeated miss does not stay either. Move its body into `LESSONS.md` as a lesson with `Seen 1×` and today's date, and leave one pointer. The notebook is read before any code change, so the miss is in context on the turn that can repeat it. Keeping the paragraph in `AGENTS.md` because it might be skipped is how the router grows back.

A section only some work needs is disclosed. The body moves to `docs/agents/` or `docs/rules/`. `AGENTS.md` keeps one line: the branch first, then the file. One trigger per branch. Two lines that fire on the same work collapse. A body that already exists in the destination is not copied again. The pointer replaces it.

Show the line count before and after with the move list. Never create `CLAUDE.md`. Never put a rule in it. A symlink to `AGENTS.md` stays a symlink. Do not follow it as a second rules file.

**Section E: Closed loop.** Ask exactly one question:

> Install the nightly error notebook? It reviews the day's commits for rework, what should not have merged, and thin verification. A lesson seen on 3 separate days moves into `docs/rules/`. (recommended: **yes**)

On yes, write `LESSONS.md` from [lessons.md](./lessons.md) only when the file is absent. A re-run appends lessons Section D moved and does not rewrite lessons already there. Write `docs/agents/loop.md` from [loop.md](./loop.md); on re-run, refresh it from the seed, keep the repo's trigger line, and keep the import line. Ask for the hour the review should run, in the user's local time. The default is 03:00. Record that hour in `docs/agents/loop.md`. Do not create the schedule yourself — creating it is the host's cron tool, and the skill tells the user the exact prompt to hand the next session so the review actually starts. A file with no trigger is a frozen notebook. Say that.

### 3. Confirm and edit

Show the user a draft of:

- The router table plus the `## Agent skills` block, including `### Issue tracker`, `### Triage labels`, and `### Domain docs`.
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
- [contributors.md](./contributors.md), [release.md](./release.md), [nightly-review.md](./nightly-review.md), [decisions.md](./decisions.md), [loops.md](./loops.md): the universal loop, written to the same names under `docs/`
- [subsystems.md](./subsystems.md): written to `docs/subsystems/README.md`

For "other" issue trackers, write `docs/agents/issue-tracker.md` from scratch using the user's description.

Always write `docs/rules/pr.md` from [pr.md](./pr.md) and `docs/rules/code-standards.md` from [code-standards.md](./code-standards.md). On re-run, leave an existing copy of either in place. The repo's copy wins over the seed. Graduated lessons append to `docs/rules/code-standards.md`. They never replace it.

Always write the universal loop from the seeds, to the same paths: `docs/contributors.md`, `docs/release.md`, `docs/nightly-review.md`, `docs/decisions.md`, `docs/loops.md`, `docs/subsystems/README.md`. On re-run, refresh each from the seed except `docs/decisions.md`: keep every dated row the repo added, and do not wipe an empty table into a sentence. Record the nightly hour in `docs/nightly-review.md`, not in a second file.

**Write `CLAUDE.md` as the two injection lines and nothing else**, from this seed, replacing whatever is there including a symlink:

```markdown
@AGENTS.md
@LESSONS.md
```

A rule, a product description, or a third line in that file is a second copy. Delete it.

**Author `AGENTS.md` only as a router.** The table below is the whole universal part. Create the file when it is missing. When it exists, this table replaces any earlier loop pointers, and Section D's move list replaces leftover body. Do not append a second copy. A product description does not survive into the new file. Voice the user set stays as one line above the table. Prose that is not a pointer is still `writing-for-agents`.

```markdown
# Agent

This file holds two layers. The table is the agent tuning itself. `## Agent skills` is the human-led build. Neither replaces the other.

Before doing a kind of work, read the file it points at.

| Before you | Read |
| --- | --- |
| Change any code | `LESSONS.md` |
| Write or review a change | `docs/rules/code-standards.md` |
| Change a documented subsystem | its page under `docs/subsystems/`, and check every source link still resolves |
| Review a community PR or issue | `docs/contributors.md` — harm checks come before any run |
| Cut a release or a tag | `docs/release.md` |
| Run the nightly review | `docs/nightly-review.md` |
| Decide whether to build something, or which of two designs | `docs/decisions.md` — do not invent the call |
| Write or update a PR description | `docs/rules/pr.md` |
| Use a domain term or an ADR | `docs/agents/domain.md` |

A rule lives in exactly one place. A lesson seen on 3 separate days moves into `docs/rules/code-standards.md` and leaves the reading section of `LESSONS.md`. Do not copy a rule here to make it easier to find.

Two sessions never commit from the same checkout. Each session works in its own worktree. After committing, `git show --stat HEAD` lists that session's files and only those.

## Agent skills

The human decides what gets built and when a slice starts. These pointers are how that work is routed. They are not a second copy of the table above.

### Work routing

Route incoming work yourself; do not ask the user which skill to use. Bug → `/diagnosing-bugs`. Fuzzy product need (worth-doing, market) → stop, needs PM. Clear AC or one slice → `/implement`. Any other requirement, product doc included → `/grill-code`. Enter the chosen skill by reading its `SKILL.md`. Mid-flow hops still wait for the user's order (grill close gate, `/implement` | 「开干」). Full routing: `ask-process/LIFECYCLE.md` in the skills root.

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.

### Domain docs

[one-line summary of layout: "single-context" or "multi-context"]. See `docs/agents/domain.md`.
```

`## Agent skills` stays. It is the engineering-skills block, not a duplicate of the router table. The table does not point at the issue tracker, the triage labels, or the domain docs. Those three live only here, one line each, because the skills read them by this heading.

Keep `### Work routing` verbatim. Include `### Triage labels`, and write `docs/agents/triage-labels.md`, only when `triage` is installed and Section B ran. When it is not, omit that sub-block. On a re-run, update this block in place. Do not add a second one, and do not add a `### Loop` sub-block. Delete `docs/agents/loop.md` if an earlier run wrote it. The heartbeat is `docs/nightly-review.md`.

### 5. Done

Tell the user the setup is complete and which engineering skills will now read from these files. Mention they can edit `docs/agents/*.md` and `docs/rules/*.md` directly later. A re-run thins the router again and does not overwrite `docs/rules/pr.md` or `LESSONS.md`.

When Section E ran, end with the one prompt that starts the review, using the hour they chose. The prompt tells a session in this repo to read `docs/agents/loop.md`, review commits since the `reviewed-through` line, and write lessons in the shape `LESSONS.md` specifies. Tell them to hand that prompt to the host's scheduled-task tool. Do not create the schedule from this skill. A notebook with no trigger is not installed. Say so if they decline the schedule.
