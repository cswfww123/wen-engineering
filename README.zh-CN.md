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
- `AGENTS.md`、`CLAUDE.md`、`docs/agents/`，以及聚焦的 `.agents/rules/**`

这是最快路径。setup 之后，agents 会知道项目指令在哪里、应该加载哪些 rules，以及哪些命令能证明工作完成。

### 空项目路由

空项目里，按「已经知道什么」选择入口：

- 如果技术栈或仓库形态已经确定，先运行 `/setup-project-harness`。它会先建立工作台：`AGENTS.md`、`CLAUDE.md`、`docs/agents/`、`.agents/rules/**` 和本地 scratch 空间。
- 如果只有产品目标，价值/用户/outcome 仍开放，先在 PM 工作区做 `/pm-intake`，不要用 engineering Wayfinder 编造产品答案。
- 如果产品意图已够 settled，但技术栈仍开放，做一轮很短的 `/grill-with-docs`（只压工程约束），再 `/setup-project-harness`。
- 一旦方向足够清楚，可以写出诚实的项目指令，就切到 `/setup-project-harness`；harness 建好后，再继续技术 grill。

口诀：没工作台，先 setup；产品价值未清，先 PM；栈未清，先 micro-grill；方向够建立工作台了，立刻 setup，然后继续细化。

在空仓库中，harness 只能记录事实和用户决策。package manager、framework、build、lint、typecheck、test 命令都应该等到 scaffold 有证据之后再补，不能提前编造。

## Lifecycle

流程由工作形态决定，不是每个请求都必须填写的固定表单。本仓库保持 **coding
轻量** 且 **不强制 wen-pm**：产品探索用团队既有流程（可选 companion PM）。
工作可仅为前端、仅为后端或全栈。完整契约见
[docs/lifecycle.md](docs/lifecycle.md)、[docs/boundaries.md](docs/boundaries.md)
与 [docs/handoff-package.md](docs/handoff-package.md)。

### 0. 产品雾 → 产品负责人（不在这里编造）

```text
product / market / need fog -> 团队产品流程（可选 /pm-intake）
```

不要用 Wayfinder 或 `/to-spec` 编造用户价值或 Expected 行为。

### 1. 清晰且有边界的工作

```text
bounded task -> /implement
```

当产品意图足够 settled，且一个 fresh context 足以容纳任务和 acceptance
boundary 时，直接使用 `/implement`。它负责匹配工作形态的 evidence loop
（行为变更使用 TDD，behavior-preserving work 使用精确的 GREEN baseline）、
simplification、项目 verification、独立的 `/code-review` gate，以及完成情况汇报。

### 2. 已沉淀的多切片工作（默认跨会话路径）

```text
settled product package -> /to-spec -> /to-tickets -> /implement
```

优先使用任意已 settled 的交付输入（可选 wen-pm、其他 PRD、仓库文档）。
按 ticket 的 **Layer** 定门禁：纯后端不要求 UI 钉死；纯前端不要求实现 API。
见 [docs/handoff-package.md](docs/handoff-package.md)。
`/to-spec` → `/to-tickets` → `/implement` 使用开发者行为门 + 层级保真门。系统 QA 为可选 companion `wen-test`。
同会话技术压方案用 `/grill-with-docs`。

可选系统 QA（`wen-test` `/qa-run`）可把已确认 one-context defect 发布为 implementation ticket；
更大或尚未充分诊断的 defect 会保持为 non-runnable `bug-report` intake，并标记
`needs-triage`，直到被显式转换，或进入 spec/ticket 切片流程。

### 3. 技术多会话雾（高级、少用）

```text
settled product + technical fog -> /wayfinder -> /to-spec -> /to-tickets
```

`/wayfinder` 只做可选的 **工程** discovery：产品已 settled 后的迁移、契约、
seams 等多会话技术雾。每个 session 最多一张 discovery ticket。`/research` 与
`/prototype` 只产 bounded evidence。

### v1.1 命令迁移

`/to-spec` 替代 `/to-prd`，`/to-tickets` 替代 `/to-issues`。旧 slash commands
已经退役，但现有 `PRD.md`、`issues/`、链接和 tracker objects 仍是有效的 legacy
inputs，也不会为了新术语被原地重命名。
同步会删除旧命令的 managed copies；如果 canonical skills 目录中存在未标记的同名
skill，普通同步会安全阻断，`--force` 则会先把它备份到 active skills root 之外。

