---
name: setup-project-harness
description: Strictly set up AGENTS.md, CLAUDE.md, and docs/agents for Codex or Claude projects.
disable-model-invocation: true
---

# Setup Project Harness

Build the smallest useful per-repo harness for Codex and Claude.

This is an evidence-first initializer, not a script. Explore the repo, recommend
defaults, ask only for user-owned or destructive decisions, draft everything,
then write after the user accepts the draft.

## Output Contract

Create or update only the harness files the repo actually needs:

- `AGENTS.md` as the shared project instruction entrypoint (wiring + optional failure Checklist)
- `CLAUDE.md` as a symlink to `AGENTS.md`, or a one-line pointer when symlinks are unavailable
- `docs/agents/issue-tracker.md`
- `docs/agents/triage-labels.md`
- `docs/agents/domain.md`
- logging **foundation** artifacts the project shape requires (config, correlation, how-to-read) — see [OBSERVABILITY.md](OBSERVABILITY.md)
- `.agents/rules/**` only when a real failure needs more than a Checklist line

Do not add rule directories, commands, dependencies, abstractions, or docs that
repo evidence or a user decision does not justify.

## Start Gate

Before exploring, check whether the harness already exists:

```bash
test -f AGENTS.md
test -f docs/agents/issue-tracker.md
test -f docs/agents/triage-labels.md
```

If all three exist, report what is already configured and ask whether to update
in place or reinitialize. Never silently overwrite user-authored content.

## Operating Rules

- Prefer small, boring, reversible changes.
- Read repo evidence before asking. Ask only when the repo cannot answer.
- Record exact commands in README / scripts / CI when proven; do not dump defaults into `AGENTS.md`.
- Keep `AGENTS.md` short: path Wiring + optional failure Checklist only (see `AGENTS_TEMPLATE.md`).
- Checklist pins depreciate: add after a real failure; remove when current models stop tripping.
- Do not paste generic best practices into `AGENTS.md` or rules; models already do those.
- Prefer Checklist over rule files; create `.agents/rules/**` only when a failure needs a long classifier.
- Use `[MUST]` and `[FORBID]` sparingly; prefer `[SHOULD]` when judgment may win.
- Trace real call paths before encoding behavior that depends on them.
- Treat deterministic lifecycle enforcement as CI, hook, or platform work; do not rely on memory text for it.

## Workflow

1. **Explore** - follow [HARNESS_FLOW.md](HARNESS_FLOW.md) for the exploration checklist. Use parallel sub-agents when available; otherwise explore sequentially.
2. **Summarize** - present the exploration summary before decisions.
3. **Decide** - use [SECTIONS.md](SECTIONS.md), one section at a time. Recommend defaults and skip questions repo evidence already answers.
4. **Draft** - prepare all target file contents before writing. Use [AGENTS_TEMPLATE.md](AGENTS_TEMPLATE.md), [RULE_TEMPLATE.md](RULE_TEMPLATE.md), [TRACKER_CONTRACT.md](TRACKER_CONTRACT.md), and the tracker/domain templates.
5. **Confirm** - show the complete draft and merge plan. Let the user edit it before writing.
6. **Write** - preserve useful existing content, make the smallest file changes, and keep `CLAUDE.md` aligned with `AGENTS.md`.
7. **Verify** - run the harness checks and any exact repo commands from README / scripts / user.
8. **Report** - list changed files, decisions, verification evidence, and remaining open questions.

## References

Load only the reference needed for the current step:

- [HARNESS_FLOW.md](HARNESS_FLOW.md) - exploration, draft, write, verify, and done checklists
- [SECTIONS.md](SECTIONS.md) - issue tracker, labels, domain docs, entrypoint, rules, observability, and command decisions
- [OBSERVABILITY.md](OBSERVABILITY.md) - logging foundation gate for setup (points at pack forensic contract)
- [TRACKER_CONTRACT.md](TRACKER_CONTRACT.md) - required lifecycle operations, capability fallback, typed frontiers, and claim semantics
- [AGENTS_TEMPLATE.md](AGENTS_TEMPLATE.md) - concise generated `AGENTS.md` shape
- [RULE_TEMPLATE.md](RULE_TEMPLATE.md) - `.agents/rules/**` file shape
- `issue-tracker-github.md`, `issue-tracker-gitlab.md`, `issue-tracker-local.md` - tracker docs templates
- `triage-labels.md` - canonical label mapping template
- `domain.md` - domain-doc consumption template

## Done

The skill is complete when the repo has a verified shared entrypoint, a tracker
adapter that satisfies `TRACKER_CONTRACT.md`, triage-label mapping, domain-doc
contract, **logging foundation at the bar required by project shape** (or an
explicit thin/n/a classification), only the rule files it needs, and no
unexplained overwrite of existing instructions.
