---
name: implement
description: Implements one bounded task or implementation-frontier ticket through evidence, review, and verification.
disable-model-invocation: true
---

# Implement

One bounded task or one runnable implementation ticket: one claim, one fresh context, one reviewable delta, one completion decision.

## Find The Work

Read `CONTEXT.md` or the context map when present, plus the source spec, ticket, legacy PRD/issue, bug report, or task brief. For tracked work, also read `docs/agents/issue-tracker.md` and `docs/agents/triage-labels.md`. An explicit user reference wins. If canonical and legacy active sets conflict, show both candidates.

A clear bounded request needs no harness, invented spec, or ticket — implement directly and skip tracker-only steps.

If **HEAVY** product fog remains (worth-doing, target user, market, unvalidated idea), stop and recommend full PM (`wen-pm` `/pm-intake` or team process) — do not invent intent. If only a **LIGHT** coding-adjacent gap remains (mild Expected/rework), recommend `/product-fog`; multi-session eng fog → `/wayfinder`. See `docs/lifecycle.md`.

Read **Layer** on the ticket/spec (`frontend` | `backend` | `full-stack` | `non-UI`). If UI-scoped work lacks field/rule structure or a required design pin, or backend contract work lacks API/event expectations, stop and report the package gap (`docs/handoff-package.md`). Do not force UI pins on backend-only tickets or BE implementation on FE-only tickets.

For tracked work (frontier selection, bug-report conversion, HITL, claim/isolate), load [TRACKED-WORK.md](TRACKED-WORK.md) before edits.

## Execute

1. Mark the ticket in progress when tracked (adapter-specific state).
2. Trace the relevant entrypoint when behavior crosses callers, persistence, permissions, async paths, conversions, or side effects. Load covered `REQ`/`AC`/`SCN` and any `SCR`/`FLD`/`RULE` subset from the ticket or parent spec.
3. Choose the evidence loop from the actual change:
   - observable behavior: load `/tdd`, public-behavior test → RED → smallest implement → GREEN
   - authorized behavior-preserving docs/config/mechanical work: GREEN baseline + exact verification → one increment → rerun; expand-contract also records caller inventory and compatibility/static checks
4. Load `/simplify` for non-trivial changes; keep tiny mechanical diffs direct.
5. Run the project's exact verification commands (**behavior gate** for this layer).
6. **Layer fidelity gates** (do not close on behavior-green alone when either applies):
   - **UI** (frontend or full-stack UI delta): fields/labels, requiredness, show/hide/enable linkage, empty/error/loading vs UI contract and pinned design; checklist and/or screenshot. Not required for backend-only / non-UI.
   - **API/contract** (backend or full-stack contract delta): request/response/error/authz/compat vs stated contract. Not required for pure UI that only consumes a pinned external API.
7. Load `/code-review` against the recorded fixed point. Include AC coverage and applicable fidelity. Resolve every blocking finding or user-owned decision, then rerun affected verification.
8. Re-check every acceptance criterion. If fidelity fails because the **product/design contract is wrong**, hand to product/design with IDs — do not invent Expected. If **implementation** drifts, fix or leave open. Complete only when behavior gate, applicable fidelity gates, verification, and review pass.

Keep unverified criteria open. Commit only when the user or project workflow authorizes it.

## Stop Or Continue

Default: one ticket, then stop with next frontiers and review evidence. Bounded multi-ticket loops only when the user explicitly requested them — fresh worker and isolated delta per ticket. Never run two dependent tickets in one context.

Mid-flight HITL, claim release, and temp handoffs: [TRACKED-WORK.md](TRACKED-WORK.md).

## Done

Report: task/ticket, source, fixed point, changed files, behavior-gate evidence, fidelity-gate evidence (or `n/a`), code-review verdict, tracker update, commit status, next frontiers or blocker.
