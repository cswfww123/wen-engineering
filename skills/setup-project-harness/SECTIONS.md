# Setup Sections

Decision trees for each setup section. The orchestrator loads one section at a time when walking the user through decisions.

Each section starts with a short explainer, shows the evidence found, names the recommended default, and asks for the user's decision. Recommend defaults when evidence supports them. Do not ask for decisions the repo already proves unless changing them would be destructive.

## A — Lifecycle Tracker

Explainer: The tracker stores specs, implementation tickets, Wayfinder maps,
and discovery tickets. `/to-spec`, `/to-tickets`, `/wayfinder`, `/implement`,
and `triage` need exact operations, not only a tracker name. Use
[`TRACKER_CONTRACT.md`](TRACKER_CONTRACT.md) as the acceptance contract.

Default posture:

- GitHub if `git remote -v` points at GitHub
- GitLab if it points at GitLab or a self-hosted GitLab
- Local markdown if there is no remote, no issue tracker evidence, or `.scratch/` already exists
- Other if the user describes Jira, Linear, or another workflow

Choices:

- **GitHub** — write `docs/agents/issue-tracker.md` from `issue-tracker-github.md`
- **GitLab** — write it from `issue-tracker-gitlab.md`
- **Local markdown** — write it from `issue-tracker-local.md`
- **Other** — document exact equivalent operations for every item in
  `TRACKER_CONTRACT.md`; a generic paragraph naming the tracker is not enough

Inspect capabilities before drafting:

- base create/read/update/comment/list/reopen/close operations
- deterministic JSON parser used by exhaustive tracker filters
- storage and lookup for all five artifact kinds
- native parent and blocking relationships in the installed CLI/server/tier
- body-field fallback when a native capability is unavailable
- exhaustive implementation, human, and per-map discovery frontier queries
- ticket claim/release identity, idempotent bug-report conversion claims, and
  map-level serialization for Wayfinder
- whether claims are atomic; if not, require serial execution
- QA report publication/read-back and delivered-spec closeout
- legacy PRD/issue discovery without in-place renames

Prefer native relationships only after capability detection and read-back.
Do not ask the user to choose a weaker fallback when repo and platform evidence
already prove the available capability.

## B — Triage Labels

Explainer: The triage skill needs exact label strings for five canonical roles. If the tracker already has labels, map to those strings rather than creating duplicates.

Canonical roles:

- `needs-triage` — maintainer needs to evaluate
- `needs-info` — waiting on reporter
- `ready-for-agent` — fully specified, AFK-ready
- `ready-for-human` — needs human implementation
- `wontfix` — will not be actioned

Default: each role's string equals its name. Ask whether any should be overridden.

## C — Domain Docs

Explainer: Architecture and debugging skills read domain docs so they use the project's language instead of inventing terms. They need to know whether the repo has one global context or multiple contexts.

Choices:

- **Single-context** — one root `CONTEXT.md` plus `docs/adr/`
- **Multi-context** — root `CONTEXT-MAP.md` pointing to per-context `CONTEXT.md` files

Default: single-context unless `CONTEXT-MAP.md`, monorepo structure, or clear bounded contexts suggest multi-context.

## D — Agent Entrypoint

Explainer: Codex and Claude should share one source of truth. This project standard uses `AGENTS.md` as the entrypoint and makes `CLAUDE.md` point to it.

Decide how to handle existing files:

- If neither exists, create `AGENTS.md` and symlink `CLAUDE.md -> AGENTS.md`
- If `AGENTS.md` exists, update it in place and link `CLAUDE.md`
- If `CLAUDE.md` exists as a file, preserve useful content into `AGENTS.md` or `.agents/rules/**`, then replace it with a symlink only after the user accepts the draft
- If `CLAUDE.md` is already the correct symlink, leave it
- If symlinks are unsupported, create a one-line stub that points to `AGENTS.md`

## E — Rule Harness

Explainer: Detailed standards do not belong in `AGENTS.md`. They live under `.agents/rules/` so agents load only the relevant boundaries.

Decide which rule directories apply:

- `project/` — project identity, workflow, dependency policy, verification, and routing persistent multi-slice work to specs/tickets rather than the session todo
- `skills/` — skill authoring/review rules for engineering-skills repos
- `typescript/`, `javascript/`, `java/`, `python/` — language-specific rules
- `frontend/`, `backend/`, `api/`, `database/`, `testing/`, `cli/`, `library/`, `monorepo/` — layer/workflow rules
- `invariants/` — shared mutable state (balance/quota/counter/inventory/state machine). Copy or adapt this repo's `.agents/rules/invariants/` as the reference; it requires an invariant, a concurrency contract, and a concurrency test seam on any matching change

Use [RULE_TEMPLATE.md](RULE_TEMPLATE.md). Use `[MUST]` and `[FORBID]` only for real boundaries; use `[SHOULD]` for defaults where judgment may beat the rule.

## F — Project Commands And Verification

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
