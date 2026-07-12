---
name: implement
description: Implements one bounded task or implementation-frontier ticket through evidence, review, and verification.
disable-model-invocation: true
---

# Implement

One bounded task or one runnable implementation ticket: one claim, one fresh
context, one reviewable delta, one completion decision.

Routing / anti-invention: `docs/lifecycle.md`.
Subagent dispatch: `docs/agents/orchestration.md` (required try / soft fail).

## Find The Work

Read `CONTEXT.md` or context map when present, plus source (spec, ticket, legacy
PRD/issue, bug report, or brief). Tracked work: also
`docs/agents/issue-tracker.md` and `docs/agents/triage-labels.md`. Explicit user
reference wins; canonical vs legacy conflict → show both.

Clear bounded request → implement directly (no invented spec/ticket). Intent not
ready → stop and route per lifecycle.

Read **Layer** (`frontend` | `backend` | `full-stack` | `non-UI`). UI missing
field/rule/design pin, or BE missing contract expectations → stop
(`docs/handoff-package.md`). No UI pins on backend-only; no BE work on FE-only.

Tracked work (frontier, bug-report conversion, HITL, claim/isolate): load
[TRACKED-WORK.md](TRACKED-WORK.md) before edits.

## Execute

Parent keeps: find-work, tracker claim/state, route decisions, final Done report.
**Code changes and local verification loops** go through the dispatch ladder.

### Subagent: Execute (hard try)

For steps that edit code or run the evidence loop (items 2–6 below):

1. **Try** project agent `Executor` with a brief: goal, scope, AC/source pins,
   constraints, verify commands, layer, **no tracker authority** (default).
2. If missing / spawn fails → try built-in `general-purpose` with the same brief.
3. If that fails or Agent tool absent → parent performs the work in-session.
4. **Never** abort implement because `Executor` is undefined.

Tiny one-line mechanical edits may stay in parent when cheaper; non-trivial
implementation **must** attempt `Executor` first when Agent tool exists.

### Steps

1. Mark in progress when tracked (parent).
2. Trace entrypoints when behavior crosses callers, persistence, permissions,
   async, conversions, or side effects. Load covered `REQ`/`AC`/`SCN` and any
   `SCR`/`FLD`/`RULE` subset. (Explore built-in OK for pure research.)
3. Evidence loop via **Executor ladder**: observable behavior → `/tdd` (RED →
   smallest GREEN); authorized behavior-preserving docs/config/mechanical →
   GREEN baseline + verify → one increment → rerun (expand-contract: caller
   inventory + compatibility checks).
4. `/simplify` for non-trivial changes (prefer Executor ladder if simplify needs
   multi-file edits); tiny mechanical diffs stay direct.
5. Project verification (**behavior gate** for this layer) — Executor ladder if
   fixes are required to go green.
6. **Fidelity** (do not close on behavior-green alone when applicable):
   - **UI** (FE/full-stack UI delta): fields, requiredness, show/hide/enable,
     empty/error/loading vs contract/design; checklist and/or screenshot. n/a
     backend-only.
   - **API** (BE/full-stack contract delta): request/response/error/authz/compat
     vs stated contract. n/a pure UI on pinned external API.
7. `/code-review` against fixed point (AC + fidelity). That skill **must try**
   `Reviewer` / `Verifier` per orchestration.md.
8. If review is not `Pass` and fixes are in scope (implement always authorizes
   in-scope, behavior-preserving, eligible auto-fixes for this ticket):
   - **Try `Executor`** with: fixed point, eligible findings list, fix contract
     from `/code-review` (how not what), verify commands.
   - Fallback: general-purpose → parent. Same never-abort rule.
   - Re-run `/code-review` (or Verifier gate) after fixes.
9. Re-check every AC. Wrong product/design contract → hand to product/design with
   IDs (never invent Expected). Implementation drift → fix via Executor ladder or
   leave open. Complete only when behavior, fidelity, verification, and review pass.

Unverified criteria stay open. Commit only when authorized (parent).

## Stop Or Continue

Default: one ticket, then stop. Multi-ticket only if user asked — fresh worker
and isolated delta each; never two dependent tickets in one context.

Mid-flight HITL / claim release / temp handoffs: [TRACKED-WORK.md](TRACKED-WORK.md).

## Done

Report: task/ticket, source, fixed point, files, behavior-gate, fidelity (or n/a),
code-review verdict, which agents ran (or fallback used), tracker update, commit
status, next frontiers or blocker.