## Local Workspace

常用 skills：

- `/alignment-review` 审查 specs、tickets 和 test plans 是否对齐 intent、coverage、repo evidence 和执行路径。
- `/codebase-design` 为模块接口、seams 和边界提供深层代码库设计语言。
- `/code-review` 独立审查一个 fixed delta 的 intent、correctness、ponytail 复杂度、性能、安全和规范。
- `/diagnosing-bugs` 用反馈循环诊断复杂 bug 和性能回归。
- `/domain-modeling` 在设计决策结晶时打磨 glossary terms 并记录 ADRs。
- `/implement` 把一个 bounded task 或 implementation-frontier ticket 完整推进到匹配的 evidence loop、simplification、verification、code review 和 tracker completion。
- `/grill-with-docs` 在维护 glossary 和 ADR docs 的同时 stress-test **工程** plan。
- `/handoff` 为新的 agent 写一份紧凑 handoff document。
- `/improve-codebase-architecture` 扫描代码库中的 deepening opportunities，并写出可视化 HTML report。
- `/prototype` 为显式问题或 Wayfinder ticket 创建 disposable logic/state 或 UI evidence artifact。
- `/research` 为显式问题或 Wayfinder ticket 保存带引用的 primary-source evidence。
- `/simplify` 清理非微小改动后的代码，关注复用、简化、效率和正确层级。
- `/setup-project-harness` 初始化项目级 agent harness。
- `/skill-review` 在接受新增或修改后的 skill 前进行审查。
- `/tdd` 通过 public behavior tests 引导 Red-Green-Refactor 实现。
- `/to-spec` 把 settled context 转成带稳定 requirements 的 non-runnable spec。
- `/to-tickets` 把 approved spec 转成 dependency-aware ticket graph 和 typed frontiers。
- `/wayfinder`（高级）将跨会话 **技术** 雾清到可写 honest engineering spec 为止。
- `/writing-great-skills` 提供写作和编辑 predictable skills 的 reference。

Harness skill 会创建：

- `AGENTS.md`，作为共享入口和 source of truth
- 指向 `AGENTS.md` 的 `CLAUDE.md`
- `.agents/rules/` 下的详细标准
- 按语言或领域拆分的 rule files，例如 `typescript/`、`java/`、`frontend/`、`backend/`、`api/`、`database/`、`testing/` 或 `skills/`

## Why This Exists

AI agents 会以很可预测的方式失败。

### #1: Agent 猜错了项目边界

大多数项目不是因为模型不会写代码而失败。它们失败是因为模型不知道本地边界：哪一层拥有逻辑，哪个命名约定重要，哪个命令能证明成功，团队已经做过什么 tradeoff。

解决办法是 project harness：一个小的 `AGENTS.md` 入口，加上聚焦的 `.agents/rules/**` 文件，记录未来 agents 原本会反复重新发现或互相矛盾的决策。

### #2: 用户和 Agent 没有对齐

用户往往先知道“什么感觉是对的”，然后才说得出完整 spec。Agents 有价值，是因为它们可以提问、推荐、综合，并把隐含内容说清楚。

解决办法是 interview-driven setup。Skill 先读 repo，在 repo evidence 支持时带着推荐默认值出现，然后只 grill 那些 repo 无法回答的决策。

### #3: Rules 变成了笼子

太多 harness 会过度修正。它们用 checklist 取代 judgment，反而让 agent 变差。

解决办法是 severity-aware rules：

- `[MUST]` 用于真正影响正确性、一致性、安全性或可维护性的边界
- `[SHOULD]` 用于强默认值，但允许 judgment 胜过规则
- `[FORBID]` 用于已知有害的选择

最好的 rule files 会防止可预测漂移，同时给 human taste 和 agent intelligence 留出空间。

### #4: 代码库失去了自己的语言

当 agents 不共享项目 vocabulary 时，它们会写出冗长解释、不一致命名和别扭抽象。

解决办法是 progressive disclosure：让 `AGENTS.md` 保持简短，把 domain language 放进 `CONTEXT.md`，把 architecture decisions 放进 `docs/adr/`，把详细 standards 放进 `.agents/rules/**`。

