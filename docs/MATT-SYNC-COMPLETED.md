# WEN Engineering Skills 同步完成报告
# 基于 Matt Pocock Skills v1.3.1

**执行日期:** 2025-01-19  
**执行状态:** ✅ Phase 1 完成

---

## ✅ 已完成：Phase 1 - GLOSSARY 迁移

### 执行摘要
- ✅ 文件重命名：`CONTEXT-FORMAT.md` → `GLOSSARY-FORMAT.md`
- ✅ 内容替换：所有 CONTEXT 引用已更新为 GLOSSARY
- ✅ 零残留验证通过
- ✅ AGENTS.md 增加强制映射约束

### 统计数据
- **GLOSSARY 引用数:** 44 处
- **CONTEXT-MAP.md 残留:** 0 处
- **CONTEXT.md 残留:** 0 处
- **受影响文件:** 13 个 skills

### 受影响的 Skills
1. domain-modeling
2. setup-project
3. grill-code
4. improve-codebase-architecture
5. code-review
6. diagnosing-bugs
7. tdd
8. triage
9. wait-what
10. wayfinder
11. codebase-design
12. product-fog (新发现)
13. to-design-md (新发现)

---

## 📝 已修正：Skills 映射关系

### 核心发现
**ask-matt = ask-process**（用户指出）

之前错误地建议新建 `ask-wen`，实际上：
- Matt 的 `ask-matt` 就是 WEN 的 `ask-process`
- 两者都是路由器 skill，引导用户选择合适的工作流
- WEN 版本已经适配了 WEN 的 skill 体系

### 完整映射表（已添加到 AGENTS.md）

| Matt Skill | WEN Skill | 状态 | 说明 |
|-----------|-----------|------|------|
| ask-matt | ask-process | ✅ 已映射 | 路由器 - WEN 版本 |
| setup-matt-pocock-skills | setup-project | ✅ 已映射 | 项目初始化 - WEN 版本 |
| grill-with-docs | grill-code | ✅ 已映射 | 需求面试 + 代码 - WEN 更强大 |
| code-review | code-review | ✅ 同名 | - |
| implement | implement | ✅ 同名 | - |
| implement-spec | implement-spec | ✅ 同名 | - |
| tdd | tdd | ✅ 同名 | - |
| to-spec | to-spec | ✅ 同名 | - |
| to-tickets | to-tickets | ✅ 同名 | - |
| triage | triage | ✅ 同名 | - |
| wayfinder | wayfinder | ✅ 同名 | - |
| wizard | wizard | ✅ 同名 | - |
| prototype | prototype | ✅ 同名 | - |
| research | research | ✅ 同名 | - |
| diagnosing-bugs | diagnosing-bugs | ✅ 同名 | - |
| domain-modeling | domain-modeling | ✅ 同名 | - |
| codebase-design | codebase-design | ✅ 同名 | - |
| improve-codebase-architecture | improve-codebase-architecture | ✅ 同名 | - |
| grill-me | grill-me | ✅ 同名 | - |
| grilling | grilling | ✅ 同名 | - |
| handoff | handoff | ✅ 同名 | - |
| to-questionnaire | to-questionnaire | ✅ 同名 | - |
| wait-what | wait-what | ✅ 同名 | - |
| writing-for-agents | writing-for-agents | ✅ 同名 | - |

### Matt 有但 WEN 需新增的（仅2个）

| Matt Skill | 优先级 | 说明 |
|-----------|--------|------|
| pr | 🟡 MEDIUM | PR 摘要生成（before/after + merge-danger） |
| retro | 🟡 MEDIUM | 会话回顾和环境改进 |
| teach | 🟢 LOW | 教学类 skill |

### WEN 独有 Skills（9个，全部保留）

| WEN Skill | 说明 |
|-----------|------|
| alignment-review | 对齐审查 |
| product-fog | 产品迷雾处理 |
| harvest-pins | Pin 收集和管理 |
| setup-logging | 日志系统设置 |
| show-me | 功能展示 |
| simplify | 简化重构 |
| to-design-md | 设计文档生成 |

---

## 🔧 AGENTS.md 强制约束已添加

在 AGENTS.md 中添加了 `## WEN ↔ Matt Pocock Skills 映射关系（强制约束）` 章节：

