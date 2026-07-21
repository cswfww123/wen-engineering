# WEN Engineering Skills

默认语言: [English](README.md) | 简体中文

面向真实工程的 AI agent 技能库。

这个仓库用于构建小而可组合的 skills，帮助 Codex、Claude 和其他 coding agents 在不夺走用户控制权的前提下完成有用的工程工作。

目标不是把 agent 变成僵硬的表格填写器。目标是搭建一座桥，连接：

- 用户真正想要的东西
- 代码库已经证明的事实
- agent 可以推断、追问、实现和验证的判断

Rules 是 guardrails。Skills 是可复用的对话。Agent 应该保持聪明，用户应该保留决定性品味和权威，代码库也不应该因为换了一个模型就开始漂移。

这个仓库偏向小而可适配的 skills、对齐式访谈、共享领域语言、反馈循环，以及围绕代码库设计的工程判断；它不会把任何外部风格指南直接变成本项目标准。

## Quickstart

推荐：clone 仓库，把所有 WEN skills 同步到 `~/.agents/skills`，并让 Codex、Claude、ZCode 和 Kimi 都软链到这个共享目录：

```bash
git clone https://github.com/cswfww123/wen-engineering.git
cd wen-engineering
./scripts/sync-skills.sh --agents all
```

这会安装全部 WEN skills，不需要逐个选择。它也会在 `~/.agents/skills` 中创建
manifest，让未来的同步可以删除本仓库已经移除的 skills，同时不触碰用户自己的其他
skills；上游许可说明会以 `WEN_THIRD_PARTY_NOTICES.md` 一并安装。

可选：如果你只想挑选少量 skills，或者安装到 `skills.sh` 支持的某个 agent，可以使用交互式 installer：

```bash
npx skills@latest add cswfww123/wen-engineering
```

交互式 installer 可能不支持每个 agent，也不一定支持完整的更新或删除流程。如果你希望 Codex、Claude、ZCode 和 Kimi 长期与本仓库保持一致，优先使用 `scripts/sync-skills.sh`。

后续更新：

```bash
cd wen-engineering
git pull --ff-only
./scripts/sync-skills.sh --agents all
```

默认情况下，同步会把 WEN skills 复制到 `~/.agents/skills`，然后把每个被选择的 agent skill 目录软链到这个共享目录。如果你希望这个 checkout 中的本地编辑立刻对 agent 可见，可以使用 `--mode link`：

```bash
./scripts/sync-skills.sh --agents all --mode link
```

如果你之前用其他工具安装过同名 skills，同步脚本可能会拒绝覆盖。先检查：

```bash
./scripts/sync-skills.sh --agents all --dry-run
```

当你确定希望由本仓库管理这些 skill 名称，或希望把现有 agent 专属 skill 目录替换成共享软链时，执行一次迁移：

```bash
./scripts/sync-skills.sh --agents all --force
```

使用 `--force` 时，脚本会先把仅存在于 agent 专属目录里的 skills 导入 `~/.agents/skills`，再把旧目录备份为 `*.wen-engineering-backup-*`，最后用软链替换。

对于新项目，同步完成后，在目标项目中运行 **`/setup-project-harness`**。它会配置：

- issue tracker workflow：GitHub、GitLab、本地 markdown，或其他 tracker
- `/to-tickets`、`/implement` 和 tracker adapters 使用的五个 triage roles
- domain documentation layout：单个 `CONTEXT.md`，或多 context 的 `CONTEXT-MAP.md`
- `AGENTS.md`、`CLAUDE.md`、`docs/agents/`，以及仅在有依据时的失败钉（优先 Checklist；长分类器才进 `.agents/rules/`）

这是最快路径。setup 之后，agents 知道项目接线在哪里；证明工作的命令放在 README/scripts/CI。

### 空项目路由

