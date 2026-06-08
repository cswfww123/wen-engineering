---
name: setup-project-harness
description: Strictly set up AGENTS.md, CLAUDE.md, docs/agents, and .agents/rules for Codex or Claude projects.
disable-model-invocation: true
---

# Setup Project Harness

Scaffold the per-repo configuration that engineering agents assume.

This skill is the strict initialization surface. It uses an evidence-first setup pattern for project harness rules across Codex and Claude.

It is prompt-driven, not a deterministic script. Explore, present findings, walk the user through decisions one at a time, confirm the draft, then write.

Do not optimize this skill for line count. Its job is to be complete and reliable.

## What It Sets Up

- **Issue tracker** — where issues, PRDs, and triage workflows live
- **Triage labels** — the five canonical triage roles mapped to this repo's vocabulary
- **Domain docs** — how agents read `CONTEXT.md`, `CONTEXT-MAP.md`, and ADRs
- **Agent entrypoint** — `AGENTS.md` as the project source of truth
- **Claude compatibility** — `CLAUDE.md` points to `AGENTS.md`
- **Rule harness** — focused `.agents/rules/**` files for project, language, layer, and workflow boundaries

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; do not assume.

Read the issue-tracker and documentation setup surface:

- `git remote -v` and `.git/config` — is this GitHub, GitLab, self-hosted, or no remote?
- `AGENTS.md` and `CLAUDE.md` — does either exist, and does either already contain an `## Agent skills` section?
- `CONTEXT.md` and `CONTEXT-MAP.md`
- `docs/adr/` and any `src/*/docs/adr/`
- `docs/agents/` — does prior setup output already exist?
- `.scratch/` — sign that local markdown issue tracking is already in use

Read the harness surface:

- `README.md`, docs, CI, formatter/linter configs, package manifests, lockfiles, build files
- source roots and project shape: frontend, backend, full-stack, library, CLI, monorepo, empty starter, or engineering-skills repo
- languages, frameworks, package manager, and install/dev/build/lint/typecheck/test commands
- route/API layers, schema/migration layers, database access, generated code, deployment config
- existing AI instructions: `.agents/rules/`, `.claude/rules/`, `.cursor/rules/`, `.cursorrules`, `.github/copilot-instructions.md`, `.windsurfrules`, `.clinerules`
- existing style from code or skills: naming, formatting, imports, typing, errors, prompts, references, scripts

Summarize what is present, missing, and ambiguous before asking decisions.

### 2. Present Findings And Ask

Walk the user through the decisions one section at a time. Do not dump all sections at once.

Each section starts with a short explainer, shows the evidence you found, names the recommended default, and asks for the user's decision. Recommend defaults when evidence supports them. Do not ask for decisions the repo already proves unless changing them would be destructive.

#### Section A — Issue Tracker

Explainer: The issue tracker is where issues and PRDs live. Skills like `to-issues`, `triage`, and `to-prd` need to know whether to call `gh`, `glab`, write local markdown, or follow another workflow.

Default posture:

- GitHub if `git remote -v` points at GitHub
- GitLab if it points at GitLab or a self-hosted GitLab
- Local markdown if there is no remote, no issue tracker evidence, or `.scratch/` already exists
- Other if the user describes Jira, Linear, or another workflow

Choices:

- **GitHub** — write `docs/agents/issue-tracker.md` from `issue-tracker-github.md`
- **GitLab** — write it from `issue-tracker-gitlab.md`
- **Local markdown** — write it from `issue-tracker-local.md`
- **Other** — write it from the user's paragraph

#### Section B — Triage Labels

Explainer: The triage skill needs exact label strings for five canonical roles. If the tracker already has labels, map to those strings rather than creating duplicates.

Canonical roles:

- `needs-triage` — maintainer needs to evaluate
- `needs-info` — waiting on reporter
- `ready-for-agent` — fully specified, AFK-ready
- `ready-for-human` — needs human implementation
- `wontfix` — will not be actioned

Default: each role's string equals its name. Ask whether any should be overridden.

#### Section C — Domain Docs

Explainer: Architecture and debugging skills read domain docs so they use the project's language instead of inventing terms. They need to know whether the repo has one global context or multiple contexts.

Choices:

- **Single-context** — one root `CONTEXT.md` plus `docs/adr/`
- **Multi-context** — root `CONTEXT-MAP.md` pointing to per-context `CONTEXT.md` files

Default: single-context unless `CONTEXT-MAP.md`, monorepo structure, or clear bounded contexts suggest multi-context.

