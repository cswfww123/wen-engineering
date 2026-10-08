# WEN Engineering Skills 同步计划
# 基于 Matt Pocock Skills v1.3.1

**创建日期:** 2025-01-19  
**目标版本:** Matt Pocock Skills v1.3.1  
**当前状态:** 基于旧版本优化的扁平结构

---

## 📊 执行摘要

### 关键发现

1. **🔴 BREAKING CHANGE:** `CONTEXT.md` → `GLOSSARY.md` 命名约定变更
2. **🆕 4个新 skills:** `ask-matt`, `pr`, `retro`, `grill-with-docs`
3. **✅ 9个 WEN 独有 skills** 需要保留
4. **📦 结构差异:** Matt 采用分类目录，我们使用扁平结构

### 受影响的文件
- 13 个 skill 文件包含 CONTEXT 引用
- 38 处 CONTEXT.md 引用
- 9 处 CONTEXT-MAP.md 引用
- 1 个需要重命名的文件

---

## 🎯 Phase 1: 紧急迁移（立即执行）

### 1.1 CONTEXT → GLOSSARY 重命名

**优先级:** 🔴 CRITICAL  
**预计时间:** 30 分钟  
**风险等级:** 中等（已准备迁移脚本和备份）

#### 受影响的 Skills（13个）

| Skill | 引用类型 | 影响程度 |
|-------|---------|---------|
| domain-modeling | 重度使用 | 🔴 HIGH |
| setup-project | 创建和配置 | 🔴 HIGH |
| grill-code | 读取引用 | 🟡 MEDIUM |
| improve-codebase-architecture | 读取引用 | 🟡 MEDIUM |
| code-review | 读取引用 | 🟡 MEDIUM |
| diagnosing-bugs | 读取引用 | 🟡 MEDIUM |
| tdd | 读取引用 | 🟡 MEDIUM |
| triage | 读取引用 | 🟡 MEDIUM |
| wait-what | 读取引用 | 🟡 MEDIUM |
| wayfinder | 读取引用 | 🟡 MEDIUM |
| codebase-design | 读取引用 | 🟢 LOW |

#### 执行步骤

```bash
# 1. 执行迁移脚本
cd /Users/apple/Develop/wen-engineering
chmod +x scripts/migrate-to-glossary.sh
./scripts/migrate-to-glossary.sh

# 2. 验证结果
grep -r "CONTEXT" skills/ --include="*.md" | grep -v "GLOSSARY"

# 3. 查看 diff
git diff skills/

# 4. 测试关键 skills（手动）
# - /domain-modeling
# - /setup-project

# 5. 提交
git add .
git commit -m "refactor: migrate CONTEXT → GLOSSARY per Matt v1.3.x"
```

#### 回滚方案
```bash
# 备份位置会在脚本执行后显示
# 如果出问题：
rm -rf skills/
cp -r ./backups/glossary-migration-*/skills/ ./
```

---

## 🆕 Phase 2: 新增关键 Skills（2周内）

### 2.1 ask-wen（高优先级）

**基于:** Matt 的 `ask-matt`  
**优先级:** 🔴 HIGH  
**预计时间:** 4-6 小时

#### 功能描述
路由器 skill，引导用户选择合适的 WEN 工作流。

#### 实现要点
```markdown
## ask-wen 需要路由到的流程

### 工程流程
- /setup-project - 首次配置
- /grill-code - 需求面试 + 代码
- /implement - 单个 spec 实现
- /implement-spec - 整个 spec 实现
- /code-review - 代码审查

### 产品流程
- /grill-me - 纯需求面试
- /to-spec - 生成规格说明
- /to-tickets - 分解为 tickets
- /triage - 工单分类

### 诊断和改进
- /diagnosing-bugs - Bug 诊断
- /improve-codebase-architecture - 架构改进
- /wait-what - 快速理解
```

#### 文件结构
```
skills/ask-wen/
├── SKILL.md          # 主 skill 文件
├── ROUTING-MAP.md    # 路由决策树
└── README.md         # 说明文档
```

#### 任务清单
- [ ] 从 Matt 的 ask-matt 获取基础结构
- [ ] 适配 WEN 的 skills 体系
- [ ] 创建路由决策树
- [ ] 添加中文支持
- [ ] 测试所有路由路径

---

### 2.2 pr（中优先级）

**基于:** Matt 的 `pr`  
**优先级:** 🟡 MEDIUM  
**预计时间:** 3-4 小时

#### 功能描述
生成 PR 摘要，包含 before/after 证据和 merge-danger 评估。

#### 实现要点
- 最小视觉化变更说明
- before/after 证据（截图、测试结果）
- merge-danger 评估（单向门/双向门）
- 与 WEN 的 git workflow 集成

