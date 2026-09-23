# Upstream sync — mattpocock/skills v1.2.3

Pin: `c55ee46073ed923f86ce59a5eb3b6d895095d1b7` (tag `v1.2.3` plus one docs commit, 2026-09-18).  
Prior pin: `8b36d4fb2635b3c21998dcd8144439c9e5ba7302` (tag `v1.2.2`, 2026-08-05).

v1.2.2 → v1.2.3 behavior taken (WEN deltas kept):

- `diagnosing-bugs`: **Redact** section; captured artifacts and the Phase 1 loop output are shown redacted; `hitl-loop.template.sh` notes that `capture` echoes to the terminal.
- `code-review` / `improve-codebase-architecture`: drop harness-specific tool and agent-type names from the shared dispatch sentence. WEN still names pack `Reviewer` / `Verifier` in its own process section.
- `wizard`: drop `TOTAL_MINUTES` and the time-remaining display. `stage` takes a name only.

Not taken: em-dash to colon reflow across the rest of the skill set (no behavior change), and in-progress skills (`pr`, `retro`) that have not graduated. `implement-spec` was copied in as-is (still upstream in-progress) because this pack needs a whole-spec PR driver; its only skill call is `/code-review`, which this pack owns. PRD Inventory, `Covers`, design pin, and residual-only grill are WEN and were not in this upstream delta.

Principle: **Matt-first** on shared skill bodies; WEN only layers pack deltas
(harness name `/setup-project`, lifecycle, authority, multi-agent,
optional templates).

## Decision table

| Skill | Action | Notes |
| --- | --- | --- |
| `grilling` | **Take Matt + WEN delta** | Round/frontier + `❓`/`➡️` format from Matt; batch tables from WEN. PRD, rubber-stamp, next-hop live on `grill-code`, not this shared loop |
| `grill-me` | **Split** | Matt's one-liner stays the non-coding interview. Coding body moved to `grill-code` |
| `grill-code` | **WEN** | Former `grill-me` body: product-doc authority, close gate, implement handoff. Not Matt `grill-with-docs` |
| `prototype` | **Take Matt + WEN bounds** | Logic branch = shareable HTML; UI.md keeps WEN anti-goal / `to-design-md` |
| `wayfinder` | **Matt body + WEN** | Decision tickets + research subagents from Matt; Session handoff, cold-start, chart budget, harness name from WEN |
| `to-tickets` | **Matt body + WEN** | Pre-publish gate, harness name, TEMPLATE/PUBLISH refs stay |
| `to-spec` | **Keep WEN** | Already close; product-doc authority remains pack delta |
| `to-questionnaire` | **Keep WEN** | Matt graduated; WEN meeting mode / optioned questions richer |
| `writing-for-agents` | **Take Matt (rename)** | Replaces `writing-great-skills`; + `SKILL-MECHANICS.md`; GLOSSARY dropped (Matt) |
| `wait-what` | **Add new** | Verbatim from Matt |
| `wizard` | **Add new** | Verbatim + `template.sh` from Matt |
| `tdd` | **Merge** | Restored Matt `/codebase-design` consult line; kept WEN “green locks real domain step” |
| `research` | **Keep WEN bounds** | Matt body + disposition / no-mutate |
| `diagnosing-bugs` | **Keep WEN** | Authority gate + design-packet review path |
| `code-review` | **Keep WEN** | Product-doc Spec authority, incomplete surface, UI fidelity |
| `implement` | **Keep WEN** | Multi-agent / incomplete-surface / UI fidelity gates |
| `handoff` | **Identical** | No change |
| `codebase-design` | **Identical** | No change |
| `domain-modeling` | **Identical** | No change |
| `improve-codebase-architecture` | **Identical** | No change |
| `resolving-merge-conflicts` | **Removed** | Upstream plans to drop it; removed from this pack. |
| `triage` | **Add** | Copied from upstream; was the remaining promoted engineering skill this pack lacked. |
| `setup-project` | **Matt body, renamed** | Same scope as `setup-matt-pocock-skills`. Does not rewrite `AGENTS.md`; prose is `writing-for-agents`. Replaces WEN `setup-project-harness`. |
| `ask-process` | **WEN router** | Replaces copying `ask-matt`. Routes this pack's LIGHT tracks (L1–L4, G, Q), PRD inventory, and design pins. |
| Claude plugin / docs pages | **Skip** | Packaging & human docs; WEN uses `sync-skills.sh` |

## WEN-only (untouched by this sync)

`alignment-review`, `product-fog`, `setup-logging`, `simplify`, `skill-review`,
`to-design-md`, plus `agents/` multi-agent pack.

## Follow-ups (optional)

- Codex `agents/openai.yaml` dual-harness metadata (Matt v1.2) if Codex install UX needs it.
- Re-diff `to-spec` / `implement` against next Matt minor when those move again.
- After install: `./scripts/sync-skills.sh --agents all` on machines that used the old `writing-great-skills` name (manifest should drop the deleted skill).
