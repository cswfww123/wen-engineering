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

空项目里，先用 `/setup-project-harness` 还是先用 `/grill-with-docs`，取决于已经知道什么：

- 如果技术栈或仓库形态已经确定，先运行 `/setup-project-harness`。它会先建立工作台：`AGENTS.md`、`CLAUDE.md`、`docs/agents/`、`.agents/rules/**` 和本地 scratch 空间。
- 如果你只有一个目标，技术栈还不清楚，先做一轮很短的 `/grill-with-docs`。只问到足够判断项目类型、目标用户、核心约束，以及哪些技术栈决策仍然开放。
- 一旦方向足够清楚，可以写出诚实的项目指令，就切到 `/setup-project-harness`；harness 建好后，再继续 grill 产品、架构或技术选型细节。

口诀：没工作台，先 setup；没方向，先 micro-grill；方向够建立工作台了，立刻 setup，然后继续细化。

在空仓库中，harness 只能记录事实和用户决策。package manager、framework、build、lint、typecheck、test 命令都应该等到 scaffold 有证据之后再补，不能提前编造。

## Lifecycle

流程由工作形态决定，不是每个请求都必须填写的固定表单。完整的 artifact、
frontier、review 和 concurrency 契约见 [docs/lifecycle.md](docs/lifecycle.md)。

### 1. 清晰且有边界的工作

```text
bounded task -> /implement
```

当一个 fresh context 足以容纳任务和 acceptance boundary 时，直接使用
`/implement`。它负责匹配工作形态的 evidence loop（行为变更使用 TDD，
behavior-preserving work 使用精确的 GREEN baseline）、simplification、项目
verification、独立的 `/code-review` gate，以及完成情况汇报。

### 2. 已沉淀的多切片工作

```text
settled context -> /to-spec -> /to-tickets -> /implement per implementation-frontier ticket
```

`/to-spec` 发布带稳定 requirement IDs 的 non-runnable parent；
`/to-tickets` 通常创建带显式 blocking edges 的 one-context vertical slices；
其命名的 expand-contract 分支处理大范围 mechanical migration，而不会假装它新增了行为。
当 intent 或切片风险较高时使用 `/alignment-review`；需要持久 coverage design
时使用 `/to-test-plan`；需要 runtime evidence 判断 release completion 时使用
`/qa-run`。

QA 可以把已确认且适合 one-context 的 defect 直接发布为 implementation ticket；
更大或尚未充分诊断的 defect 会保持为 non-runnable `bug-report` intake，并标记
`needs-triage`，直到被显式转换，或进入 spec/ticket 切片流程。

### 3. 巨大、模糊、跨会话的工作

```text
foggy effort -> /wayfinder -> settled decisions -> /to-spec -> /to-tickets
```

`/wayfinder` 负责绘制 discovery map，每个 session 最多解决一个 discovery
ticket。`/research` 和 `/prototype` 可以为 map 产出 bounded evidence；tracker
发布和 closure 仍由 user-invoked orchestration 负责。

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
- `/grill-with-docs` 在维护 glossary 和 ADR docs 的同时 stress-test 一个 plan。
- `/handoff` 为新的 agent 写一份紧凑 handoff document。
- `/improve-codebase-architecture` 扫描代码库中的 deepening opportunities，并写出可视化 HTML report。
- `/prototype` 为显式问题或 Wayfinder ticket 创建 disposable logic/state 或 UI evidence artifact。
- `/qa-run` 执行已批准的 QA cases，记录 evidence，判断完成度，并提交 confirmed defects。
- `/research` 为显式问题或 Wayfinder ticket 保存带引用的 primary-source evidence。
- `/simplify` 清理非微小改动后的代码，关注复用、简化、效率和正确层级。
- `/setup-project-harness` 初始化项目级 agent harness。
- `/skill-review` 在接受新增或修改后的 skill 前进行审查。
- `/tdd` 通过 public behavior tests 引导 Red-Green-Refactor 实现。
- `/to-spec` 把 settled context 转成带稳定 requirements 的 non-runnable spec。
- `/to-tickets` 把 approved spec 转成 dependency-aware ticket graph 和 typed frontiers。
- `/to-test-plan` 从 specs 或 tickets 设计可追踪 test cases，但不执行它们。
- `/wayfinder` 为巨大、模糊、跨会话的工作绘制并解决 discovery 路径。
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
- [`wayfinder`](skills/wayfinder/SKILL.md) - 为巨大、模糊、跨会话的工作绘制并解决 discovery 路径。
- [`research`](skills/research/SKILL.md) - 为显式问题或 active Wayfinder ticket 保存带引用的 primary-source evidence。
- [`prototype`](skills/prototype/SKILL.md) - 创建 bounded disposable logic/state 或 UI evidence，不修改 tracker 或 production state。
- [`to-spec`](skills/to-spec/SKILL.md) - 把 settled context 转成带稳定 requirements 的 non-runnable spec。
- [`to-tickets`](skills/to-tickets/SKILL.md) - 把 approved spec 转成 dependency-aware one-context tickets。
- [`to-test-plan`](skills/to-test-plan/SKILL.md) - 从 specs 或 tickets 设计可追踪 test plans 和 cases。
- [`implement`](skills/implement/SKILL.md) - 把一个 bounded task 或 implementation-frontier ticket 推进到 testing 或 compatibility evidence、review 和 verification。
- [`tdd`](skills/tdd/SKILL.md) - 通过 vertical Red-Green-Refactor cycles 和 public behavior tests 引导实现。
- [`handoff`](skills/handoff/SKILL.md) - 为新的 agent 写一份紧凑 handoff document，并保存在 repo 外。