#### 文件结构
```
skills/pr/
├── SKILL.md
├── TEMPLATE.md       # PR 模板
└── DANGER-LEVELS.md  # 风险评估标准
```

#### 任务清单
- [ ] 从 Matt 的 pr 获取基础结构
- [ ] 集成 WEN 的提交规范
- [ ] 添加截图/证据收集逻辑
- [ ] 创建 PR 模板
- [ ] 测试生成流程

---

### 2.3 retro（中优先级）

**基于:** Matt 的 `retro`  
**优先级:** 🟡 MEDIUM  
**预计时间:** 2-3 小时

#### 功能描述
会话后回顾，识别工具/环境改进机会。

#### 实现要点
- 识别重复的手动步骤
- 发现缺失的自动化
- 工具链优化建议
- 编码标准改进

#### 文件结构
```
skills/retro/
├── SKILL.md
└── CHECKLIST.md      # 回顾检查清单
```

#### 任务清单
- [ ] 从 Matt 的 retro 获取基础结构
- [ ] 定制 WEN 的回顾维度
- [ ] 创建检查清单
- [ ] 集成到工作流中
- [ ] 测试回顾流程

---

### 2.4 grill-with-docs（低优先级）

**基于:** Matt 的 `grill-with-docs`  
**优先级:** 🟢 LOW  
**预计时间:** 评估 2 小时，实现 6-8 小时

#### 决策点
我们已有 `grill-code`，需要评估：
1. 两者功能是否重叠？
2. 是否应该合并？
3. 还是保持独立？

#### 评估任务
- [ ] 对比 Matt 的 grill-with-docs 和我们的 grill-code
- [ ] 列出功能差异
- [ ] 决定：新增、合并、还是跳过
- [ ] 如果新增，创建实现计划

---

## ✅ Phase 3: 对比更新现有 Skills（3周内）

### 优先级排序

#### 🔴 高优先级（本周）
1. **code-review** - 核心质量保障
2. **implement** - 核心开发流程
3. **implement-spec** - 批量实现
4. **tdd** - 测试驱动

#### 🟡 中优先级（下周）
5. **to-spec** - 规格生成
6. **domain-modeling** - 领域建模
7. **diagnosing-bugs** - Bug 诊断
8. **prototype** - 原型开发

#### 🟢 低优先级（第3周）
9. **wayfinder** - 路径规划
10. **wizard** - 向导生成
11. **improve-codebase-architecture** - 架构改进
12. 其他所有

### 对比流程模板

```bash
# 对于每个 skill：

# 1. 获取 Matt 的最新版本
curl -s "https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/{skill}/SKILL.md" > /tmp/matt-{skill}.md

# 2. 对比差异
diff -u skills/{skill}/SKILL.md /tmp/matt-{skill}.md > /tmp/{skill}-diff.txt

# 3. 分析差异
# - 哪些是纯粹的改进？→ 直接合并
# - 哪些是 WEN 特色？→ 保留我们的
# - 哪些有冲突？→ 需要决策

# 4. 记录决策
echo "## {skill} 对比结果" >> docs/matt-sync-decisions.md
echo "- 合并改进: ..." >> docs/matt-sync-decisions.md
echo "- 保留特色: ..." >> docs/matt-sync-decisions.md
echo "- 决策事项: ..." >> docs/matt-sync-decisions.md

# 5. 应用变更
# 手动编辑或使用 patch

# 6. 测试
# 手动测试该 skill

# 7. 提交
git add skills/{skill}/
git commit -m "feat({skill}): sync improvements from Matt v1.3.x"
```

---

## 🏗️ Phase 4: 结构评估（1个月后）

### 当前结构 vs Matt 结构

#### 选项 A: 保持扁平（推荐）
```
skills/
├── implement/
├── code-review/
├── tdd/
└── ... (所有 skills 在一层)
```

**优点:**
- ✅ 简单直观
- ✅ 符合当前习惯
- ✅ 无需重构安装脚本
- ✅ 路径引用不变

**缺点:**
- ❌ skill 数量增长后难以浏览
- ❌ 无法按类别过滤

#### 选项 B: 分类结构
```
skills/
├── wen-engineering/    # WEN 工程类
│   ├── implement/
│   ├── implement-spec/
│   └── code-review/
├── wen-product/        # WEN 产品类
│   ├── product-fog/
│   └── to-design-md/
├── productivity/       # 通用生产力
│   ├── grill-me/
│   └── grilling/
└── tools/             # 工具类
    ├── harvest-pins/
    └── setup-logging/
```

**优点:**
- ✅ 清晰分类
- ✅ 易于扩展
- ✅ 更好的组织

