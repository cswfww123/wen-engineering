# AGENTS.md

WEN Engineering Skills pack. Optional: `wen-pm` / `wen-test`.

## Code is the environment

> **The code is the environment your agent runs in.**

Every skill, grill, ticket, and review in this pack must uphold that:

- **Authoritative now:** production code, tests, open tracker items, short invariants — not closed process notes or month-old decision docs.
- **Product intent when building:** requirements enter `/grill-code` by default (sweep first); under an active product requirements / PRD / eng spec the grill frontier stays on residual eng seams or **explicit** accepted `相对 PRD` deltas. Session AC must not silently supersede a detailed product doc. Gates: `skills/to-spec/PRD-AUTHORITY.md` (entry/mode lock, Inventory, delta lock, last-ticket prd-walk).
- **Act inside the environment:** prefer existing wire values, APIs, enums, and identity patterns; treat dangerous legacy as **do-not-copy**, never as a template to spread. Same-surface chrome: **extend the owner** already on that screen — lookalikes are do-not-ship (`skills/code-review/SAME-SURFACE.md`).
- **Environment change is explicit:** renaming protocols, relaxing isolation, silent identity fallbacks → only when the user asks for a migration, not as “cleaner” drive-by design.
- **Process docs are scaffolding:** same-session work defaults to chat; durable archives only for real handoff. After consume/close, do not reload them as law; never invent paperwork for thoroughness.
- **Conflicts:** code wins over stale process docs for *what ships today* — resolve from the repo, do not interview the user to pick “which document.” Active product requirements vs code = implement the gap or get an authorized delta; do not “code wins” product intent away.

Routing and hygiene detail: `skills/ask-process/LIFECYCLE.md` (Environment and artifact hygiene).

## Wiring

- Tracker / labels / domain: `docs/agents/`
- Subagents: `agents/` Executor · Reviewer · Verifier — try then fall back (`agents/README.md`)

## Source of truth → install (do not edit live agent dirs)

- **Canonical source is this repo** (`skills/`, `agents/`, `docs/`, root `AGENTS.md`, etc.). Prefer editing here so changes are reviewable and versioned.
- **After edits, install/sync to the machine** so Codex / Claude / ZCode / Kimi pick them up, e.g.:
  - full install: `./scripts/sync-skills.sh --agents all`
  - live-edit checkout: `./scripts/sync-skills.sh --agents all --mode link`
- **Do not edit `~/.agents/**` or `~/.zcode/**` (or other agent skill roots) as the primary change.** Those are install targets (copy or symlink). Patching them directly skips git, drifts from this pack, and is easy to lose on the next sync.
- Exception: purely local, non-pack user skills that this repo does not own — still never “fix pack bugs” only under `~`.

## WEN ↔ Matt Pocock Skills 映射关系（强制约束）

**基于版本:** Matt Pocock Skills v1.3.1

WEN Engineering 基于 Matt Pocock 的 skills 优化而来，但有独有改进和命名。**禁止**建议创建 Matt 已有但 WEN 已映射的 skills。

### 核心映射（1:1）

| Matt Skill | WEN Skill | 映射关系 |
|-----------|-----------|----------|
| `ask-matt` | `ask-process` | 路由器 - WEN 版本，禁止新建 ask-matt |
| `setup-matt-pocock-skills` | `setup-project` | 项目初始化 - WEN 版本 |
| `grill-with-docs` | `grill-code` | 需求面试 + 代码 - WEN 版本更强大 |
| 其他 engineering skills | 同名 | code-review, implement, tdd, etc. |
| 其他 productivity skills | 同名 | grill-me, grilling, wait-what, etc. |

### WEN 独有 Skills（Matt 没有）

禁止因为"Matt 没有"而建议删除这些 WEN 特色功能：

- `alignment-review` - 对齐审查
- `product-fog` - 产品迷雾处理
- `harvest-pins` - Pin 收集和管理
- `setup-logging` - 日志系统设置
- `show-me` - 功能展示
- `simplify` - 简化重构
- `to-design-md` - 设计文档生成

### Matt 独有但 WEN 已新增（v1.3.1 移植完成 2026-10-08）

- `pr` - PR 摘要生成（before/after 证据 + merge-danger）✅ 已新增
- `retro` - 会话回顾和环境改进 ✅ 已新增
- `teach` - 教学类 skill（低优先级，未新增）

### 命名约定同步

**v1.3.x breaking change:**
- `CONTEXT.md` → `GLOSSARY.md`
- `CONTEXT-MAP.md` → `GLOSSARY-MAP.md`

已迁移完成，禁止使用旧命名。

## Checklist

- [ ] After skill edits: frontmatter, description length, one-level refs, README/index
- [ ] After skill/agent pack edits: sync/install to the machine (`scripts/sync-skills.sh`), not hand-edit `~/.agents` / `~/.zcode`