## Skills

### Planning And Alignment

- [`alignment-review`](skills/alignment-review/SKILL.md) - 审查 specs、tickets 和 test plans 的 intent、coverage、evidence 和 execution fit。
- [`domain-modeling`](skills/domain-modeling/SKILL.md) - 打磨 domain language，更新 `CONTEXT.md`，并在决策结晶时少量记录 ADRs。
- [`grill-with-docs`](skills/grill-with-docs/SKILL.md) - 运行 `/grilling` 并同时激活 `/domain-modeling`，作为常规 plan-sharpening 入口。
- [`grilling`](skills/grilling/SKILL.md) - 提供 grill skills 使用的一次一个问题的核心访谈协议。
- [`wayfinder`](skills/wayfinder/SKILL.md) - 高级技术多会话 discovery，直到可写 honest engineering spec。
- [`research`](skills/research/SKILL.md) - 为显式问题或 active Wayfinder ticket 保存带引用的 primary-source evidence。
- [`prototype`](skills/prototype/SKILL.md) - 创建 bounded disposable logic/state 或 UI evidence，不修改 tracker 或 production state。
- [`to-spec`](skills/to-spec/SKILL.md) - 把 settled context 转成带稳定 requirements 的 non-runnable spec。
- [`to-tickets`](skills/to-tickets/SKILL.md) - 把 approved spec 转成 dependency-aware one-context tickets。
- [`implement`](skills/implement/SKILL.md) - 把一个 bounded task 或 implementation-frontier ticket 推进到 testing 或 compatibility evidence、review 和 verification。
- [`tdd`](skills/tdd/SKILL.md) - 通过 vertical Red-Green-Refactor cycles 和 public behavior tests 引导实现。
- [`handoff`](skills/handoff/SKILL.md) - 为新的 agent 写一份紧凑 handoff document，并保存在 repo 外。

### Review And Quality

- [`code-review`](skills/code-review/SKILL.md) - 审查本地 diffs 或 PRs，关注意图对齐、bug、ponytail 复杂度、性能、安全和规范。
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

- 小胜过全。
- Instructions 应该创造更好的协作，而不是移除 autonomy。
- 先读 repo evidence，再提问。
- 只在用户意图或品味起决定作用时提问。
- 优先使用 progressive disclosure，而不是一个巨大的 prompt。
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
    0004-wen-lifecycle.md
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
    AGENT-BRIEFS.md
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
  grill-with-docs/
    SKILL.md
  grilling/
    SKILL.md
  handoff/
    SKILL.md
  implement/
    SKILL.md
  improve-codebase-architecture/
    HTML-REPORT.md
    SKILL.md
  prototype/
    LOGIC.md
    SKILL.md
    UI.md
  research/
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
    refactoring.md
    tests.md
  to-spec/
    SKILL.md
    TEMPLATE.md
  to-tickets/
    EXPAND-CONTRACT.md
    SKILL.md
    TEMPLATE.md
  wayfinder/
    SKILL.md
    TEMPLATES.md
  writing-great-skills/
    GLOSSARY.md
    SKILL.md
```

## Current Focus

这个仓库当前关注 **轻量、evidence-first 的 coding lifecycle**：

- 初始化可信的 project harness 和共享 agent entrypoint
- 不强制 wen-pm；接受任意 settled 产品输入
- 支持仅前端 / 仅后端 / 全栈的层级门禁
- 默认跨会话编码路径：settled intent → `/to-spec` → `/to-tickets` → `/implement`
- 系统测试/QA 由可选 companion `wen-test` 负责
- 可选技术 `/wayfinder` 仅用于多会话工程雾
- 用 non-runnable specs 和可追踪 ticket DAGs 保存 intent
- 让一个 isolated implementation-frontier ticket 完整经过正确的 evidence loop、simplification、review 和 verification
- 把 research 和 prototypes 用作 bounded **工程** evidence
- 系统测试设计/QA 交给可选 companion `wen-test`
- 通过 `~/.agents/skills` 保持 Codex、Claude、ZCode 和 Kimi 对齐

设计保持 tracker-neutral 和 context-aware：小任务维持小规模；产品雾离开本包；
技术大型工作才获得 durable artifacts 与 fresh execution contexts。

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
