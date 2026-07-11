# WEN Engineering Skills

Default language: English | [简体中文](README.zh-CN.md)

Skills for real engineering with AI agents.

This repo is for building small, composable skills that help Codex, Claude, and other coding agents do useful engineering work without taking control away from the user.

The goal is not to turn agents into rigid form-fillers. The goal is to build the bridge between:

- what the user actually wants
- what the codebase already proves
- what the agent can infer, question, implement, and verify

Rules are guardrails. Skills are reusable conversations. The agent should stay smart, the user should keep decisive taste and authority, and the codebase should stop drifting every time a different model touches it.

The repo favors small adaptable skills, alignment interviews, shared domain language, feedback loops, and codebase design without making any external style guide the project standard.

## Quickstart

Recommended: clone the repo, sync every WEN skill into `~/.agents/skills`, and link Codex, Claude, ZCode, and Kimi to that shared directory:

```bash
git clone https://github.com/cswfww123/wen-engineering.git
cd wen-engineering
./scripts/sync-skills.sh --agents all
```

This installs all WEN skills without a picker. It also creates a manifest in
`~/.agents/skills` so future syncs can remove deleted repo skills without
touching unrelated user skills, and installs `WEN_THIRD_PARTY_NOTICES.md` beside
the shared skills.

Alternative: use the interactive skills.sh installer when you only want to pick a few skills or install into an agent it supports:

```bash
npx skills@latest add cswfww123/wen-engineering
```

The interactive installer may not support every agent or update/delete workflow. Prefer `scripts/sync-skills.sh` when you want Codex, Claude, ZCode, and Kimi to stay aligned with this repo over time.

Update later with:

```bash
cd wen-engineering
git pull --ff-only
./scripts/sync-skills.sh --agents all
```

By default the sync copies WEN skills into `~/.agents/skills`, then makes each selected agent's skill directory a symlink to that shared directory. Use `--mode link` if you want local edits in this checkout to be visible immediately:

```bash
./scripts/sync-skills.sh --agents all --mode link
```

If you previously installed same-name skills with another tool, the sync may refuse to overwrite them. Inspect first:

```bash
./scripts/sync-skills.sh --agents all --dry-run
```

Then migrate once when you want this repo to manage those skill names or replace existing agent-specific skill directories with shared symlinks:

```bash
./scripts/sync-skills.sh --agents all --force
```

With `--force`, the script imports skills that only existed in an agent-specific directory into `~/.agents/skills`, backs up the old directory as `*.wen-engineering-backup-*`, and replaces it with a symlink.

For a new project, run **`/setup-project-harness`** in the target project after syncing. It will configure:

- the issue tracker workflow: GitHub, GitLab, local markdown, or another tracker
- the five triage roles used by `/to-tickets`, `/implement`, and tracker adapters
- the domain documentation layout: single `CONTEXT.md` or multi-context `CONTEXT-MAP.md`
- `AGENTS.md`, `CLAUDE.md`, `docs/agents/`, and focused `.agents/rules/**`

That is the fast path. After setup, agents know where project instructions live, which rules to load, and which commands prove their work.

### Empty Project Routing

For an empty project, choose `/setup-project-harness` or a short technical grill based on what is already known:

- If the stack or repo shape is known, run `/setup-project-harness` first. It creates the workbench: `AGENTS.md`, `CLAUDE.md`, `docs/agents/`, `.agents/rules/**`, and local scratch space.
- If only a product goal is known and value/user/outcome are still open, run product discovery in the PM workspace (`/pm-intake`) first — not engineering Wayfinder.
- If product intent is settled enough but stack choices are open, run a short `/grill-with-docs` pass for engineering constraints only, then `/setup-project-harness`.
- Once the direction is clear enough to write honest project instructions, switch to `/setup-project-harness`; continue technical grilling after the harness exists.

Rule of thumb: no workbench means setup; open product value means PM; open stack means micro-grill; once there is enough direction to create the workbench, setup immediately and keep refining from there.

In empty repos, the harness must record facts and user decisions only. Leave package manager, framework, build, lint, typecheck, and test commands undefined until scaffold evidence exists.

## Lifecycle

The route follows the shape of the work; it is not a form every request must
complete. This pack stays **coding-light** and **PM-optional**: product discovery
uses whatever process the team has (optional companion `wen-pm`). Work may be
frontend-only, backend-only, or full-stack. See [docs/lifecycle.md](docs/lifecycle.md),
[docs/boundaries.md](docs/boundaries.md), and
[docs/handoff-package.md](docs/handoff-package.md).

### 0. Product Fog → Product Owner (not inventing here)

