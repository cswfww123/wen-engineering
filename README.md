# WEN Engineering Skills

Skills for real engineering with AI agents.

This repo is for building small, composable skills that help Codex, Claude, and other coding agents do useful engineering work without taking control away from the user.

The goal is not to turn agents into rigid form-fillers. The goal is to build the bridge between:

- what the user actually wants
- what the codebase already proves
- what the agent can infer, question, implement, and verify

Rules are guardrails. Skills are reusable conversations. The agent should stay smart, the user should keep decisive taste and authority, and the codebase should stop drifting every time a different model touches it.

The repo favors small adaptable skills, alignment interviews, shared domain language, feedback loops, and codebase design without making any external style guide the project standard.

## Quickstart (30-second setup)

Install these skills into Codex, Claude, or another supported coding agent with the skills.sh installer:

```bash
npx skills@latest add cswfww123/wen-engineering
```

When prompted, pick the skills you want and the coding agents you want to install them on. For a new project, select **`/setup-project-harness`**.

Then run `/setup-project-harness` in the target project. It will configure:

- the issue tracker workflow: GitHub, GitLab, local markdown, or another tracker
- the five triage labels used by `/triage`, `/to-issues`, and `/to-prd`
- the domain documentation layout: single `CONTEXT.md` or multi-context `CONTEXT-MAP.md`
- `AGENTS.md`, `CLAUDE.md`, `docs/agents/`, and focused `.agents/rules/**`

That is the fast path. After setup, agents know where project instructions live, which rules to load, and which commands prove their work.

## Local Workspace

Common skills:

- `/codebase-design` provides deep-module vocabulary for module interfaces and seams.
- `/code-review` reviews local diffs or PRs for completion, regressions, performance, and safety.
- `/domain-modeling` sharpens glossary terms and records ADRs while design decisions crystallize.
- `/do-grill` selects and completes one focused grill topic from `/grill-prep` docs.
- `/do-issues` works through ready AFK vertical-slice issues one at a time.
- `/finish-grill` synthesizes completed grill topics into a PRD source.
- `/grilling` stress-tests a plan one question at a time with recommended answers.
- `/grill-prep` prepares a broad idea with a light grill, splits topics, and writes scoped thread briefs.
- `/handoff` writes a compact handoff document for a fresh agent.
- `/improve-codebase-architecture` finds deepening opportunities and writes a visual HTML report.
- `/setup-project-harness` initializes a project-level agent harness.
- `/skill-review` reviews a new or changed skill before accepting it.
- `/start-grill` starts grill work and routes between direct grilling and persistent prep docs.
- `/tdd` guides Red-Green-Refactor implementation through public behavior tests.
- `/to-issues` breaks a PRD or plan into tracer-bullet vertical-slice issues.
- `/to-prd` turns settled discussion into a PRD for the configured issue tracker.
- `/write-a-skill` creates or improves skills with progressive disclosure.

The harness skill creates:

- `AGENTS.md` as the shared entrypoint and source of truth
- `CLAUDE.md` linked to `AGENTS.md`
- detailed standards under `.agents/rules/`
- rule files split by language or domain, such as `typescript/`, `java/`, `frontend/`, `backend/`, `api/`, `database/`, `testing/`, or `skills/`

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

- [`handoff`](skills/handoff/SKILL.md) — writes a compact handoff document for a fresh agent, saved outside the repo.
- [`domain-modeling`](skills/domain-modeling/SKILL.md) — sharpens domain language, updates `CONTEXT.md`, and records sparse ADRs as decisions crystallize.
- [`do-grill`](skills/do-grill/SKILL.md) — selects one highest-priority unfinished grill topic, completes that scoped grill, and writes PRD-ready conclusions.
- [`finish-grill`](skills/finish-grill/SKILL.md) — reads every completed grill topic and writes `PRD-SOURCE.md` for `/to-prd`.
- [`grilling`](skills/grilling/SKILL.md) — stress-tests a plan or design by asking one relentless question at a time with a recommended answer.
- [`grill-prep`](skills/grill-prep/SKILL.md) — prepares big project ideas with a light grill, topic split, docs, and thread briefs before deeper grilling.
- [`start-grill`](skills/start-grill/SKILL.md) — starts a grill request and routes through direct `/grilling` or persistent `/grill-prep` docs based on context size.
- [`to-prd`](skills/to-prd/SKILL.md) — turns settled discussion and repo evidence into a PRD on the configured issue tracker.
- [`to-issues`](skills/to-issues/SKILL.md) — breaks a PRD, plan, or spec into independently grabbable vertical-slice issues.
- [`do-issues`](skills/do-issues/SKILL.md) — works through ready AFK vertical-slice issues one at a time with verification.
- [`tdd`](skills/tdd/SKILL.md) — guides implementation through vertical Red-Green-Refactor cycles and public behavior tests.
- [`write-a-skill`](skills/write-a-skill/SKILL.md) — creates or improves skills with clear triggers, short instructions, and one-level references.

### Review And Quality

- [`code-review`](skills/code-review/SKILL.md) — reviews local diffs or PRs for completion, regressions, performance, and safety.

### Architecture

- [`codebase-design`](skills/codebase-design/SKILL.md) — provides deep-module vocabulary for module interfaces, seams, adapters, leverage, and locality.
- [`improve-codebase-architecture`](skills/improve-codebase-architecture/SKILL.md) — scans a codebase for deepening opportunities and writes a visual HTML report.

### Engineering Harness

- [`setup-project-harness`](skills/setup-project-harness/SKILL.md) — builds an interview-driven project harness for Codex and Claude. Use it for frontend, backend, full-stack, library, CLI, monorepo, empty starter, or engineering-skills repositories.
- [`skill-review`](skills/skill-review/SKILL.md) — reviews skills for short descriptions, trigger clarity, brevity, and judgment-preserving guidance.

## Skill Design Principles

- Small beats comprehensive.
- Instructions should create better collaboration, not remove autonomy.
- Read repo evidence before asking questions.
- Ask only where user intent or taste is decisive.
- Prefer progressive disclosure over one giant prompt.
- Capture boundaries in rules, not generic advice.
- Make verification part of the workflow.
- Preserve model judgment wherever divergence is not dangerous.

## Repository Layout

```text
AGENTS.md
CLAUDE.md -> AGENTS.md
.agents/
  rules/
    project/
      agent-workflow.md
    skills/
      authoring.md
      review.md
docs/
  agents/
    domain.md
    issue-tracker.md
    triage-labels.md
skills/
  codebase-design/
    SKILL.md
    DEEPENING.md
    DESIGN-IT-TWICE.md
  code-review/
    AGENT-BRIEFS.md
    SKILL.md
    PROJECT-LENSES.md
    REVIEW-AXES.md
  domain-modeling/
    SKILL.md
    ADR-FORMAT.md
    CONTEXT-FORMAT.md
  do-grill/
    SKILL.md
  do-issues/
    SKILL.md
  finish-grill/
    SKILL.md
  grilling/
    SKILL.md
  grill-prep/
    SKILL.md
    TEMPLATES.md
  start-grill/
    SKILL.md
  handoff/
    SKILL.md
  improve-codebase-architecture/
    SKILL.md
    HTML-REPORT.md
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
  write-a-skill/
    SKILL.md
  setup-project-harness/
    SKILL.md
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
- preparing large project ideas as scoped topic docs before they become overlong chats

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
