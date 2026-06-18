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

Recommended: clone the repo and synchronize every skill into Codex and Claude:

```bash
git clone https://github.com/cswfww123/wen-engineering.git
cd wen-engineering
./scripts/sync-skills.sh --agents codex,claude
```

This installs all skills without a picker. It also creates a manifest in each target skill directory so future syncs can remove skills that were deleted from this repo without touching unrelated user skills.

Alternative: use the interactive skills.sh installer when you only want to pick a few skills or install into an agent it supports:

```bash
npx skills@latest add cswfww123/wen-engineering
```

The interactive installer may not support every agent or update/delete workflow. Prefer `scripts/sync-skills.sh` when you want Codex and Claude to stay aligned with this repo over time.

Update later with:

```bash
cd wen-engineering
git pull --ff-only
./scripts/sync-skills.sh --agents codex,claude
```

By default the sync copies files into `~/.codex/skills` and `~/.claude/skills`. Use `--mode link` if you want local edits in this checkout to be visible immediately:

```bash
./scripts/sync-skills.sh --agents codex,claude --mode link
```

If you previously installed same-name skills with another tool, the sync may refuse to overwrite them. Inspect first:

```bash
./scripts/sync-skills.sh --agents codex,claude --dry-run
```

Then migrate once when you want this repo to manage those skill names:

```bash
./scripts/sync-skills.sh --agents codex,claude --force
```

If Codex shows duplicate WEN skills after migration, you likely still have an older shared install in `~/.agents/skills`. Migrate Claude and archive those old shared copies in one step:

```bash
./scripts/sync-skills.sh --agents codex,claude --force --archive-legacy-agents
```

This moves same-name WEN skills from `~/.agents/skills` into a timestamped `.wen-engineering-legacy-*` backup directory after Codex and Claude have been synced.

For a new project, run **`/setup-project-harness`** in the target project after syncing. It will configure:

- the issue tracker workflow: GitHub, GitLab, local markdown, or another tracker
- the five triage labels used by `/triage`, `/to-issues`, and `/to-prd`
- the domain documentation layout: single `CONTEXT.md` or multi-context `CONTEXT-MAP.md`
- `AGENTS.md`, `CLAUDE.md`, `docs/agents/`, and focused `.agents/rules/**`

That is the fast path. After setup, agents know where project instructions live, which rules to load, and which commands prove their work.

### Empty Project Routing

For an empty project, choose `/setup-project-harness` or `/grill-with-docs` based on what is already known:

- If the stack or repo shape is known, run `/setup-project-harness` first. It creates the workbench: `AGENTS.md`, `CLAUDE.md`, `docs/agents/`, `.agents/rules/**`, and local scratch space.
- If you only have a goal and the stack is unclear, run a short `/grill-with-docs` pass first. Resolve only enough to know the project type, target user, core constraints, and which stack choices are still open.
- Once the direction is clear enough to write honest project instructions, switch to `/setup-project-harness`; continue grilling product, architecture, or stack details after the harness exists.

Rule of thumb: no workbench means setup; no direction means micro-grill; once there is enough direction to create the workbench, setup immediately and keep refining from there.

In empty repos, the harness must record facts and user decisions only. Leave package manager, framework, build, lint, typecheck, and test commands undefined until scaffold evidence exists.

## Local Workspace

Common skills:

- `/ask-wen` recommends the smallest useful WEN skill flow for the situation.
- `/alignment-review` reviews PRDs, issues, and test plans for intent, requirement coverage, repo evidence, and execution fit.
- `/codebase-design` provides deep-module vocabulary for module interfaces and seams.
- `/code-review` reviews diffs for standards, correctness, performance, security, and shape.
- `/deep-code-trace` recursively traces an entry point through internal calls for deep code analysis.
- `/diagnosing-bugs` diagnoses hard bugs and performance regressions with a feedback loop.
- `/domain-modeling` sharpens glossary terms and records ADRs while design decisions crystallize.
- `/do-issues` works through ready AFK vertical-slice issues one at a time.
- `/grill-with-docs` stress-tests a plan while maintaining glossary and ADR docs.
- `/handoff` writes a compact handoff document for a fresh agent.
- `/improve-codebase-architecture` finds deepening opportunities and writes a visual HTML report.
- `/prototype` builds a throwaway logic/state or UI prototype to answer one design question.
- `/qa-run` executes planned QA cases, records evidence, judges completion, and files durable bug issues.
- `/security-review` threat-models and audits a feature or service for system-level security risks.
- `/setup-project-harness` initializes a project-level agent harness.
- `/ship` judges release readiness and drafts version, release notes, and rollback plan.
- `/skill-review` reviews a new or changed skill before accepting it.
- `/tdd` guides Red-Green-Refactor implementation through public behavior tests.
- `/to-issues` breaks a PRD or plan into tracer-bullet vertical-slice issues.
- `/to-prd` turns settled discussion into a PRD for the configured issue tracker.
- `/to-test-plan` creates traceable test plans and test cases from PRDs and issues.
- `/write-a-skill` creates or improves skills with progressive disclosure.
- `/zoom-out` maps relevant modules and callers using the project's domain language.

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

