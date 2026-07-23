# Harness Flow

Operational checklist for `/setup-project-harness`. Read this after the start
gate in `SKILL.md`.

## Explore

Look at the current repo before recommending anything. Read what exists; do not
infer facts from conventions alone.

### Infrastructure

- `git remote -v` and `.git/config`: GitHub, GitLab, self-hosted, or no remote
- `AGENTS.md` and `CLAUDE.md`: existence, content, and symlink status
- `CONTEXT.md` and `CONTEXT-MAP.md`
- `docs/adr/` and context-scoped ADR folders such as `src/*/docs/adr/`
- `docs/agents/`: prior setup output
- `.scratch/`: local markdown issue tracking signal
- installed tracker CLI version and relevant help output
- deterministic JSON parser availability (`jq` or a documented equivalent)
- native parent/dependency capability, server/tier limits, and body fallback
- claim identity and whether the tracker provides atomic claiming

### Code Shape

- `README.md`, docs, CI, formatter/linter configs, manifests, lockfiles, build files
- source roots and repo shape: frontend, backend, full-stack, library, CLI, monorepo, empty starter, or engineering-skills repo
- languages, frameworks, package manager, workspace layout
- install, dev, build, lint, typecheck, test, and single-test commands found in repo evidence
- route/API layers, schema/migration layers, database access, generated code, deployment config
- behavior hidden behind real call paths that requires tracing before becoming a rule
- **Observability bar:** full / thin / partial from project shape; note existing
  logger, correlation, sinks, how-to-read if any. Foundation build is
  `/setup-logging`, not this skill — [OBSERVABILITY.md](OBSERVABILITY.md).

### Existing AI Instructions

- `.agents/rules/`, `.claude/rules/`, `.cursor/rules/`, `.cursorrules`
- `.github/copilot-instructions.md`, `.windsurfrules`, `.clinerules`
- existing style from code or skills: naming, formatting, imports, typing, errors, prompts, references, scripts

## Exploration Summary

Present this before decisions:

```markdown
## Exploration Summary

### Infrastructure
- Remote: <GitHub / GitLab / none / other>
- Existing AGENTS.md: <yes, N lines / no>
- Existing CLAUDE.md: <symlink to AGENTS.md / standalone file / no>
- Existing docs/agents/: <list files / none>
- Existing .scratch/: <yes / no>
- Tracker lifecycle support: <native relationships / body fallback / unknown>
- Claim guarantee: <atomic / advisory / serial-only>

### Code Shape
- Project type: <frontend / backend / full-stack / library / CLI / monorepo / empty>
- Languages: <list>
- Frameworks: <list>
- Commands found: <list exact commands>
- Commands missing: <list>
- Observability bar: <full / thin / n/a> — evidence: <logger, correlation, sinks, how-to-read>
- Foundation status: <present / partial / missing>

### Existing AI Instructions
- Found: <list files and patterns>
- Not found: <platforms checked with no config>
```

## Draft

Draft all artifacts before writing:

- `AGENTS.md` content from `AGENTS_TEMPLATE.md`
- the `## Agent Skills` block for `AGENTS.md`
- `.agents/rules/` tree and new or changed rule file contents
- `docs/agents/issue-tracker.md`
- `docs/agents/triage-labels.md`
- `docs/agents/domain.md`
- observability handoff note when bar is **full** and status is partial/missing
  (recommend `/setup-logging`; do not draft logger modules in this skill)
- preservation, merge, or replacement plan for existing files
- tracker capability choice and proof that every operation in `TRACKER_CONTRACT.md` is covered

On **full** bar + **missing/partial** foundation: harness done report must
**name the `/setup-logging` handoff**. Do not claim the repo is agent-ready for
integration-heavy AFK work until foundation is present or the user explicitly
defers it. Pointer: [OBSERVABILITY.md](OBSERVABILITY.md).

Show the full draft and merge plan. Do not silently overwrite surrounding
user-authored sections.

## Write

### `docs/agents/`

- Write `issue-tracker.md` from the chosen tracker template. For "Other",
  document exact equivalent operations for every item in `TRACKER_CONTRACT.md`.
- Record native parent/block capabilities only when the installed CLI,
  server/tier, permissions, and read-back support them; otherwise record the
  parseable body-field fallback.
- State the real claim guarantee. Local Markdown claims are advisory unless the
  repo supplies atomic locking.
- Write `triage-labels.md` from `triage-labels.md`, editing only the selected label strings.
- Write `domain.md` from `domain.md`, edited for single-context or multi-context layout.

### `AGENTS.md`

- Path Wiring + optional Checklist only (see `AGENTS_TEMPLATE.md`). Prefer under ~15 lines.
- Include: one-line identity, non-inferable path pointers. Omit Route, Commands, Rules, Mistakes essays.
- Checklist only for real failure pins; omit when empty; prune when current models stop tripping.
- Do not paste generic best practices or a long References list.

### `.agents/rules/**`

- Default: create **nothing**. Most competence is model-default.
- Add a rule file only for a concrete failure that cannot fit a one-line Checklist
  (e.g. shared mutable invariants with a long classifier). Prefer Checklist first.
- Use `RULE_TEMPLATE.md` when a file is justified. Include source evidence (postmortem).
- Do not invent workflow constitutions, LIGHT/HEAVY routers, or generic best-practice dumps.

### `CLAUDE.md`

- Symlink to `AGENTS.md` when possible.
- Otherwise write a one-line pointer to `AGENTS.md`.
- Never maintain divergent core instructions.

## Verify

Run all applicable checks:

```bash
test -f AGENTS.md
test -L CLAUDE.md && readlink CLAUDE.md
test -f docs/agents/issue-tracker.md
test -f docs/agents/triage-labels.md
test -f docs/agents/domain.md
find .agents/rules -maxdepth 3 -type f
```

Then verify `docs/agents/issue-tracker.md` covers:

- create/read/update/comment/list/reopen/close
- spec, implementation-ticket, Wayfinder-map, Wayfinder-ticket, and non-runnable
  bug-report storage plus claimed, exact-`Origin`, read-back
  conversion/supersession
- parent, blocking, implementation/human/discovery frontiers, ticket and map
  claims, release, and resolution operations
- QA evidence publication and delivered-spec closeout
- native capability detection plus body fallback
- legacy PRD/issue discovery

If symlinks are unsupported, inspect the `CLAUDE.md` pointer instead of the
symlink check. Also run the exact lint, typecheck, test, or build commands
recorded for the repo, when they exist.

## Done Report

Report:

- changed files
- detected project shape and stack
- issue tracker choice
- triage labels
- domain doc layout
- observability bar + foundation status (and `/setup-logging` handoff if needed)
- Checklist pins / any rare rule files created
- verification evidence
- remaining open decisions

Mention that users can later edit `docs/agents/*.md` and `AGENTS.md` Checklist
directly. Re-run this skill only when switching trackers, changing domain layout,
or reinitializing the harness. Logging foundation upgrades use `/setup-logging`.
