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
- observability **bar classification** (full / thin / partial); foundation build is **`/setup-logging`**
- `AGENTS.md`, `CLAUDE.md`, `docs/agents/`, and failure pins only when justified (Checklist first; long classifiers under `.agents/rules/` rarely)

That is the fast path. After harness setup, agents know where project wiring lives; prove-work commands stay in README/scripts/CI. On integration-heavy repos, run **`/setup-logging`** for a stack-native logging foundation (unified API, correlation, fail-open, how-to-read) before AFK feature work.

### Empty Project Routing

See [Lifecycle §4 Empty project](#4-empty-project). Short version: no workbench →
`/setup-project-harness` (or HEAVY PM first if only a fuzzy product goal exists);
daily work then follows the LIGHT chooser.

## Lifecycle

**Two tracks.** Default to **LIGHT**. Use **HEAVY** only when the product need
itself is fuzzy. Source of truth for edge cases:
[docs/lifecycle.md](docs/lifecycle.md) ·
[docs/boundaries.md](docs/boundaries.md) ·
[docs/handoff-package.md](docs/handoff-package.md).

### 0. Choose track (one question)

```text
Is the product need itself fuzzy?
  (worth-doing, target user, market, "what should we build?")
    → HEAVY  → full PM, then hand a settled package into LIGHT L2

Is intent good enough to code against?
  (bug, named AC, settled multi-slice, pure eng)
    → LIGHT  → smallest step below (prefer L1 when honest)
```

**Bias:** do not open PM, Wayfinder, or multi-skill pipelines when `/implement` is enough.

### 1. Quick chooser

| Situation | Flow | Entry → exit |
| --- | --- | --- |
| Bug / clear AC / one eng slice | **L1** | `/implement` → done |
| Settled multi-slice package | **L2** | `/to-spec` → `/to-tickets` → `/implement` |
| Few open decisions; *you* can answer this session | **G** | `/grill-me` → chat recap → `/implement` (archive/`/to-spec` only if handoff) |
| Answers live with PM/业务; 需求澄清会 or async form | **Q** | `/to-questionnaire` → fill → paste back → **`/to-spec`** (no re-confirm) |
| Shipped wrong / mild Expected gap in coding context | **L3** | `/product-fog` → exactly one next (G / Q / L2 / L4 / stop / PM) |
| Product OK; technical route needs many sessions | **L4** | try **G** first → else `/wayfinder` → map resolved → **L2** |
| Vague idea, no validated need | **HEAVY** | `wen-pm` (or team PM) → then **L2** |
| System QA of a build | optional | `wen-test` |

### 2. LIGHT flows (detail)

Map of steps (each flow is independent — pick one):

```text
L1  clear work              →  /implement
L2  multi-slice             →  /to-spec → /to-tickets → /implement
G   same-session pin        →  /grill-me  →  chat recap  →  /implement (| archive → /to-spec if handoff)
Q   stakeholder questionnaire →  /to-questionnaire  →  fill  →  ingest  →  /to-spec
L3  mild intent pin         →  /product-fog  →  one next skill
L4  multi-session eng fog   →  /wayfinder  →  (resolved)  →  L2
```

#### L1 — Implement (default daily)

```text
bug | clear AC | pure eng slice
  → /implement
      (hard bug first: /diagnosing-bugs)
  → evidence loop (TDD or GREEN baseline)
  → /simplify when non-trivial
  → project checks → /code-review → done
```

- **In:** enough AC or a single ticket; no invented product value.
- **Out:** reviewable delta closed. No parent spec required.
- **Do not:** invent tickets or specs to look busy.

#### L2 — Spec → tickets → implement

```text
settled package (PRD / docs / chat AC / PM handoff / filled questionnaire archive)
  → /to-spec          (non-runnable parent; no re-interview of settled answers)
  → /to-tickets       (dependency graph; implementation frontier)
  → /implement        (one ticket at a time)
  → (optional) wen-test: /to-test-plan → /qa-run
```

- **In:** product intent settled enough to write honest requirements.
- **Out:** slices on the frontier; parent spec stays open until work is done.
- **Also:** `/alignment-review` when slice risk is high; FE/BE fidelity at ticket layer.
- **Do not:** close the parent spec from `/implement`.

#### G — Grill (same-session pin)

```text
plan still fuzzy, but *you* own the decisions and one session can clear them
  → /grill-me   (loads /grilling; domain-modeling only if terms truly change)
      frontier rounds: batch table + 推荐; facts first (non-blocking sub-agents)
      MVP in/out early; anti rubber-stamp on high-risk only
  → close: chat recap by default (no decision-*.md)
  → durable archive only for cross-session / Wayfinder / explicit ask
  → next: usually /implement in-session; /to-spec only if multi-slice handoff
```

- **In:** a few user-owned product/eng decisions; not multi-session fog.
- **Out:** shared understanding in chat (Matt-style). Files are the exception, not the rule.
- **Escalate:** wrong human in the room → **Q**; too big for one session → **L4**; market/worth-doing open → **HEAVY**.
- **Do not:** invent Expected; force process docs for simple pins; treat “grill done” as push authority on shared branches.

#### Q — Questionnaire (meeting or async)

```text
you are not the product/domain owner for open decisions
  → /to-questionnaire
      grill the *send* only (who + what you need back)
      every decision question: options + 推荐 + 手写(Z)
  → Meeting (需求澄清会) or Async fill-in
  → paste back: 问卷已填 + path
  → ingest: answered Q-ids are settled — do not re-confirm
  → default: /to-spec
  → only if eng seams remain: short /grill-me on *those* only
```

- **In:** PM/业务 holds answers; or you want a clarification-meeting agenda.
- **Out:** filled questionnaire → fold into **L2** (`/to-spec`…); no parallel rotting decision file.
- **Do not:** re-ask settled options; run full product discovery; use Q as HEAVY PM substitute.

#### L3 — Product fog (thin pin)

```text
rework / mild Expected gap / "not quite what I meant" (already in coding context)
  → /product-fog   (mini docket only; never invent Expected)
  → exactly one next:
        Align        → G or Q
        Build-ready  → L2 (/to-spec)
        pure-eng     → L1 or L2
        multi-session tech fog → L4
        Discovery / Pause / Kill / Escalate-PM → stop or HEAVY
```

- **In:** coding-adjacent intent pin — not market discovery.
- **Out:** one disposition + one skill (or stop). No production mutations.

#### L4 — Wayfinder (multi-session eng fog)

```text
product settled enough; technical route still multi-session foggy
  → prefer G first if one interview would clear it
  → /wayfinder
      thin map (≤5 tickets on chart); research/task over grill
      short pastes: skills/wayfinder/CONTINUE.md
  → map Status: resolved
  → L2: /to-spec → /to-tickets → /implement
```

- **In:** eng decisions that need a shared frontier across sessions.
- **Out:** resolved map; **stop** Wayfinder; consume resolutions in `/to-spec` (do not re-grill closed DECs).
- **Do not:** implement the destination inside the map; invent product value with tickets.

### 3. HEAVY — fuzzy product need

```text
vague idea | unknown user | market bet | "should we build this?"
  → full product discovery
      preferred: wen-pm /pm-intake → … → Build|Bet → to-prd
      or team PM process
  → hand settled package into LIGHT L2
      /to-spec → /to-tickets → /implement
```

- **Do not** open `/implement`, `/to-spec`, or Wayfinder to invent product value.
- If `wen-pm` is missing: stop inventing; name the evidence gap. Optional `/product-fog` only to record Discovery / Pause / Kill.

### 4. Empty project

```text
no workbench yet
  → stack/repo shape known     → /setup-project-harness first
  → only product goal (fuzzy)  → HEAVY PM first, then harness + L2
  → stack choices open         → short /grill-me → /setup-project-harness
  → then daily work            → LIGHT from the chooser above
```

Harness records **facts and user decisions only**. Leave package manager,
framework, and prove-work commands undefined until scaffold evidence exists.

### 5. Implement loop (inside L1 / each L2 ticket)

```text
claim → behavior test or compatibility baseline → simplify → verify → code-review → close
```

Support skills (compose under any flow): `/tdd`, `/simplify`, `/code-review`,
`/research`, `/prototype`, `/domain-modeling`, `/alignment-review`,
`/resolving-merge-conflicts`, `/handoff`.

### 6. Command names (v1.1)

| Current | Retired (still valid as *inputs*) |
| --- | --- |
| `/to-spec` | `/to-prd` — existing `PRD.md` stays valid |
| `/to-tickets` | `/to-issues` — existing `issues/` stays valid |
| `/grill-me` | user entry; loads model-invoked `/grilling` |

Sync removes managed copies of fully retired command names; unmarked same-name
skills in the canonical root block normal sync (`--force` backs them up first).

## Local Workspace

Common skills:

- `/alignment-review` reviews specs and tickets for intent, coverage, repo evidence, and execution fit.
- `/codebase-design` provides deep-module vocabulary for module interfaces and seams.
- `/code-review` independently reviews a fixed delta for intent, correctness, ponytail complexity, performance, security, and standards (including Fowler smell baseline).
- `/diagnosing-bugs` diagnoses hard bugs and performance regressions with a feedback loop; multi-step fix proposals get a frozen design packet and pack `Reviewer` design axes (prefer another model) before coding — `docs/agents/DESIGN-REVIEW-BRIEF.md`.
- `/domain-modeling` sharpens glossary terms and records ADRs while design decisions crystallize.
- `/implement` takes one bounded task or implementation-frontier ticket through the matching evidence loop, simplification, verification, code review, and tracker completion.
- `/grill-me` stress-tests an engineering plan (same-session pin); loads `/grilling`; domain-modeling only when terms truly change; **default close is chat recap** (no mandatory decision file). Routes to `/to-questionnaire` when the wrong human is in the room.
- `/grilling` is the reusable interview loop: **frontier rounds** (dependency-aware batch tables, not serial micro-Qs), non-blocking fact sub-agents, anti rubber-stamp, confirmation gate.
- `/to-questionnaire` turns stakeholder gaps into a meeting or async questionnaire (options + 推荐 + 手写); paste back → ingest without re-asking → default `/to-spec`.
- `/handoff` writes a compact handoff document for a fresh agent.
- `/improve-codebase-architecture` finds deepening opportunities and writes a visual HTML report.
- `/prototype` creates a disposable logic/state or UI evidence artifact for an explicit question or Wayfinder ticket.
- `/research` saves cited primary-source evidence for an explicit question or Wayfinder ticket.
- `/resolving-merge-conflicts` resolves in-progress git merge/rebase conflicts by intent.
- `/simplify` cleans up non-trivial changed code for reuse, smaller code, efficiency, and right-depth fixes.
- `/setup-project-harness` initializes a project-level agent harness.
- `/setup-logging` builds the project logging foundation when the shape requires it.
- `/skill-review` reviews a new or changed skill before accepting it.
- `/tdd` is the red → green reference (seams, anti-patterns); close to Matt upstream.
- `/to-spec` turns settled context into a non-runnable spec with stable requirements.
- `/to-tickets` turns an approved spec into a dependency-aware ticket graph and typed frontiers.
- `/product-fog` LIGHT intent pin in coding context (mini docket, one next route).
- `/wayfinder` clears multi-session fog into a thin decision map (short pastes, research-first), then hands off to `/to-spec`.
- `/writing-great-skills` provides a reference for writing and editing predictable skills.

The harness skill creates:

- `AGENTS.md` as the shared entrypoint: path wiring + optional failure Checklist
- `CLAUDE.md` linked to `AGENTS.md`
- tracker / labels / domain docs under `docs/agents/`
- `.agents/rules/**` only when a real failure needs more than a Checklist line (e.g. `invariants/`)

## Why This Exists

AI agents fail in predictable ways.

### #1: The Agent Guessed The Project Boundary

Most projects do not fail because the model cannot write code. They fail because the model does not know the local boundary: which layer owns the logic, which naming convention matters, which command proves success, which tradeoff the team already made.

The fix is a project harness: a small `AGENTS.md` entrypoint (wiring + depreciating Checklist pins) plus docs for tracker/domain detail — not a growing rules constitution.

### #2: The User And Agent Did Not Align

Users often know what good feels like before they can state it as a spec. Agents are useful because they can ask, propose, synthesize, and make the implicit explicit.

The fix is an interview-driven setup. The skill reads the repo first, brings recommended defaults when evidence supports them, then grills only the decisions the repo cannot answer.

### #3: Permanent Instructions Became Noise

Too many harnesses overcorrect. They dump generic best practices into always-loaded context and make the agent worse.

The fix is failure-driven, depreciating pins:

- After a real failure → one Checklist item (or a long classifier under `.agents/rules/` only when needed)
- When current models stop tripping → remove the pin
- Never restate model-default competence

### #4: The Codebase Lost Its Language

When agents do not share the project's vocabulary, they write verbose explanations, inconsistent names, and awkward abstractions.

The fix is progressive disclosure: keep `AGENTS.md` short, put domain language in `CONTEXT.md`, architectural decisions in `docs/adr/`, and load long boundaries only when work matches (e.g. invariants).

## Skills

### Planning And Alignment

- [`alignment-review`](skills/alignment-review/SKILL.md) — reviews specs and tickets for intent, coverage, evidence, and execution fit.
- [`domain-modeling`](skills/domain-modeling/SKILL.md) — sharpens domain language, updates `CONTEXT.md`, and records sparse ADRs as decisions crystallize.
- [`grill-me`](skills/grill-me/SKILL.md) — user-invoked same-session plan pin (LIGHT G); loads `/grilling`, MVP boundary; default chat close (no mandatory decision file).
- [`grilling`](skills/grilling/SKILL.md) — model-invoked interview loop: frontier rounds + batch tables, non-blocking facts, anti rubber-stamp, confirmation gate.
- [`to-questionnaire`](skills/to-questionnaire/SKILL.md) — stakeholder questionnaire (options + 推荐 + 手写); filled answers settle without re-grill; default next `/to-spec` (LIGHT Q).
- [`product-fog`](skills/product-fog/SKILL.md) — LIGHT intent pin in coding context; mini docket and one next route (not full PM).
- [`wayfinder`](skills/wayfinder/SKILL.md) — thin multi-session map + short pastes; exit to `/to-spec` (see `CONTINUE.md`).
- [`research`](skills/research/SKILL.md) — saves cited primary-source evidence for an explicit question or active Wayfinder ticket.
- [`prototype`](skills/prototype/SKILL.md) — builds bounded disposable logic/state or UI evidence without mutating tracker or production state.
- [`to-spec`](skills/to-spec/SKILL.md) — turns settled context into a non-runnable spec with stable requirements.
- [`to-tickets`](skills/to-tickets/SKILL.md) — turns an approved spec into a dependency-aware set of one-context tickets.
- [`implement`](skills/implement/SKILL.md) — takes one bounded task or implementation-frontier ticket through testing or compatibility evidence, review, and verification.
- [`tdd`](skills/tdd/SKILL.md) — red → green at pre-agreed seams (Matt base).
- [`handoff`](skills/handoff/SKILL.md) — writes a compact handoff document for a fresh agent, saved outside the repo.
- [`resolving-merge-conflicts`](skills/resolving-merge-conflicts/SKILL.md) — resolves in-progress git merge/rebase conflicts from each side's intent.

### Review And Quality

- [`code-review`](skills/code-review/SKILL.md) — reviews diffs for intent, bugs, incomplete production surface (blocking, including quiet critical paths and log-unsafe logging), forensic log-chain completeness, ponytail complexity, performance, security, and standards (Fowler smell baseline).
- [`diagnosing-bugs`](skills/diagnosing-bugs/SKILL.md) — diagnoses bugs and performance regressions by building a feedback loop before changing code.
- [`simplify`](skills/simplify/SKILL.md) — cleans up non-trivial changed code for reuse, smaller code, efficiency, and right-depth fixes.

### Architecture

- [`codebase-design`](skills/codebase-design/SKILL.md) — provides deep-module vocabulary for module interfaces, seams, adapters, leverage, and locality.
- [`improve-codebase-architecture`](skills/improve-codebase-architecture/SKILL.md) — scans a codebase for deepening opportunities and writes a visual HTML report.

### Engineering Harness

- [`setup-project-harness`](skills/setup-project-harness/SKILL.md) — builds a minimal, evidence-first project harness for Codex and Claude. Use it for frontend, backend, full-stack, library, CLI, monorepo, empty starter, or engineering-skills repositories.
- [`setup-logging`](skills/setup-logging/SKILL.md) — builds a project logging foundation (crime-scene replay): unified logger API, correlation, fail-open sinks, redaction, how-to-read; stack recipes for Spring, Next.js, Python, Node, Go.
- [`skill-review`](skills/skill-review/SKILL.md) — reviews skills for discovery, trigger clarity, progressive disclosure, and judgment-preserving guidance.
- [`writing-great-skills`](skills/writing-great-skills/SKILL.md) — provides vocabulary and principles for writing predictable skills.

## Skill Design Principles

- **Matt-first:** shared skill bodies stay close to
  [`mattpocock/skills`](https://github.com/mattpocock/skills); WEN only adds
  pack deltas (harness name, lifecycle, authority, multi-agent, templates).
- Small beats comprehensive.
- Instructions should create better collaboration, not remove autonomy.
- Read repo evidence before asking questions.
- Ask only where user intent or taste is decisive.
- Prefer progressive disclosure over one giant prompt.
- Treat permanent instructions as depreciating assets: prune no-ops, empty-rewrite when stale, add guardrails from real failures.
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
    invariants/
      invariants.md
docs/
  invocation.md
  adr/
    0001-skill-composition.md
    0002-invariants-rule.md
    0003-skill-invocation-boundaries.md
    0004-wen-lifecycle.md
    0005-incomplete-production-surface.md
    0006-forensic-observability.md
  agents/
    domain.md
    issue-tracker.md
    orchestration.md
    DESIGN-REVIEW-BRIEF.md
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
    DISPATCH.md
    AGENT-BRIEFS.md
    FORENSIC-OBSERVABILITY.md
    INCOMPLETE-SURFACE.md
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
  grill-me/
    SKILL.md
  grilling/
    SKILL.md
  handoff/
    SKILL.md
  implement/
    DISPATCH.md
    SKILL.md
    TRACKED-WORK.md
  improve-codebase-architecture/
    HTML-REPORT.md
    SKILL.md
  prototype/
    LOGIC.md
    SKILL.md
    UI.md
  research/
    SKILL.md
  resolving-merge-conflicts/
    SKILL.md
  setup-logging/
    PRINCIPLES.md
    SKILL.md
    STACKS.md
    VERIFY.md
  setup-project-harness/
    AGENTS_TEMPLATE.md
    HARNESS_FLOW.md
    OBSERVABILITY.md
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
    tests.md
  to-questionnaire/
    SKILL.md
  to-spec/
    SKILL.md
    TEMPLATE.md
  to-tickets/
    EXPAND-CONTRACT.md
    SKILL.md
    TEMPLATE.md
  product-fog/
    DOCKET.md
    SKILL.md
  wayfinder/
    CONTINUE.md
    FOG.md
    SKILL.md
    TEMPLATES.md
  writing-great-skills/
    GLOSSARY.md
    SKILL.md
```

## Current Focus

This repo currently focuses on a **lightweight, evidence-first coding lifecycle**:

- initialize a trustworthy project harness and shared agent entrypoint
- standalone **or** linked with optional `wen-pm` / `wen-test` (no hard deps)
- accept delivery inputs from any settled product source
- support frontend-only, backend-only, and full-stack layer scope
- default multi-session coding path: settled intent → `/to-spec` → `/to-tickets` → `/implement`
- LIGHT daily path by default; HEAVY fuzzy need via optional `wen-pm` first
- multi-session eng fog: `/wayfinder` (thin map + short paste) → `/to-spec` → `/to-tickets` → `/implement`
- system test/QA via optional companion `wen-test` (or human/CI)
- preserve intent in non-runnable specs and traceable ticket DAGs
- implement one isolated implementation-frontier ticket through the right evidence loop, simplification, review, and verification
- use research and prototypes as bounded evidence
- leave system test design/QA to optional companion `wen-test`
- keep Codex, Claude, ZCode, and Kimi aligned through `~/.agents/skills`

The design stays tracker-neutral and context-aware: small work stays small;
foggy large work earns durable Wayfinder maps and fresh execution contexts;
never invent product answers without user authority.

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
