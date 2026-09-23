---
name: ask-process
description: Ask which skill or flow in this pack fits the situation. A router over wen-engineering, not an upstream router.
disable-model-invocation: true
---

# Ask Process

You don't remember every skill, so ask.

Answer with **one next skill** (or one short path). Do not start the work. Do not invent product Expected. Source of truth if this file and the docs disagree: [docs/lifecycle.md](../../docs/lifecycle.md), [docs/prd-authority.md](../../docs/prd-authority.md).

Skills named here are **this pack**. Do not route to a skill that is not installed from this repo.

## One question first

```text
Is the product need itself fuzzy?
  (worth-doing, target user, market, "what should we build?")
    → HEAVY. Not this pack. wen-pm or the team's PM.
      Come back at L2 only after the package is settled.

Is the intent good enough to code against?
  (named AC, bug, settled multi-slice, pure eng, an existing PRD)
    → LIGHT. Pick the smallest step below.
```

Default is LIGHT. Do not open PM, Wayfinder, or a multi-skill pipeline when `/implement` is enough.

## LIGHT

| Shape | Next | Do not |
| --- | --- | --- |
| Bug, clear AC, one eng slice | **L1** `/implement` | Open G, Q, L2, or L4 to look thorough |
| Hard bug, no tight repro yet | `/diagnosing-bugs` first, then L1 if a fix is authorized | Hypothesise without a red loop |
| Diagnosis produced a multi-step fix proposal | Freeze a design packet, pack `Reviewer` on design axes, then the user scopes MVP → `/implement` or L2 | Start coding inside the diagnosis |
| Settled multi-slice (PRD, docs, chat AC, PM handoff) | **L2** `/to-spec` → `/to-tickets` → `/implement` | Full-product `/grill-code` |
| A few decisions only you can close in this chat | **G** `/grill-code` (loads `/grilling`) | Write a decision file by default |
| The answers sit with someone else, or a clarification meeting | **Q** `/to-questionnaire` → paste back → `/to-spec` | Grill the subject you cannot answer; re-ask filled answers |
| Already shipped, or "not quite what I meant" | **L3** `/product-fog` → exactly one next hop | Market discovery |
| Product settled, technical route needs more than one session | **L4** `/wayfinder`, then L2 when the map is resolved | Try L4 before G if one interview would clear it |
| Whole spec, tickets already form a graph, land on the current branch | `/implement-spec` | Use it for a single ticket; that is `/implement` |

`/implement` is one slice: TDD at the agreed seams, `/code-review`, commit. It does not close the parent spec.

`/implement-spec` drives the whole graph on the branch the user is already on: frontier tickets in parallel, one local worktree each, merge back, one `/code-review`, then delete those worktrees and branches. It does not create a branch, open a PR, or push unless the user asks.

## When a PRD or prototype already exists

A named product doc (`docs/requirements/*`, `docs/prd/*`, or a doc the user treats as the PRD) is the product baseline.

- Multi-slice → **L2**, not a full grill. `/grill-code` only for residual poles: two PRD rows that cannot both be true, a term that does not map to a live column, an eng seam the PRD does not own.
- A recommendation that narrows or changes PRD behavior must be labeled `相对 PRD` and classed `doc-change` or `eng-read`. Unlabeled `按推荐` does not override the PRD.
- **按原文** / revoke a delta → **L3** `/product-fog`, re-open only those ids. Do not re-grill the package.
- `/to-spec` must publish a PRD Inventory before `accepted`. `/to-tickets` must put every `REQ` `SRC` in some ticket `Covers` before publish. `Supports` is not coverage.
- A prototype, HTML mock, or Figma pin is a **design pin** on the spec and on UI tickets. It is not a fresh product question. Do not re-grill layout the pin already shows. Appearance that is still open → `/prototype`, then pin the winner. A versioned pin → `/implement` plus the UI fidelity gate, not another look-and-feel grill.
- Closing the last implementation ticket, or answering "已按 PRD 实现", → `/alignment-review` **prd-walk** against the **original** product doc. Any `缺` blocks delivered.

## After grill

Pick one. Do not default to "spec plus prototype".

| Settled | Next |
| --- | --- |
| Behavior AC is enough, or the UI pin already exists | `/implement`, or L2 if it is multi-slice |
| Another session or agent must carry it | `/to-spec` → `/to-tickets` |
| Only appearance is open | `/prototype`, then pin |
| Worth-doing / market is still open | HEAVY PM |

Same-session grill closes in chat. Do not create a decision file unless another session, a Wayfinder ticket, or the user asked for one.

## Support

Use these under a flow, not instead of one.

| Need | Skill |
| --- | --- |
| Red → green at a seam | `/tdd` |
| Behavior-preserving cleanup | `/simplify` |
| Review a diff | `/code-review` |
| Cited reading | `/research` |
| Domain terms / ADR | `/domain-modeling` |
| A message that did not land | `/wait-what` |
| Steps only a human can click | `/wizard` |
| Write or edit `AGENTS.md` / a skill | `/writing-for-agents` |
| First-time tracker, labels, domain docs | `/setup-project` |
| Logging foundation | `/setup-logging` |
| Incoming raw issues | `/triage` |
| Checklist pins from real sessions | `/harvest-pins` |
| Review a skill before accepting it | `/skill-review` |

`/setup-project` does not rewrite `AGENTS.md`. It writes `docs/agents/` and, only if a root file already exists, the `## Agent skills` pointer.

## Do not route here

- Inventing Expected, market bets, or user value.
- A full product grill of a settled PRD.
- `/wayfinder` for a feature whose route is already visible.
- System QA (`/to-test-plan`, `/qa-run`) — optional `wen-test`, not this pack.
- Creating or rewriting `AGENTS.md` from `/setup-project`.
