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

## E — Failure Pins (Checklist first)

Explainer: Do not build a rules constitution. Prefer a short Checklist item in
`AGENTS.md` after a real failure; prune when current models stop tripping.
Create `.agents/rules/**` only when a pin needs a long classifier that cannot
fit one checklist line.

Default: **no** rule directories.

Only when evidence justifies (postmortem / repeated failure):

- `invariants/` — shared mutable state (balance/quota/counter/inventory/state machine).
  Copy or adapt this repo's `.agents/rules/invariants/` as the reference; it requires
  an invariant, a concurrency contract, and a concurrency test seam on matching change.
- Language/layer rule files — only after a concrete, recurring drift risk in this repo;
  never generic best practices the model already knows.

Use [RULE_TEMPLATE.md](RULE_TEMPLATE.md) when a file is justified. Prefer Checklist
over rule files. Do not invent project workflow routers or skill pipelines as rules.

## F — Observability Foundation

Explainer: Production evidence is often write-once (webhooks, async jobs,
third-party calls, state machines). Without a logging foundation and a later
habit of decision-boundary logs, many production issues are forensically
unsolvable. Setup must classify the bar and **build foundation before** treating
integration-heavy repos as agent-ready. Full contract:
[OBSERVABILITY.md](OBSERVABILITY.md) and pack
`skills/code-review/FORENSIC-OBSERVABILITY.md` when present.

Default posture from evidence:

- **Full bar** — HTTP API, workers/jobs, MQ, webhooks/callbacks, multi-tenant,
  third-party SDKs, durable state machines
- **Thin bar** — pure library / pure functions / no production I/O side effects
- **Partial foundation** — logger exists but missing correlation, sinks, or
  how-to-read

Decide with the user only when bar or vendor choice is ambiguous. Otherwise:

1. If **full** and **missing/partial** → draft and implement **minimum foundation**
   first (unified logger API, levels/sinks, correlation ids, redaction, documented
   how to read logs). Prefer stack-native tools already in the repo.
2. Pin **fail-open** in rules or Checklist when the codebase has a history of
   log calls that can break business: logging must never fail or gate domain work.
3. Do **not** dump "log everything" essays into `AGENTS.md`. Optional one-line
   Checklist after real quiet-path failures; detail in `.agents/rules/**` or docs.
4. If **thin** → record `observability: n/a` / thin in the done report; skip foundation build.

## G — Project Commands And Verification

Explainer: Exact prove-work commands belong in README / scripts / CI, not in
always-loaded `AGENTS.md`. Only record what repo evidence or the user supplies.

Confirm (write to README or harness notes, not AGENTS unless non-inferable):

- install command
- dev command
- build command
- lint command
- typecheck command
- test command
- single-test command
- known missing commands

Do not invent commands from package manager conventions alone. If commands are missing, record that they are missing.