### Review And Quality

- [`code-review`](skills/code-review/SKILL.md) - 审查本地 diffs 或 PRs，关注意图对齐、bug、ponytail 复杂度、性能、安全和规范。
- [`diagnosing-bugs`](skills/diagnosing-bugs/SKILL.md) - 在改代码前先建立 feedback loop，用于诊断 bugs 和性能回归。
- [`qa-run`](skills/qa-run/SKILL.md) - 执行 QA cases，记录 evidence，判断完成度，并提交 confirmed defects。
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
scripts/
  sync-skills.sh
  test-sync-skills.sh
skills/
  alignment-review/
    SKILL.md
    CHECKLIST.md
  codebase-design/
    SKILL.md
    DEEPENING.md
    DESIGN-IT-TWICE.md
  code-review/
    AGENT-BRIEFS.md
    SKILL.md
    PROJECT-LENSES.md
    REVIEW-AXES.md
  diagnosing-bugs/
    SKILL.md
    ATTRIBUTION.md
    scripts/
      hitl-loop.template.sh
  domain-modeling/
    SKILL.md
    ADR-FORMAT.md
    CONTEXT-FORMAT.md
  implement/
    SKILL.md
  grill-with-docs/
    SKILL.md
  grilling/
    SKILL.md
  handoff/
    SKILL.md
  improve-codebase-architecture/
    SKILL.md
    HTML-REPORT.md
  prototype/
    SKILL.md
    LOGIC.md
    UI.md
  qa-run/
    SKILL.md
    TEMPLATES.md
  research/
    SKILL.md
  setup-project-harness/
    SKILL.md
    HARNESS_FLOW.md
    SECTIONS.md
    TRACKER_CONTRACT.md
    AGENTS_TEMPLATE.md
    RULE_TEMPLATE.md
    domain.md
    issue-tracker-github.md
    issue-tracker-gitlab.md
    issue-tracker-local.md
    triage-labels.md
  skill-review/
    SKILL.md
  simplify/
    SKILL.md
  tdd/
    SKILL.md
    mocking.md
    refactoring.md
    tests.md
  to-spec/
    SKILL.md
    TEMPLATE.md
  to-test-plan/
    SKILL.md
    TEMPLATES.md
  to-tickets/
    SKILL.md
    TEMPLATE.md
    EXPAND-CONTRACT.md
  wayfinder/
    SKILL.md
    TEMPLATES.md
  writing-great-skills/
    SKILL.md
    GLOSSARY.md
```

## Current Focus

这个仓库当前关注 evidence-first engineering lifecycle：

- 初始化可信的 project harness 和共享 agent entrypoint
- 为 bounded、settled 和 foggy work 选择不同路径
- 用 non-runnable specs 和可追踪 ticket DAGs 保存 intent
- 让一个 isolated implementation-frontier ticket 完整经过正确的 evidence loop、simplification、review 和 verification
- 把 research 和 prototypes 用作 bounded evidence，而不是隐藏的 production changes
- 把 requirements 连接到 test design、QA evidence 和 confirmed defects
- 通过 `~/.agents/skills` 保持 Codex、Claude、ZCode 和 Kimi 对齐

设计保持 tracker-neutral 和 context-aware：小任务维持小规模；大型工作才获得
durable artifacts、显式 dependencies 和 fresh execution contexts。

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