```text
product / market / need fog -> team's product process (optional /pm-intake)
```

Do not use Wayfinder or `/to-spec` to invent user value or Expected behavior.

### 1. Clear, Bounded Work

```text
bounded task -> /implement
```

Use `/implement` directly when product intent is settled enough and one fresh
context can hold the task and its acceptance boundary. It owns the evidence
loop (TDD for behavior, an exact GREEN baseline for behavior-preserving work),
simplification, project verification, the independent `/code-review` gate, and
completion reporting.

### 2. Settled, Multi-Slice Work (default multi-session path)

```text
settled product package -> /to-spec -> /to-tickets -> /implement
```

Prefer a settled delivery package from any source (optional `wen-pm`, other
PRD, in-repo docs). Scope FE/BE gates to the ticket layer — backend-only does
not need UI pins; frontend-only does not require implementing the API.
See [docs/handoff-package.md](docs/handoff-package.md).
`/to-spec` → `/to-tickets` → `/implement` with developer behavior +
layer-scoped fidelity. System QA is optional companion `wen-test`. Use `/grill-with-docs` for same-session technical
sharpening and `/alignment-review` when intent or slicing is risky.

Optional system QA (`wen-test` `/qa-run`) may publish a confirmed one-context defect as an implementation
ticket. Broader or under-diagnosed defects remain non-runnable `bug-report`
intake with `needs-triage` until explicitly converted or specified and sliced.

### 3. Technical Multi-Session Fog (advanced, rare)

```text
settled product + technical fog -> /wayfinder -> /to-spec -> /to-tickets
```

`/wayfinder` is optional engineering discovery only: multi-session technical
fog (migrations, contracts, seams) after product is settled. One discovery
ticket per session. `/research` and `/prototype` produce bounded evidence only.

### v1.1 Command Migration

`/to-spec` replaces `/to-prd`, and `/to-tickets` replaces `/to-issues`. The old
slash commands are retired, while existing `PRD.md`, `issues/`, links, and
tracker objects remain valid legacy inputs and are never renamed in place.
Sync removes managed copies of the retired commands; an unmarked same-name
canonical skill blocks normal sync, while `--force` backs it up outside the
active skills root before removal.

## Local Workspace

Common skills:

- `/alignment-review` reviews specs, tickets, and test plans for intent, coverage, repo evidence, and execution fit.
- `/codebase-design` provides deep-module vocabulary for module interfaces and seams.
- `/code-review` independently reviews a fixed delta for intent, correctness, ponytail complexity, performance, security, and standards.
- `/diagnosing-bugs` diagnoses hard bugs and performance regressions with a feedback loop.
- `/domain-modeling` sharpens glossary terms and records ADRs while design decisions crystallize.
- `/implement` takes one bounded task or implementation-frontier ticket through the matching evidence loop, simplification, verification, code review, and tracker completion.
- `/grill-with-docs` stress-tests an engineering plan while maintaining glossary and ADR docs.
- `/handoff` writes a compact handoff document for a fresh agent.
- `/improve-codebase-architecture` finds deepening opportunities and writes a visual HTML report.
- `/prototype` creates a disposable logic/state or UI evidence artifact for an explicit question or Wayfinder ticket.
- `/research` saves cited primary-source evidence for an explicit question or Wayfinder ticket.
- `/simplify` cleans up non-trivial changed code for reuse, smaller code, efficiency, and right-depth fixes.
- `/setup-project-harness` initializes a project-level agent harness.
- `/skill-review` reviews a new or changed skill before accepting it.
- `/tdd` guides Red-Green-Refactor implementation through public behavior tests.
- `/to-spec` turns settled context into a non-runnable spec with stable requirements.
- `/to-tickets` turns an approved spec into a dependency-aware ticket graph and typed frontiers.
- `/wayfinder` (advanced) clears multi-session **technical** fog until an honest engineering spec is writable.
- `/writing-great-skills` provides a reference for writing and editing predictable skills.

The harness skill creates:

- `AGENTS.md` as the shared entrypoint and source of truth
- `CLAUDE.md` linked to `AGENTS.md`
- detailed standards under `.agents/rules/`
- rule files split by language or domain, such as `typescript/`, `java/`, `frontend/`, `backend/`, `api/`, `database/`, `testing/`, `invariants/`, or `skills/`

## Why This Exists

AI agents fail in predictable ways.

### #1: The Agent Guessed The Project Boundary

Most projects do not fail because the model cannot write code. They fail because the model does not know the local boundary: which layer owns the logic, which naming convention matters, which command proves success, which tradeoff the team already made.

The fix is a project harness: a small `AGENTS.md` entrypoint plus focused `.agents/rules/**` files that capture the decisions future agents would otherwise rediscover or contradict.