见 [Lifecycle §4 空项目](#4-空项目)。短版：没有工作台 → `/setup-project-harness`
（若只有模糊产品目标则先 HEAVY PM）；日常工作再按 LIGHT 选型。

## Lifecycle

**两条轨。** 默认 **LIGHT**；仅当「产品需求本身」仍模糊时走 **HEAVY**。
边界与例外以这些文档为准：
[docs/lifecycle.md](docs/lifecycle.md) ·
[docs/boundaries.md](docs/boundaries.md) ·
[docs/handoff-package.md](docs/handoff-package.md)。

### 0. 先选轨（一个问题）

```text
产品需求本身还模糊吗？
  （值不值得做、目标用户、市场、「到底做什么」）
    → HEAVY  → 完整 PM，settled 后把包装交接进 LIGHT L2

意图已经够诚实编码吗？
  （bug、有名 AC、已 settled 多切片、纯工程）
    → LIGHT  → 从下表选最小步（能 L1 就 L1）
```

**默认偏好：** `/implement` 够用时，不要开 PM、Wayfinder 或多 skill 流水线。

### 1. 快速选型

| 场景 | 流程 | 入口 → 出口 |
| --- | --- | --- |
| Bug / 清晰 AC / 单一切片 | **L1** | `/implement` → 完成 |
| 已 settled 的多切片包 | **L2** | `/to-spec` → `/to-tickets` → `/implement` |
| 少量开放决策，且**你本人**能同会话拍板 | **G** | `/grill-me` → 会话内收口 → `/implement`（跨会话才归档/`/to-spec`） |
| 答案在 PM/业务；需求澄清会或异步表单 | **Q** | `/to-questionnaire` → 填写 → 贴回 → **`/to-spec`**（不重确认） |
| 已上线但不对 / coding 邻域 Expected 轻度缺口 | **L3** | `/product-fog` → 恰好一条下一跳（G / Q / L2 / L4 / 停 / PM） |
| 产品 OK；技术路线需多会话 | **L4** | 先试 **G** → 否则 `/wayfinder` → 地图 resolved → **L2** |
| 模糊想法、需求未验证 | **HEAVY** | `wen-pm`（或团队 PM）→ 再进 **L2** |
| 构建的系统 QA | 可选 | `wen-test` |

### 2. LIGHT 各流程（明细）

步骤总览（彼此独立，选一条走）：

```text
L1  清晰工作                →  /implement
L2  多切片                  →  /to-spec → /to-tickets → /implement
G   同会话钉住              →  /grill-me  →  会话收口  →  /implement（跨会话才归档 → /to-spec）
Q   干系人问卷              →  /to-questionnaire  →  填写  →  ingest  →  /to-spec
L3  轻度意图钉              →  /product-fog  →  一条下一跳
L4  多会话工程雾            →  /wayfinder  →  (resolved)  →  L2
```

#### L1 — 直接实现（日常默认）

```text
bug | 清晰 AC | 纯工程切片
  → /implement
      （难诊 bug 先 /diagnosing-bugs）
  → evidence loop（TDD 或 GREEN 基线）
  → 非琐碎时 /simplify
  → 项目检查 → /code-review → 完成
```

- **入：** 足够 AC 或单 ticket；禁止编造产品价值。
- **出：** 可 review 的 delta 关闭。不要求父 spec。
- **不要：** 为了「看起来完整」编造 ticket/spec。

#### L2 — Spec → tickets → 实现

```text
已 settled 的包（PRD / 文档 / chat AC / PM 交接 / 已填问卷归档）
  → /to-spec          （non-runnable 父文档；已 settled 答案不重访谈）
  → /to-tickets       （依赖图；implementation frontier）
  → /implement        （一次一张 ticket）
  → （可选）wen-test: /to-test-plan → /qa-run
```

- **入：** 产品意图够写诚实 requirements。
- **出：** frontier 上的切片；父 spec 在工作完成前保持打开。
- **补充：** 切片风险高时 `/alignment-review`；FE/BE 保真在 ticket 层。
- **不要：** 用 `/implement` 关闭父 spec。

#### G — Grill（同会话钉住）

```text
方案仍糊，但决策归你，且一会话问得清
  → /grill-me   （加载 /grilling；仅术语真变时才 domain-modeling）
      frontier 轮次：batch 表 + 推荐；事实优先（非阻塞 sub-agent）
      尽早 MVP 内外；反橡皮图章只压高风险
  → 默认收口：会话内短 recap（不写 decision-*.md）
  → 仅跨会话 / Wayfinder / 你明确要求时才落盘
  → 下一跳：通常同会话 /implement；多切片交接才 /to-spec
```

- **入：** 少量用户可拍板的产品/工程决策；尚不需要多会话地图。
- **出：** 会话内 shared understanding（对齐 Matt 原版）；落盘是例外。
- **升级：** 房间里不是决策人 → **Q**；一会话装不下 → **L4**；值不值得做仍开 → **HEAVY**。
- **不要：** 编造 Expected；简单问题强行产过程文档；把「grill 完」当成可推 shared 分支的授权。

#### Q — 问卷（会中或异步）

```text
开放决策的产品/领域所有权不在你
  → /to-questionnaire
      只烤「发送端」（给谁 + 要带回来什么）
      决策题默认：选项 + 推荐 + 手写(Z)
  → Meeting（需求澄清会）或 Async 填写
  → 贴回：问卷已填 + 路径
  → ingest：已答 Q-id = settled — 不重确认
  → 默认：/to-spec
  → 仅剩工程缝时：短 /grill-me，只烤那些
```

- **入：** 答案在 PM/业务；或需要澄清会议程。
- **出：** 已填问卷 → 折进 **L2**（`/to-spec`…）；不另起长期 decision 文件。
- **不要：** 重问已选项；当成完整产品 discovery；用 Q 顶替 HEAVY PM。

#### L3 — Product fog（薄钉）

```text
返工 / Expected 轻度缺口 /「不太是我想要的」（已在编码上下文）
  → /product-fog   （仅迷你 docket；禁止编造 Expected）
  → 恰好一条下一跳：
        Align        → G 或 Q
        Build-ready  → L2（/to-spec）
        pure-eng     → L1 或 L2
        多会话技术雾 → L4
        Discovery / Pause / Kill / Escalate-PM → 停或 HEAVY
```

- **入：** coding 邻域的意图钉——不是市场调研。
- **出：** 一个 disposition + 一个 skill（或停）。不改 production。

#### L4 — Wayfinder（多会话工程雾）

```text
产品够 settled；技术路线仍跨多会话模糊
  → 若一访谈能清，优先 G
  → /wayfinder
      薄地图（首发 ≤5 票）；research/task 优先于 grill
      短 paste：skills/wayfinder/CONTINUE.md
  → 地图 Status: resolved
  → L2：/to-spec → /to-tickets → /implement
```

- **入：** 需要跨会话共享 frontier 的工程决策。
- **出：** 地图 resolved；**停止** Wayfinder；`/to-spec` 消费 Resolutions（不复烤已关 DEC）。
- **不要：** 在地图里实现 destination；用 ticket 编造产品价值。

### 3. HEAVY — 模糊产品需求

```text
模糊想法 | 未知用户 | 市场赌注 | 「该不该做」
  → 完整产品 discovery
      推荐：wen-pm /pm-intake → … → Build|Bet → to-prd
      或团队 PM 流程
  → settled 包装交接进 LIGHT L2
      /to-spec → /to-tickets → /implement
```

- **禁止** 用 `/implement`、`/to-spec`、Wayfinder 编造产品价值。
- 无 `wen-pm`：停止编造；写明证据缺口。可选 `/product-fog` 仅记录 Discovery / Pause / Kill。

### 4. 空项目

```text
还没有工作台
  → 技术栈/仓库形态已知     → 先 /setup-project-harness
  → 只有产品目标且仍模糊    → 先 HEAVY PM，再 harness + L2
  → 技术栈选择仍开放        → 短 /grill-me → /setup-project-harness
  → 之后日常工作            → 按上方 LIGHT 选型
```

Harness **只记录事实与用户决策**。package manager、framework、证明工作的命令等，
有 scaffold 证据前保持未定义。

### 5. 实现环（L1 / L2 每张 ticket 内）

```text
claim → 行为测试或兼容基线 → simplify → verify → code-review → close
```

可组合支持 skill：`/tdd`、`/simplify`、`/code-review`、`/research`、`/prototype`、
`/domain-modeling`、`/alignment-review`、`/resolving-merge-conflicts`、`/handoff`。

### 6. 命令名（v1.1）

| 现行 | 已退役（仍可作 *输入*） |
| --- | --- |
| `/to-spec` | `/to-prd` — 现有 `PRD.md` 仍有效 |
| `/to-tickets` | `/to-issues` — 现有 `issues/` 仍有效 |
| `/grill-me` | 用户入口；加载 model-invoked `/grilling` |

同步会删除已退役命令的 managed copies；canonical skills 根下未标记的同名 skill
会阻断普通同步（`--force` 先备份再处理）。

## Local Workspace

常用 skills：

- `/alignment-review` 审查 specs 和 tickets 是否对齐 intent、coverage、repo evidence 和执行路径。
- `/codebase-design` 为模块接口、seams 和边界提供深层代码库设计语言。
- `/code-review` 独立审查 fixed delta 的 intent、correctness、ponytail、性能、安全与规范（含 Fowler smell 基线）。
- `/diagnosing-bugs` 用反馈循环诊断复杂 bug 和性能回归。
- `/domain-modeling` 在设计决策结晶时锐化 glossary，并稀疏记录 ADR。
- `/implement` 把一个 bounded task 或 implementation-frontier ticket 完整推进到匹配的 evidence loop、simplification、verification、code review 和 tracker completion。
- `/grill-me` stress-test **工程** plan（同会话钉住）；加载 `/grilling`；仅术语真变时 domain-modeling；**默认会话内收口、不强制 decision 文件**。房间里不是决策人时路由到 `/to-questionnaire`。
- `/grilling` 可复用访谈循环：**frontier 轮次**（按依赖批问，非串行微问题）、非阻塞事实 sub-agent、反橡皮图章、确认门。
- `/to-questionnaire` 把干系人缺口变成会中议程或异步问卷（选项 + 推荐 + 手写）；贴回后 ingest、不重问 → 默认 `/to-spec`。
- `/handoff` 为新的 agent 写一份紧凑 handoff document。
- `/improve-codebase-architecture` 扫描代码库中的 deepening opportunities，并写出可视化 HTML report。
- `/prototype` 为显式问题或 Wayfinder ticket 创建 disposable logic/state 或 UI evidence artifact。
- `/research` 为显式问题或 Wayfinder ticket 保存带引用的 primary-source evidence。
- `/resolving-merge-conflicts` 按双方意图解决进行中的 git merge/rebase 冲突。
- `/simplify` 清理非微小改动后的代码，关注复用、简化、效率和正确层级。
- `/setup-project-harness` 初始化项目级 agent harness。
- `/skill-review` 在接受新增或修改后的 skill 前进行审查。
- `/tdd` red → green 参考（seams、反模式）；正文贴近 Matt 上游。
- `/to-spec` 把 settled context 转成带稳定 requirements 的 non-runnable spec。
- `/to-tickets` 把 approved spec 转成 dependency-aware ticket graph 和 typed frontiers。
- `/product-fog` LIGHT 意图钉（编码邻域迷你 docket + 一条下一跳；非完整 PM）。
- `/wayfinder` 将跨会话雾清成薄 decision ticket map（短 paste、research 优先），结案后交接 `/to-spec`。
- `/writing-great-skills` 提供写作和编辑 predictable skills 的 reference。

Harness skill 会创建：

- `AGENTS.md` 作为共享入口：路径接线 + 可选的失败 Checklist
- 指向 `AGENTS.md` 的 `CLAUDE.md`
- `docs/agents/` 下的 tracker / labels / domain 文档
- 仅当真实失败需要超过一行 Checklist 时才写 `.agents/rules/**`（例如 `invariants/`）

## Why This Exists

AI agents 会以很可预测的方式失败。

### #1: Agent 猜错了项目边界

大多数项目不是因为模型不会写代码而失败。它们失败是因为模型不知道本地边界：哪一层拥有逻辑，哪个命名约定重要，哪个命令能证明成功，团队已经做过什么 tradeoff。

解决办法是 project harness：一个小的 `AGENTS.md` 入口（接线 + 会折旧的 Checklist 钉），加上 tracker/domain 文档——而不是不断膨胀的 rules 宪法。

### #2: 用户和 Agent 没有对齐

用户往往先知道“什么感觉是对的”，然后才说得出完整 spec。Agents 有价值，是因为它们可以提问、推荐、综合，并把隐含内容说清楚。

解决办法是 interview-driven setup。Skill 先读 repo，在 repo evidence 支持时带着推荐默认值出现，然后只 grill 那些 repo 无法回答的决策。

### #3: 永久说明变成了噪音

太多 harness 会过度修正。它们把通用 best practice 塞进 always-loaded 上下文，反而让 agent 变差。

解决办法是失败驱动、会折旧的钉：

- 真实翻车后 → 一条 Checklist（只有放不下时才写 `.agents/rules/` 长分类器）
- 当前模型不再踩 → 删掉
- 绝不重述模型默认就会的能力

### #4: 代码库失去了自己的语言

当 agents 不共享项目 vocabulary 时，它们会写出冗长解释、不一致命名和别扭抽象。

解决办法是 progressive disclosure：让 `AGENTS.md` 保持简短，把 domain language 放进 `CONTEXT.md`，把 architecture decisions 放进 `docs/adr/`，长边界仅在工作匹配时再加载（例如 invariants）。

## Skills

### Planning And Alignment

- [`alignment-review`](skills/alignment-review/SKILL.md) - 审查 specs 和 tickets 的 intent、coverage、evidence 和 execution fit。
- [`domain-modeling`](skills/domain-modeling/SKILL.md) - 锐化领域语言、更新 `CONTEXT.md`，并在决策结晶时稀疏记录 ADR。
- [`grill-me`](skills/grill-me/SKILL.md) - 用户调用的同会话 plan pin（LIGHT G）；加载 `/grilling`，MVP 边界；默认会话收口、无强制归档。
- [`grilling`](skills/grilling/SKILL.md) - model-invoked 访谈循环：frontier 轮次 + batch 表、非阻塞事实、反橡皮图章、确认门。
- [`to-questionnaire`](skills/to-questionnaire/SKILL.md) - 干系人问卷（选项 + 推荐 + 手写）；填完不复烤，默认进 `/to-spec`（LIGHT Q）。
- [`product-fog`](skills/product-fog/SKILL.md) - LIGHT 意图钉：编码邻域迷你 docket + 一条下一跳（非完整 PM）。
- [`wayfinder`](skills/wayfinder/SKILL.md) - 多会话薄 map + 短 paste；结案后 `/to-spec`（见 `CONTINUE.md`）。
- [`research`](skills/research/SKILL.md) - 为显式问题或 active Wayfinder ticket 保存带引用的 primary-source evidence。
- [`prototype`](skills/prototype/SKILL.md) - 创建 bounded disposable logic/state 或 UI evidence，不修改 tracker 或 production state。
- [`to-spec`](skills/to-spec/SKILL.md) - 把 settled context 转成带稳定 requirements 的 non-runnable spec。
- [`to-tickets`](skills/to-tickets/SKILL.md) - 把 approved spec 转成 dependency-aware one-context tickets。
- [`implement`](skills/implement/SKILL.md) - 把一个 bounded task 或 implementation-frontier ticket 推进到 testing 或 compatibility evidence、review 和 verification。
- [`tdd`](skills/tdd/SKILL.md) - red → green + seams（Matt 底）。
- [`handoff`](skills/handoff/SKILL.md) - 为新的 agent 写一份紧凑 handoff document，并保存在 repo 外。
- [`resolving-merge-conflicts`](skills/resolving-merge-conflicts/SKILL.md) - 按双方意图解决进行中的 git merge/rebase 冲突。

### Review And Quality

- [`code-review`](skills/code-review/SKILL.md) - 审查 diffs/PRs：intent、bug、incomplete production surface（阻断）、ponytail、性能、安全、规范（含 Fowler smell 基线）。
- [`diagnosing-bugs`](skills/diagnosing-bugs/SKILL.md) - 在改代码前先建立 feedback loop，用于诊断 bugs 和性能回归。
- [`simplify`](skills/simplify/SKILL.md) - 清理非微小改动后的代码，关注复用、简化、效率和正确层级。

### Architecture

- [`codebase-design`](skills/codebase-design/SKILL.md) - 为 module interfaces、seams、adapters、leverage 和 locality 提供深层模块语言。
- [`improve-codebase-architecture`](skills/improve-codebase-architecture/SKILL.md) - 扫描代码库中的 deepening opportunities，并写出可视化 HTML report。

### Engineering Harness

- [`setup-project-harness`](skills/setup-project-harness/SKILL.md) - 为 Codex 和 Claude 构建 minimal、evidence-first 的 project harness。适用于 frontend、backend、full-stack、library、CLI、monorepo、empty starter 或 engineering-skills repos。
- [`skill-review`](skills/skill-review/SKILL.md) - 审查 skills 的 discovery、trigger clarity、progressive disclosure 和 judgment-preserving guidance。
- [`writing-great-skills`](skills/writing-great-skills/SKILL.md) - 提供写作 predictable skills 的 vocabulary 和 principles。

## Skill Design Principles

- **Matt 优先：** 共享 skill 正文贴近
  [`mattpocock/skills`](https://github.com/mattpocock/skills)；WEN 只叠 pack
  增量（harness 名、lifecycle、权限门、multi-agent、模板）。
- 小胜过全。
- Instructions 应该创造更好的协作，而不是移除 autonomy。
- 先读 repo evidence，再提问。
- 只在用户意图或品味起决定作用时提问。
- 优先使用 progressive disclosure，而不是一个巨大的 prompt。
- 把永久指令当作会折旧的资产：剪掉 no-op、过时就 empty-rewrite、从真实失败再加护栏。
- 用 rules 捕获边界，不写泛泛建议。
- 把 verification 放进 workflow。
- 在 divergence 不危险的地方保留 model judgment。
- orchestration 和 side effects 用 user-invoked skills；可复用 discipline 用 model-invoked skills。

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
    DISPATCH.md
    AGENT-BRIEFS.md
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

这个仓库当前关注 **轻量、evidence-first 的 coding lifecycle**：

- 初始化可信的 project harness 和共享 agent entrypoint
- 可单独用，也可与 `wen-pm` / `wen-test` 联动（无硬依赖）
- 接受任意 settled 产品输入
- 支持仅前端 / 仅后端 / 全栈的层级门禁
- 默认跨会话编码路径：settled intent → `/to-spec` → `/to-tickets` → `/implement`
- 日常默认 LIGHT；模糊产品需求 HEAVY（可选 `wen-pm` 先做）
- 多会话工程雾：`/wayfinder`（薄 map + 短 paste）→ `/to-spec` → `/to-tickets` → `/implement`
- 系统测试/QA 由可选 `wen-test` 或人工/CI 负责
- 用 non-runnable specs 和可追踪 ticket DAGs 保存 intent
- 让一个 isolated implementation-frontier ticket 完整经过正确的 evidence loop、simplification、review 和 verification
- 把 research 和 prototypes 用作 bounded evidence
- 系统测试设计/QA 交给可选 companion `wen-test`
- 通过 `~/.agents/skills` 保持 Codex、Claude、ZCode 和 Kimi 对齐

设计保持 tracker-neutral 和 context-aware：小任务维持小规模；雾状大型工作用
Wayfinder map 与 fresh execution contexts；无用户授权不编造产品答案。

## Upstream Attribution

WEN 借鉴并改造了
[Matt Pocock's Skills for Real Engineers v1.1.0](https://github.com/mattpocock/skills/tree/v1.1.0)
中的 lifecycle 和 skill-design ideas，再加入 WEN 的 harness、tracker、review、
verification 和 multi-agent contracts。准确 source revision、改造说明和 MIT license
见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。

## Contributing Skills

一个 skill 应该：

- 足够简洁，可以快速加载
- 足够具体，可以正确触发
- 足够灵活，可以保留 agent judgment
- 足够结构化，让重复使用产生一致产物

优先选择：

- 一个 `SKILL.md` 承载核心 workflow
- reference files 承载 templates 或少用细节
- scripts 只用于确定性的重复操作

避免：

- 泛泛的 best-practice dumps
- 重复正常 LLM 能力的 rules
- 固定那些本应从 repo 发现或由用户决定的 defaults
- 让每个任务都为所有可能上下文付费的巨大 prompts

例外：严格的 setup/init skills 是 process specifications。只要完整性可以避免初始化失败，它们可以更长。

## Philosophy

使用 agents 做真实工程，本质是一个 feedback loop：

```text
read the codebase -> align with the user -> define the boundary -> change in small slices -> verify -> improve the harness
```

最好的 skills 不会占有流程。它们让流程更容易被掌舵。
