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

推荐：clone 仓库，并把所有 skills 同步到 Codex 和 Claude：

```bash
git clone https://github.com/cswfww123/wen-engineering.git
cd wen-engineering
./scripts/sync-skills.sh --agents codex,claude
```

这会安装全部 skills，不需要逐个选择。它也会在每个目标 skill 目录中创建 manifest，让未来的同步可以删除本仓库已经移除的 skills，同时不触碰用户自己的其他 skills。

可选：如果你只想挑选少量 skills，或者安装到 `skills.sh` 支持的某个 agent，可以使用交互式 installer：

```bash
npx skills@latest add cswfww123/wen-engineering
```

交互式 installer 可能不支持每个 agent，也不一定支持完整的更新或删除流程。如果你希望 Codex 和 Claude 长期与本仓库保持一致，优先使用 `scripts/sync-skills.sh`。

后续更新：

```bash
cd wen-engineering
git pull --ff-only
./scripts/sync-skills.sh --agents codex,claude
```

默认情况下，同步会把文件复制到 `~/.codex/skills` 和 `~/.claude/skills`。如果你希望这个 checkout 中的本地编辑立刻对 agent 可见，可以使用 `--mode link`：

```bash
./scripts/sync-skills.sh --agents codex,claude --mode link
```

如果你之前用其他工具安装过同名 skills，同步脚本可能会拒绝覆盖。先检查：

```bash
./scripts/sync-skills.sh --agents codex,claude --dry-run
```

当你确定希望由本仓库管理这些 skill 名称时，执行一次迁移：

```bash
./scripts/sync-skills.sh --agents codex,claude --force
```

如果迁移后 Codex 中出现重复的 WEN skills，你可能还有旧的 shared install 留在 `~/.agents/skills`。可以在同步 Codex 和 Claude 后，一次性归档旧副本：

```bash
./scripts/sync-skills.sh --agents codex,claude --force --archive-legacy-agents
```

这会把 `~/.agents/skills` 中同名的 WEN skills 移到带时间戳的 `.wen-engineering-legacy-*` 备份目录。

对于新项目，同步完成后，在目标项目中运行 **`/setup-project-harness`**。它会配置：

- issue tracker workflow：GitHub、GitLab、本地 markdown，或其他 tracker
- `/triage`、`/to-issues`、`/to-prd` 使用的五个 triage labels
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

## Local Workspace

常用 skills：

- `/alignment-review` 审查生成的规划产物是否对齐用户意图、repo evidence 和执行路径。
- `/codebase-design` 为模块接口、seams 和边界提供深层代码库设计语言。
- `/code-review` 审查本地 diff 或 PR，关注完成度、回归、性能和安全性。
- `/diagnosing-bugs` 用反馈循环诊断复杂 bug 和性能回归。
- `/domain-modeling` 在设计决策结晶时打磨 glossary terms 并记录 ADRs。
- `/do-issues` 一次处理一个 ready AFK vertical-slice issue。
- `/grill-with-docs` 在维护 glossary 和 ADR docs 的同时 stress-test 一个 plan。
- `/handoff` 为新的 agent 写一份紧凑 handoff document。
- `/improve-codebase-architecture` 扫描代码库中的 deepening opportunities，并写出可视化 HTML report。
- `/qa-run` 执行计划好的 QA cases，记录 evidence，并沉淀 durable bug issues。
- `/setup-project-harness` 初始化项目级 agent harness。
- `/skill-review` 在接受新增或修改后的 skill 前进行审查。
- `/tdd` 通过 public behavior tests 引导 Red-Green-Refactor 实现。
- `/to-issues` 把 PRD 或 plan 拆成 tracer-bullet vertical-slice issues。
- `/to-prd` 把已经沉淀的讨论转成适配当前 issue tracker 的 PRD。
- `/to-test-plan` 从 PRDs 和 issues 创建可追踪 test plans 和 test cases。
- `/write-a-skill` 用 progressive disclosure 创建或改进 skills。
- `/zoom-out` 使用项目领域语言映射相关模块和调用方。

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