**缺点:**
- ❌ 需要重构安装脚本
- ❌ 路径引用全部改变
- ❌ 学习成本

### 决策建议

**现在：保持扁平结构（选项 A）**

原因：
1. Phase 1-3 已经有足够的工作量
2. 扁平结构对当前规模足够
3. 避免过早优化
4. 可以等 skills 数量超过 50 个再考虑

**未来触发点：**
- Skills 总数 > 50
- 用户反馈难以找到合适的 skill
- 需要按类别管理权限/可见性

---

## 🎨 WEN 独有 Skills（保留）

这些是 Matt 没有的，属于 WEN 特色功能：

| Skill | 用途 | 状态 |
|-------|------|------|
| alignment-review | 对齐审查 | ✅ 保留 |
| ask-process | 流程咨询 | ✅ 保留 |
| grill-code | 需求面试+代码 | ⚠️ 评估与 grill-with-docs 关系 |
| harvest-pins | Pin 收集和管理 | ✅ 保留 |
| product-fog | 产品迷雾处理 | ✅ 保留 |
| setup-logging | 日志系统设置 | ✅ 保留 |
| show-me | 功能展示 | ✅ 保留 |
| simplify | 简化重构 | ✅ 保留 |
| to-design-md | 设计文档生成 | ✅ 保留 |

**行动:**
- 这些 skills 继续维护和改进
- 不要因为 Matt 没有就删除
- 这是 WEN 的差异化价值

---

## 📋 完整任务清单

### Phase 1: 紧急迁移（本周）
- [ ] 执行 GLOSSARY 迁移脚本
- [ ] 验证所有 CONTEXT 引用已更新
- [ ] 测试 domain-modeling skill
- [ ] 测试 setup-project skill
- [ ] 提交变更

### Phase 2: 新增 Skills（2周内）
- [ ] 实现 ask-wen
- [ ] 实现 pr
- [ ] 实现 retro
- [ ] 评估 grill-with-docs

### Phase 3: 对比更新（3周内）

**第1周:**
- [ ] code-review
- [ ] implement
- [ ] implement-spec
- [ ] tdd

**第2周:**
- [ ] to-spec
- [ ] domain-modeling
- [ ] diagnosing-bugs
- [ ] prototype

**第3周:**
- [ ] wayfinder
- [ ] wizard
- [ ] improve-codebase-architecture
- [ ] 其他所有

### Phase 4: 长期维护
- [ ] 订阅 Matt 的 GitHub releases
- [ ] 每月检查更新
- [ ] 维护同步文档

---

## 📊 成功指标

### Phase 1 成功标准
- ✅ 零残留 CONTEXT 引用
- ✅ 所有 skills 正常工作
- ✅ 已有项目兼容

### Phase 2 成功标准
- ✅ 3个新 skills 正常工作
- ✅ 集成到 WEN 工作流
- ✅ 文档完整

### Phase 3 成功标准
- ✅ 20+ skills 完成对比更新
- ✅ 改进已合并
- ✅ WEN 特色已保留

---

## ⚠️ 风险和缓解

| 风险 | 级别 | 缓解措施 | 负责人 |
|------|------|---------|--------|
| GLOSSARY 迁移破坏现有项目 | 🔴 HIGH | 完整备份 + 迁移脚本 + 回滚方案 | 立即 |
| 过度同步丢失 WEN 特色 | 🟡 MEDIUM | 明确标记 WEN 独有功能，对比时保留 | Phase 3 |
| 新 skills 与现有冲突 | 🟡 MEDIUM | 充分评估再实现，特别是 grill-with-docs | Phase 2 |
| 维护负担增加 | 🟢 LOW | 建立自动化对比流程 | Phase 4 |

---

## 📚 参考资源

- [Matt Pocock Skills 仓库](https://github.com/mattpocock/skills)
- [Matt Skills v1.3.1 Release Notes](https://github.com/mattpocock/skills/releases/tag/v1.3.1)
- [Matt Skills Changelog](https://github.com/mattpocock/skills/blob/main/CHANGELOG.md)
- WEN 迁移脚本: `scripts/migrate-to-glossary.sh`
- 本次对比分析: `/tmp/skills-comparison.md`

---

## 🎬 下一步行动（今天）

```bash
# 1. 查看完整对比
cat /tmp/skills-comparison.md

# 2. 执行 Phase 1
./scripts/migrate-to-glossary.sh

# 3. 验证结果
git diff

# 4. 提交
git add .
git commit -m "refactor: migrate CONTEXT → GLOSSARY per Matt v1.3.x"

# 5. 开始 Phase 2 规划
# 创建 ask-wen skill 的详细设计文档
```

---

**文档版本:** 1.0  
**最后更新:** 2025-01-19  
**下次审查:** Phase 1 完成后
