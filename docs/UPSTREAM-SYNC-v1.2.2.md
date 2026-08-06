# Upstream sync — mattpocock/skills v1.2.2

Pin: `8b36d4fb2635b3c21998dcd8144439c9e5ba7302` (tag `v1.2.2`, 2026-08-05).  
Prior pin: `e9fcdf95b402d360f90f1db8d776d5dd450f9234` (post-v1.1.0).

Principle: **Matt-first** on shared skill bodies; WEN only layers pack deltas
(harness name `/setup-project-harness`, lifecycle, authority, multi-agent,
optional templates).

## Decision table

| Skill | Action | Notes |
| --- | --- | --- |
| `grilling` | **Take Matt + WEN delta** | Round/frontier + `❓`/`➡️` format from Matt; batch tables, PRD, rubber-stamp, next-hop from WEN |
| `grill-me` | **Keep WEN** | Matt is one line; pack owns product-doc authority, close gate, implement handoff |
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
| `resolving-merge-conflicts` | **Identical** | No change |
| `setup-project-harness` | **Keep WEN** | Pack rename of `setup-matt-pocock-skills`; not replaced |
| `ask-matt` | **Skip** | WEN routes via lifecycle / wayfinder / harness, not Matt router |
| Claude plugin / docs pages | **Skip** | Packaging & human docs; WEN uses `sync-skills.sh` |

## WEN-only (untouched by this sync)

`alignment-review`, `product-fog`, `setup-logging`, `simplify`, `skill-review`,
`to-design-md`, plus `agents/` multi-agent pack.

## Follow-ups (optional)

- Codex `agents/openai.yaml` dual-harness metadata (Matt v1.2) if Codex install UX needs it.
- Re-diff `to-spec` / `implement` against next Matt minor when those move again.
- After install: `./scripts/sync-skills.sh --agents all` on machines that used the old `writing-great-skills` name (manifest should drop the deleted skill).