#### Section D — Agent Entrypoint

Explainer: Codex and Claude should share one source of truth. This project standard uses `AGENTS.md` as the entrypoint and makes `CLAUDE.md` point to it.

Decide how to handle existing files:

- If neither exists, create `AGENTS.md` and symlink `CLAUDE.md -> AGENTS.md`
- If `AGENTS.md` exists, update it in place and link `CLAUDE.md`
- If `CLAUDE.md` exists as a file, preserve useful content into `AGENTS.md` or `.agents/rules/**`, then replace it with a symlink only after the user accepts the draft
- If `CLAUDE.md` is already the correct symlink, leave it
- If symlinks are unsupported, create a one-line stub that points to `AGENTS.md`

#### Section E — Rule Harness

Explainer: Detailed standards do not belong in `AGENTS.md`. They live under `.agents/rules/` so agents load only the relevant boundaries.

Decide which rule directories apply:

- `project/` — project identity, workflow, dependency policy, verification
- `skills/` — skill authoring/review rules for engineering-skills repos
- `typescript/`, `javascript/`, `java/`, `python/` — language-specific rules
- `frontend/`, `backend/`, `api/`, `database/`, `testing/`, `cli/`, `library/`, `monorepo/` — layer/workflow rules

Use [RULE_TEMPLATE.md](RULE_TEMPLATE.md). Use `[MUST]` and `[FORBID]` only for real boundaries; use `[SHOULD]` for defaults where judgment may beat the rule.

#### Section F — Project Commands And Verification

Explainer: Agents need exact commands that prove work is correct. Only record commands found in repo evidence or supplied by the user.

Confirm:

- install command
- dev command
- build command
- lint command
- typecheck command
- test command
- single-test command
- known missing commands

Do not invent commands from package manager conventions alone. If commands are missing, record that they are missing.

### 3. Confirm Draft

Show the user a draft before writing.

Include:

- `AGENTS.md` content based on [AGENTS_TEMPLATE.md](AGENTS_TEMPLATE.md)
- the `## Agent skills` block that will be included in `AGENTS.md`
- `.agents/rules/` tree and new/changed rule file contents
- `docs/agents/issue-tracker.md`
- `docs/agents/triage-labels.md`
- `docs/agents/domain.md`
- how existing `AGENTS.md`, `CLAUDE.md`, and prior rule/docs files will be merged, preserved, or replaced

Let the user edit the draft. Do not silently overwrite surrounding user-authored sections.

### 4. Write

Write `docs/agents/`:

- `issue-tracker.md` from the chosen issue tracker template, or from the user's "Other" workflow
- `triage-labels.md` from `triage-labels.md`, edited with the selected label strings
- `domain.md` from `domain.md`, edited for single-context or multi-context layout

Write `AGENTS.md`:

- keep it under 150 lines where practical
- include project overview, core directives, exact commands, rule index, engineering practices, reference files
- include an `## Agent skills` block with issue tracker, triage label, and domain docs summaries
- link to `docs/agents/*.md` and `.agents/rules/**`
- do not duplicate detailed rule content from `.agents/rules/**`

Write `.agents/rules/**`:

- create only directories that apply
- use [RULE_TEMPLATE.md](RULE_TEMPLATE.md)
- include source evidence or user decision
- include verification when a rule can be checked
- create strict rules for style, API, database, testing, and skills only when those areas apply

Write `CLAUDE.md`:

- symlink to `AGENTS.md` when possible
- otherwise write a one-line pointer to `AGENTS.md`
- never maintain divergent core instructions

### 5. Verify

Run all applicable checks:

- `test -f AGENTS.md`
- `test -L CLAUDE.md && readlink CLAUDE.md`, or inspect the stub if symlinks are unsupported
- `test -f docs/agents/issue-tracker.md`
- `test -f docs/agents/triage-labels.md`
- `test -f docs/agents/domain.md`
- `find .agents/rules -maxdepth 3 -type f`
- exact lint/typecheck/test/build commands recorded for the repo, if any

Do not validate this setup skill by `SKILL.md` line count. Completeness beats brevity for this initialization surface.

### 6. Done

Report:

- changed files
- detected project shape and stack
- issue tracker choice
- triage labels
- domain doc layout
- rule directories created
- verification evidence
- remaining open decisions

Mention that users can edit `docs/agents/*.md`, `.agents/rules/**`, and `AGENTS.md` directly later. Re-run this skill only when switching trackers, changing domain layout, or reinitializing the harness.