### 约束内容
1. **禁止建议创建已映射的 skills**
   - 例如：禁止新建 ask-matt（已有 ask-process）
   
2. **禁止删除 WEN 独有功能**
   - 9 个 WEN 特色 skills 明确列出
   
3. **明确新增方向**
   - 仅 pr、retro、teach 需要新增
   
4. **命名约定同步**
   - GLOSSARY 替代 CONTEXT（已完成）

---

## 📊 下一步：Phase 2 & 3

### Phase 2: 新增 Skills（2周内）

#### 2.1 pr skill（中优先级）
```
skills/pr/
├── SKILL.md
├── TEMPLATE.md
└── DANGER-LEVELS.md
```

**功能:**
- 生成 PR 摘要
- before/after 证据（截图、测试）
- merge-danger 评估（单向门/双向门）

**预计时间:** 3-4 小时

#### 2.2 retro skill（中优先级）
```
skills/retro/
├── SKILL.md
└── CHECKLIST.md
```

**功能:**
- 会话后回顾
- 识别重复手动步骤
- 工具链优化建议

**预计时间:** 2-3 小时

### Phase 3: 对比更新现有 Skills（3周内）

#### 优先级分组

**🔴 第1周（高优先级）:**
1. code-review
2. implement
3. implement-spec
4. tdd

**🟡 第2周（中优先级）:**
5. to-spec
6. domain-modeling
7. diagnosing-bugs
8. prototype

**🟢 第3周（低优先级）:**
9. wayfinder
10. wizard
11. improve-codebase-architecture
12. 其他所有

#### 对比流程
```bash
# 对于每个 skill：
curl -s "https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/{skill}/SKILL.md" > /tmp/matt-{skill}.md
diff -u skills/{skill}/SKILL.md /tmp/matt-{skill}.md
# 分析 → 合并改进 → 保留 WEN 特色 → 测试 → 提交
```

---

## 🎯 成功指标

### Phase 1（已完成 ✅）
- ✅ 零残留 CONTEXT 引用
- ✅ GLOSSARY-FORMAT.md 文件已重命名
- ✅ 44 处引用已更新
- ✅ 强制映射约束已添加

### Phase 2（待执行）
- [ ] pr skill 实现并测试
- [ ] retro skill 实现并测试
- [ ] 集成到 WEN 工作流

### Phase 3（待执行）
- [ ] 20+ skills 完成对比更新
- [ ] Matt 的改进已合并
- [ ] WEN 特色已保留

---

## 📁 相关文件

### 新增文档
- `docs/MATT-SYNC-PLAN.md` - 完整同步计划
- `docs/MATT-SYNC-COMPLETED.md` - 本报告
- `scripts/migrate-to-glossary.sh` - 迁移脚本
- `/tmp/skills-comparison.md` - 对比分析

### 修改文件
- `AGENTS.md` - 添加映射约束章节
- `skills/domain-modeling/GLOSSARY-FORMAT.md` - 重命名
- 13 个 skills 的 CONTEXT → GLOSSARY 引用

### 备份
- `./backups/glossary-migration-20261008-092619/`

---

## 🚀 立即行动

```bash
# 1. 查看变更
git diff

# 2. 提交 Phase 1 成果
git add .
git commit -m "refactor: CONTEXT→GLOSSARY migration + Matt skills mapping constraints

- Migrate all CONTEXT.md references to GLOSSARY.md (Matt v1.3.x)
- Rename CONTEXT-FORMAT.md to GLOSSARY-FORMAT.md
- Add WEN↔Matt skills mapping constraints in AGENTS.md
- Clarify ask-process = ask-matt, grill-code = grill-with-docs
- Mark 9 WEN-exclusive skills to preserve
- Identify 2 new skills to add: pr, retro

Affected: 13 skills, 44 references updated, 0 remaining"

# 3. 开始 Phase 2
# 下一个任务：实现 pr skill
```

---

## 📚 参考

- Matt Pocock Skills: https://github.com/mattpocock/skills
- v1.3.1 Release: https://github.com/mattpocock/skills/releases/tag/v1.3.1
- WEN 同步计划: `docs/MATT-SYNC-PLAN.md`

---

**报告版本:** 1.0  
**最后更新:** 2025-01-19  
**下次审查:** Phase 2 开始前