### #2: The User And Agent Did Not Align

Users often know what good feels like before they can state it as a spec. Agents are useful because they can ask, propose, synthesize, and make the implicit explicit.

The fix is an interview-driven setup. The skill reads the repo first, brings recommended defaults when evidence supports them, then grills only the decisions the repo cannot answer.

### #3: Rules Became A Cage

Too many harnesses overcorrect. They replace judgment with checklists and make the agent worse.

The fix is severity-aware rules:

- `[MUST]` for real correctness, consistency, safety, or maintainability boundaries
- `[SHOULD]` for strong defaults where judgment may beat the rule
- `[FORBID]` for known harmful choices

The best rule files prevent predictable drift while leaving room for human taste and agent intelligence.

### #4: The Codebase Lost Its Language

When agents do not share the project's vocabulary, they write verbose explanations, inconsistent names, and awkward abstractions.

The fix is progressive disclosure: keep `AGENTS.md` short, put domain language in `CONTEXT.md`, architectural decisions in `docs/adr/`, and detailed standards in `.agents/rules/**`.

## Skills

### Planning And Alignment

- [`alignment-review`](skills/alignment-review/SKILL.md) — reviews specs, tickets, and test plans for intent, coverage, evidence, and execution fit.
- [`domain-modeling`](skills/domain-modeling/SKILL.md) — sharpens domain language, updates `CONTEXT.md`, and records sparse ADRs as decisions crystallize.
- [`grill-with-docs`](skills/grill-with-docs/SKILL.md) — runs `/grilling` with `/domain-modeling` as the normal plan-sharpening entrypoint.
- [`grilling`](skills/grilling/SKILL.md) — provides the core one-question-at-a-time interview protocol used by grill skills.
- [`wayfinder`](skills/wayfinder/SKILL.md) — advanced technical multi-session discovery until an honest engineering spec is writable.
- [`research`](skills/research/SKILL.md) — saves cited primary-source evidence for an explicit question or active Wayfinder ticket.
- [`prototype`](skills/prototype/SKILL.md) — builds bounded disposable logic/state or UI evidence without mutating tracker or production state.
- [`to-spec`](skills/to-spec/SKILL.md) — turns settled context into a non-runnable spec with stable requirements.
- [`to-tickets`](skills/to-tickets/SKILL.md) — turns an approved spec into a dependency-aware set of one-context tickets.
- [`implement`](skills/implement/SKILL.md) — takes one bounded task or implementation-frontier ticket through testing or compatibility evidence, review, and verification.
- [`tdd`](skills/tdd/SKILL.md) — guides implementation through vertical Red-Green-Refactor cycles and public behavior tests.
- [`handoff`](skills/handoff/SKILL.md) — writes a compact handoff document for a fresh agent, saved outside the repo.

### Review And Quality

- [`code-review`](skills/code-review/SKILL.md) — reviews diffs for intent, bugs, ponytail complexity, performance, security, and standards.
- [`diagnosing-bugs`](skills/diagnosing-bugs/SKILL.md) — diagnoses bugs and performance regressions by building a feedback loop before changing code.
- [`simplify`](skills/simplify/SKILL.md) — cleans up non-trivial changed code for reuse, smaller code, efficiency, and right-depth fixes.

### Architecture

- [`codebase-design`](skills/codebase-design/SKILL.md) — provides deep-module vocabulary for module interfaces, seams, adapters, leverage, and locality.
- [`improve-codebase-architecture`](skills/improve-codebase-architecture/SKILL.md) — scans a codebase for deepening opportunities and writes a visual HTML report.

### Engineering Harness

- [`setup-project-harness`](skills/setup-project-harness/SKILL.md) — builds a minimal, evidence-first project harness for Codex and Claude. Use it for frontend, backend, full-stack, library, CLI, monorepo, empty starter, or engineering-skills repositories.
- [`skill-review`](skills/skill-review/SKILL.md) — reviews skills for discovery, trigger clarity, progressive disclosure, and judgment-preserving guidance.
- [`writing-great-skills`](skills/writing-great-skills/SKILL.md) — provides vocabulary and principles for writing predictable skills.

## Skill Design Principles

- Small beats comprehensive.
- Instructions should create better collaboration, not remove autonomy.
- Read repo evidence before asking questions.
- Ask only where user intent or taste is decisive.
- Prefer progressive disclosure over one giant prompt.
- Capture boundaries in rules, not generic advice.
- Make verification part of the workflow.
- Preserve model judgment wherever divergence is not dangerous.
- Choose user-invoked skills for orchestration and side effects; choose model-invoked skills for reusable disciplines.

