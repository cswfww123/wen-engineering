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

## Idempotency Check

Before starting exploration, check whether setup has already been done:

```
test -f AGENTS.md
test -f docs/agents/issue-tracker.md
test -f docs/agents/triage-labels.md
```

If all three exist:

- report what is already set up
- ask whether to reinitialize completely or update in place
- skip sections that are already complete unless the user wants to change them
- never silently overwrite existing user-authored content

## Phase 1: Explore

Look at the current repo to understand its starting state. Read whatever exists; do not assume.

When sub-agents are available, launch three parallel explorations. Otherwise explore sequentially in this order.

### Exploration A: Infrastructure

- `git remote -v` and `.git/config` — GitHub, GitLab, self-hosted, or no remote?
- `AGENTS.md` and `CLAUDE.md` — does either exist? Is `CLAUDE.md` a symlink?
- `CONTEXT.md` and `CONTEXT-MAP.md`
- `docs/adr/` and any `src/*/docs/adr/`
- `docs/agents/` — does prior setup output already exist?
- `.scratch/` — sign that local markdown issue tracking is already in use

### Exploration B: Code Shape

- `README.md`, docs, CI, formatter/linter configs, package manifests, lockfiles, build files
- source roots and project shape: frontend, backend, full-stack, library, CLI, monorepo, empty starter, or engineering-skills repo
- languages, frameworks, package manager
- install/dev/build/lint/typecheck/test commands — only from repo evidence, never invented
- route/API layers, schema/migration layers, database access, generated code, deployment config

### Exploration C: Existing AI Instructions

- `.agents/rules/`, `.claude/rules/`, `.cursor/rules/`, `.cursorrules`
- `.github/copilot-instructions.md`, `.windsurfrules`, `.clinerules`
- existing style from code or skills: naming, formatting, imports, typing, errors, prompts, references, scripts

### Exploration Summary

After all explorations complete, produce a structured summary:

```markdown
## Exploration Summary

### Infrastructure
- Remote: <GitHub / GitLab / none>
- Existing AGENTS.md: <yes, N lines / no>
- Existing CLAUDE.md: <symlink to AGENTS.md / standalone file / no>
- Existing docs/agents/: <list files / none>
- Existing .scratch/: <yes / no>

### Code Shape
- Project type: <frontend / backend / full-stack / library / CLI / monorepo / empty>
- Languages: <list>
- Frameworks: <list>
- Commands found: <list with exact commands>
- Commands missing: <list>

### Existing AI Instructions
- Found: <list files and patterns>
- Not found: <list platforms with no config>
```

Present this summary to the user before proceeding to decisions.

## Phase 2: Decide

Walk the user through setup decisions one section at a time. Do not dump all sections at once.

See [SECTIONS.md](SECTIONS.md) for the decision tree for each section. Load only the section being discussed.

Sections in order:

1. **A — Issue Tracker** (determines which template to use)
2. **B — Triage Labels** (depends on tracker choice)
3. **C — Domain Docs** (independent)
4. **D — Agent Entrypoint** (independent)
5. **E — Rule Harness** (depends on code shape from exploration)
6. **F — Project Commands** (depends on code shape from exploration)

## Phase 3: Draft And Confirm

Based on all decisions, draft all artifacts before writing:

- `AGENTS.md` content from [AGENTS_TEMPLATE.md](AGENTS_TEMPLATE.md)
- the `## Agent skills` block for `AGENTS.md`
- `.agents/rules/` tree and new/changed rule file contents
- `docs/agents/issue-tracker.md`
- `docs/agents/triage-labels.md`
- `docs/agents/domain.md`
- how existing files will be merged, preserved, or replaced

Show the complete draft to the user. Let the user edit before writing. Do not silently overwrite surrounding user-authored sections.

## Phase 4: Write

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

Write `CLAUDE.md`:

- symlink to `AGENTS.md` when possible
- otherwise write a one-line pointer to `AGENTS.md`
- never maintain divergent core instructions

## Phase 5: Verify

Run all applicable checks:

- `test -f AGENTS.md`
- `test -L CLAUDE.md && readlink CLAUDE.md`, or inspect the stub if symlinks are unsupported
- `test -f docs/agents/issue-tracker.md`
- `test -f docs/agents/triage-labels.md`
- `test -f docs/agents/domain.md`
- `find .agents/rules -maxdepth 3 -type f`
- exact lint/typecheck/test/build commands recorded for the repo, if any

## Done

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