- [`alignment-review`](skills/alignment-review/SKILL.md) - 审查生成的规划产物是否对齐 intent、repo evidence 和执行路径。
- [`handoff`](skills/handoff/SKILL.md) - 为新的 agent 写一份紧凑 handoff document，并保存在 repo 外。
- [`context-resume`](skills/context-resume/SKILL.md) - 通过读取既有项目产物启动新的 agent session，例如 `CONTEXT.md`、issues、PRDs 和 git history。用于 rate limit 后恢复或切换 agents。
- [`domain-modeling`](skills/domain-modeling/SKILL.md) - 打磨 domain language，更新 `CONTEXT.md`，并在决策结晶时少量记录 ADRs。
- [`grill-with-docs`](skills/grill-with-docs/SKILL.md) - 运行 `/grilling` 并同时激活 `/domain-modeling`，作为常规 plan-sharpening 入口。
- [`grilling`](skills/grilling/SKILL.md) - 提供 grill skills 使用的一次一个问题的核心访谈协议。
- [`to-prd`](skills/to-prd/SKILL.md) - 把已经沉淀的讨论和 repo evidence 转成适配当前 issue tracker 的 PRD。
- [`to-issues`](skills/to-issues/SKILL.md) - 把 PRD、plan 或 spec 拆成可以独立领取的 vertical-slice issues。
- [`to-test-plan`](skills/to-test-plan/SKILL.md) - 从 PRDs 和 issues 创建可追踪 test plans 和 cases。
- [`do-issues`](skills/do-issues/SKILL.md) - 一次处理一个 ready AFK vertical-slice issue，并完成 verification。
- [`tdd`](skills/tdd/SKILL.md) - 通过 vertical Red-Green-Refactor cycles 和 public behavior tests 引导实现。
- [`write-a-skill`](skills/write-a-skill/SKILL.md) - 创建或改进 skills，强调清晰 trigger、短 instructions 和一层 reference。
- [`zoom-out`](skills/zoom-out/SKILL.md) - 使用项目领域语言映射相关模块和调用方。

### Review And Quality

- [`code-review`](skills/code-review/SKILL.md) - 审查本地 diffs 或 PRs，关注完成度、回归、性能和安全性。
- [`diagnosing-bugs`](skills/diagnosing-bugs/SKILL.md) - 在改代码前先建立 feedback loop，用于诊断 bugs 和性能回归。
- [`qa-run`](skills/qa-run/SKILL.md) - 执行计划好的 QA cases，记录 evidence，并提交 durable bug issues。

### Architecture

- [`codebase-design`](skills/codebase-design/SKILL.md) - 为 module interfaces、seams、adapters、leverage 和 locality 提供深层模块语言。
- [`improve-codebase-architecture`](skills/improve-codebase-architecture/SKILL.md) - 扫描代码库中的 deepening opportunities，并写出可视化 HTML report。

### Engineering Harness

- [`setup-project-harness`](skills/setup-project-harness/SKILL.md) - 为 Codex 和 Claude 构建 interview-driven project harness。适用于 frontend、backend、full-stack、library、CLI、monorepo、empty starter 或 engineering-skills repos。
- [`skill-review`](skills/skill-review/SKILL.md) - 审查 skills 的 discovery、trigger clarity、progressive disclosure 和 judgment-preserving guidance。

## Skill Design Principles

- 小胜过全。
- Instructions 应该创造更好的协作，而不是移除 autonomy。
- 先读 repo evidence，再提问。
- 只在用户意图或品味起决定作用时提问。
- 优先使用 progressive disclosure，而不是一个巨大的 prompt。
- 用 rules 捕获边界，不写泛泛建议。
- 把 verification 放进 workflow。
- 在 divergence 不危险的地方保留 model judgment。

## Repository Layout

```text
README.md
README.zh-CN.md
AGENTS.md
CLAUDE.md -> AGENTS.md
.agents/
  rules/
    project/
      agent-workflow.md
    skills/
      authoring.md
      review.md
docs/
  agents/
    domain.md
    issue-tracker.md
    triage-labels.md
scripts/
  sync-skills.sh
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
  do-issues/
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
  qa-run/
    SKILL.md
    TEMPLATES.md
  skill-review/
    SKILL.md
  tdd/
    SKILL.md
    mocking.md
    refactoring.md
    tests.md
  to-issues/
    SKILL.md
  to-prd/
    SKILL.md
  to-test-plan/
    SKILL.md
    TEMPLATES.md
  write-a-skill/
    SKILL.md
  zoom-out/
    SKILL.md
  setup-project-harness/
    SKILL.md
    SECTIONS.md
    AGENTS_TEMPLATE.md
    RULE_TEMPLATE.md
    domain.md
    issue-tracker-github.md
    issue-tracker-gitlab.md
    issue-tracker-local.md
    triage-labels.md
```

## Current Focus

这个仓库当前关注 project initialization 和 harness engineering：

- 识别项目形态和技术栈
- 建立共享 agent entrypoint
- 把 standards 组织到 `.agents/rules/`
- 通过单一 source of truth 保持 Codex 和 Claude 对齐
- 帮助用户和 LLM 一起定义边界
- 在实现开始前，通过单会话访谈打磨早期计划

未来 skills 可以覆盖更窄的项目类型，例如 frontend apps、backend services、libraries、CLIs、monorepos 和 skills-authoring workflows。

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