- [`ask-wen`](skills/ask-wen/SKILL.md) — recommends the smallest useful WEN skill flow for the situation.
- [`alignment-review`](skills/alignment-review/SKILL.md) — reviews PRDs, issues, and test plans for intent, requirement coverage, repo evidence, and execution fit.
- [`handoff`](skills/handoff/SKILL.md) — writes a compact handoff document for a fresh agent, saved outside the repo.
- [`context-resume`](skills/context-resume/SKILL.md) — bootstraps a fresh agent session by reading existing project artifacts (CONTEXT.md, issues, PRDs, git history). Use when resuming after rate limits or switching agents.
- [`domain-modeling`](skills/domain-modeling/SKILL.md) — sharpens domain language, updates `CONTEXT.md`, and records sparse ADRs as decisions crystallize.
- [`grill-with-docs`](skills/grill-with-docs/SKILL.md) — runs `/grilling` with `/domain-modeling` as the normal plan-sharpening entrypoint.
- [`grilling`](skills/grilling/SKILL.md) — provides the core one-question-at-a-time interview protocol used by grill skills.
- [`to-prd`](skills/to-prd/SKILL.md) — turns settled discussion and repo evidence into a PRD on the configured issue tracker.
- [`to-issues`](skills/to-issues/SKILL.md) — breaks a PRD, plan, or spec into independently grabbable vertical-slice issues.
- [`to-test-plan`](skills/to-test-plan/SKILL.md) — creates traceable test plans and cases from PRDs and issues.
- [`do-issues`](skills/do-issues/SKILL.md) — works through ready AFK vertical-slice issues one at a time with verification.
- [`prototype`](skills/prototype/SKILL.md) — builds a throwaway logic/state or UI prototype to answer one design question.
- [`tdd`](skills/tdd/SKILL.md) — guides implementation through vertical Red-Green-Refactor cycles and public behavior tests.
- [`write-a-skill`](skills/write-a-skill/SKILL.md) — creates or improves skills with clear triggers, short instructions, and one-level references.
- [`zoom-out`](skills/zoom-out/SKILL.md) — maps relevant modules and callers using the project's domain language.

### Review And Quality

- [`code-review`](skills/code-review/SKILL.md) — reviews diffs for standards, correctness, performance, security, and shape.
- [`deep-code-trace`](skills/deep-code-trace/SKILL.md) — traces an entry point through internal calls for deep code analysis, debugging, reviews, or risky edits.
- [`diagnosing-bugs`](skills/diagnosing-bugs/SKILL.md) — diagnoses bugs and performance regressions by building a feedback loop before changing code.
- [`qa-run`](skills/qa-run/SKILL.md) — executes planned QA cases, records evidence, judges completion, and files durable bug issues.
- [`security-review`](skills/security-review/SKILL.md) — system-level threat model and audit of a service or feature; complements code-review's diff-level axis.

### Release And Delivery

- [`ship`](skills/ship/SKILL.md) — judges release readiness and drafts the next version, release notes, and rollback plan; the release gate consumes evidence from code-review, qa-run, and security-review.

### Architecture

- [`codebase-design`](skills/codebase-design/SKILL.md) — provides deep-module vocabulary for module interfaces, seams, adapters, leverage, and locality.
- [`improve-codebase-architecture`](skills/improve-codebase-architecture/SKILL.md) — scans a codebase for deepening opportunities and writes a visual HTML report.

### Engineering Harness

- [`setup-project-harness`](skills/setup-project-harness/SKILL.md) — builds a minimal, evidence-first project harness for Codex and Claude. Use it for frontend, backend, full-stack, library, CLI, monorepo, empty starter, or engineering-skills repositories.
- [`skill-review`](skills/skill-review/SKILL.md) — reviews skills for discovery, trigger clarity, progressive disclosure, and judgment-preserving guidance.

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
  agents/
    domain.md
    issue-tracker.md
    triage-labels.md
scripts/
  sync-skills.sh
skills/
  ask-wen/
    SKILL.md
  alignment-review/
    SKILL.md
    CHECKLIST.md
  codebase-design/
    SKILL.md
    DEEPENING.md
    DESIGN-IT-TWICE.md
  code-review/
    AGENT-BRIEFS.md
    SKILL.md
    PROJECT-LENSES.md
    REVIEW-AXES.md
  deep-code-trace/
    EXAMPLES.md
    SKILL.md
  diagnosing-bugs/
    SKILL.md
    ATTRIBUTION.md
    scripts/
      hitl-loop.template.sh
  domain-modeling/
    SKILL.md
    ADR-FORMAT.md
    CONTEXT-FORMAT.md
  do-issues/
    SKILL.md
  grill-with-docs/
    SKILL.md
  grilling/
    SKILL.md
  handoff/
    SKILL.md
  improve-codebase-architecture/
    SKILL.md
    HTML-REPORT.md
  prototype/
    SKILL.md
    LOGIC.md
    UI.md
  qa-run/
    SKILL.md
    TEMPLATES.md
  security-review/
    SKILL.md
  ship/
    SKILL.md
  skill-review/
    SKILL.md
  tdd/
    SKILL.md
    mocking.md
    refactoring.md
    tests.md
  to-issues/
    SKILL.md
  to-prd/
    SKILL.md
  to-test-plan/
    SKILL.md
    TEMPLATES.md
  write-a-skill/
    SKILL.md
    QUALITY.md
  zoom-out/
    SKILL.md
  setup-project-harness/
    SKILL.md
    HARNESS_FLOW.md
    SECTIONS.md
    AGENTS_TEMPLATE.md
    RULE_TEMPLATE.md
    domain.md
    issue-tracker-github.md
    issue-tracker-gitlab.md
    issue-tracker-local.md
    triage-labels.md
```

## Current Focus

This repo currently focuses on project initialization and harness engineering:

- identifying the project shape and stack
- establishing a shared agent entrypoint
- organizing standards under `.agents/rules/`
- keeping Codex and Claude aligned through one source of truth
- helping the user and LLM define boundaries together
- sharpening early plans through one-session interviews before implementation work starts

Future skills can cover narrower project types, such as frontend apps, backend services, libraries, CLIs, monorepos, and skills-authoring workflows.

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