## Repository Layout

```text
README.md
README.zh-CN.md
THIRD_PARTY_NOTICES.md
AGENTS.md
CLAUDE.md -> AGENTS.md
.agents/
  rules/
    project/
      agent-workflow.md
    skills/
      authoring.md
      review.md
    invariants/
      invariants.md
docs/
  invocation.md
  adr/
    0001-skill-composition.md
    0002-invariants-rule.md
    0003-skill-invocation-boundaries.md
    0004-wen-lifecycle.md
  agents/
    domain.md
    issue-tracker.md
    triage-labels.md
  lifecycle.md
  boundaries.md
  handoff-package.md
scripts/
  sync-skills.sh
  test-sync-skills.sh
skills/
  alignment-review/
    CHECKLIST.md
    SKILL.md
  code-review/
    AGENT-BRIEFS.md
    PROJECT-LENSES.md
    REVIEW-AXES.md
    SKILL.md
  codebase-design/
    DEEPENING.md
    DESIGN-IT-TWICE.md
    SKILL.md
  diagnosing-bugs/
    ATTRIBUTION.md
    SKILL.md
    scripts/
      hitl-loop.template.sh
  domain-modeling/
    ADR-FORMAT.md
    CONTEXT-FORMAT.md
    SKILL.md
  grill-with-docs/
    SKILL.md
  grilling/
    SKILL.md
  handoff/
    SKILL.md
  implement/
    SKILL.md
  improve-codebase-architecture/
    HTML-REPORT.md
    SKILL.md
  prototype/
    LOGIC.md
    SKILL.md
    UI.md
  research/
    SKILL.md
  setup-project-harness/
    AGENTS_TEMPLATE.md
    HARNESS_FLOW.md
    RULE_TEMPLATE.md
    SECTIONS.md
    SKILL.md
    TRACKER_CONTRACT.md
    domain.md
    issue-tracker-github.md
    issue-tracker-gitlab.md
    issue-tracker-local.md
    triage-labels.md
  simplify/
    SKILL.md
  skill-review/
    SKILL.md
  tdd/
    SKILL.md
    mocking.md
    refactoring.md
    tests.md
  to-spec/
    SKILL.md
    TEMPLATE.md
  to-tickets/
    EXPAND-CONTRACT.md
    SKILL.md
    TEMPLATE.md
  wayfinder/
    SKILL.md
    TEMPLATES.md
  writing-great-skills/
    GLOSSARY.md
    SKILL.md
```

## Current Focus

This repo currently focuses on a **lightweight, evidence-first coding lifecycle**:

- initialize a trustworthy project harness and shared agent entrypoint
- stay PM-optional; accept delivery inputs from any settled product source
- support frontend-only, backend-only, and full-stack layer scope
- default multi-session coding path: settled intent → `/to-spec` → `/to-tickets` → `/implement`
- system test/QA via optional companion `wen-test`
- optional technical `/wayfinder` only for multi-session engineering fog
- preserve intent in non-runnable specs and traceable ticket DAGs
- implement one isolated implementation-frontier ticket through the right evidence loop, simplification, review, and verification
- use research and prototypes as bounded **engineering** evidence
- leave system test design/QA to optional companion `wen-test`
- keep Codex, Claude, ZCode, and Kimi aligned through `~/.agents/skills`

The design stays tracker-neutral and context-aware: small work stays small;
product fog leaves this pack; technical large work earns durable artifacts and
fresh execution contexts.

## Upstream Attribution

WEN adapts lifecycle and skill-design ideas from
[Matt Pocock's Skills for Real Engineers v1.1.0](https://github.com/mattpocock/skills/tree/v1.1.0),
then extends them with WEN's harness, tracker, review, verification, and
multi-agent contracts. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for
the exact source revision, adaptation notes, and MIT license.

## Contributing Skills

A skill should be:

- concise enough to load quickly
- specific enough to trigger correctly
- flexible enough to preserve agent judgment
- structured enough that repeated use produces consistent artifacts

Prefer:

- one `SKILL.md` for the core workflow
- reference files for templates or rarely needed detail
- scripts only for deterministic repeated operations

Avoid:

- generic best-practice dumps
- rules that restate normal LLM competence
- fixed defaults that should be discovered from the repo or decided by the user
- giant prompts that make every task pay for every possible context

Exception: strict setup/init skills are process specifications. They may be longer when completeness prevents broken initialization.

## Philosophy

Real engineering with agents is a feedback loop:

```text
read the codebase -> align with the user -> define the boundary -> change in small slices -> verify -> improve the harness
```

The best skills do not own the process. They make the process easier to steer.
