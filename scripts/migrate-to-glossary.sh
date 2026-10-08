#!/bin/bash
# WEN Engineering - CONTEXT → GLOSSARY 迁移脚本
# 基于 Matt Pocock skills v1.3.x 的重大变更

set -e

echo "🔄 开始 CONTEXT → GLOSSARY 迁移..."
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 计数器
TOTAL_CHANGES=0

# 1. 备份
echo "📦 创建备份..."
BACKUP_DIR="./backups/glossary-migration-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r skills/ "$BACKUP_DIR/skills/"
echo "${GREEN}✓${NC} 备份完成: $BACKUP_DIR"
echo ""

# 2. 文件重命名
echo "📝 文件重命名..."

rename_file() {
    local old_name=$1
    local new_name=$2

    if [ -f "$old_name" ]; then
        mv "$old_name" "$new_name"
        echo "${GREEN}✓${NC} 重命名: $old_name → $new_name"
        ((TOTAL_CHANGES++))
    fi
}

# 重命名文件
rename_file "skills/domain-modeling/CONTEXT-FORMAT.md" "skills/domain-modeling/GLOSSARY-FORMAT.md"

echo ""

# 3. 内容替换
echo "🔍 内容替换..."

replace_in_files() {
    local pattern=$1
    local replacement=$2
    local description=$3

    echo "  处理: $description"

    # 使用 find + sed 进行替换
    local count=0
    while IFS= read -r file; do
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' "s/${pattern}/${replacement}/g" "$file"
        else
            # Linux
            sed -i "s/${pattern}/${replacement}/g" "$file"
        fi
        ((count++))
    done < <(grep -rl "$pattern" skills/ --include="*.md" 2>/dev/null || true)

    if [ $count -gt 0 ]; then
        echo "${GREEN}✓${NC} 更新了 $count 个文件"
        ((TOTAL_CHANGES+=count))
    else
        echo "${YELLOW}○${NC} 未找到匹配项"
    fi
}

# 执行替换
replace_in_files "CONTEXT-MAP\.md" "GLOSSARY-MAP.md" "CONTEXT-MAP.md → GLOSSARY-MAP.md"
replace_in_files "CONTEXT\.md" "GLOSSARY.md" "CONTEXT.md → GLOSSARY.md"
replace_in_files "CONTEXT-FORMAT\.md" "GLOSSARY-FORMAT.md" "CONTEXT-FORMAT.md → GLOSSARY-FORMAT.md"

# 替换描述性文本（更谨慎）
replace_in_files "domain model.*CONTEXT" "domain model (GLOSSARY)" "描述性文本更新"

echo ""

# 4. 验证
echo "✅ 验证迁移结果..."

verify_migration() {
    local old_pattern=$1
    local description=$2

    local remaining=$(grep -r "$old_pattern" skills/ --include="*.md" 2>/dev/null | wc -l | tr -d ' ')

    if [ "$remaining" -gt 0 ]; then
        echo "${YELLOW}⚠${NC}  仍有 $remaining 处 '$description' 引用"
        echo "    运行以下命令查看详情:"
        echo "    grep -r \"$old_pattern\" skills/ --include=\"*.md\""
    else
        echo "${GREEN}✓${NC} 无残留 '$description' 引用"
    fi
}

verify_migration "CONTEXT-MAP\.md" "CONTEXT-MAP.md"
verify_migration "CONTEXT\.md" "CONTEXT.md"
verify_migration "CONTEXT-FORMAT\.md" "CONTEXT-FORMAT.md"

echo ""

# 5. 生成变更报告
echo "📊 生成变更报告..."

REPORT_FILE="./migration-report-$(date +%Y%m%d-%H%M%S).md"

cat > "$REPORT_FILE" << EOF
# CONTEXT → GLOSSARY 迁移报告

**执行时间:** $(date '+%Y-%m-%d %H:%M:%S')
**总变更数:** $TOTAL_CHANGES

## 变更摘要

### 文件重命名
- \`CONTEXT-FORMAT.md\` → \`GLOSSARY-FORMAT.md\`

### 内容替换
- 所有 \`CONTEXT-MAP.md\` 引用 → \`GLOSSARY-MAP.md\`
- 所有 \`CONTEXT.md\` 引用 → \`GLOSSARY.md\`
- 所有 \`CONTEXT-FORMAT.md\` 引用 → \`GLOSSARY-FORMAT.md\`

## 受影响的 Skills

$(grep -rl "GLOSSARY" skills/ --include="*.md" | sed 's/^/- /' || echo "无")

## 备份位置

\`$BACKUP_DIR\`

## 验证步骤

\`\`\`bash
# 1. 检查是否有残留的 CONTEXT 引用
grep -r "CONTEXT" skills/ --include="*.md"

# 2. 运行 skills 测试（如果有）
./scripts/test-skills.sh

# 3. 手动验证关键 skills
# - domain-modeling
# - setup-project
# - grill-with-docs (如果存在)
\`\`\`

## 回滚方案

如果需要回滚：
\`\`\`bash
rm -rf skills/
cp -r $BACKUP_DIR/skills/ ./
\`\`\`

EOF

echo "${GREEN}✓${NC} 报告已生成: $REPORT_FILE"
echo ""

# 6. 总结
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "${GREEN}✅ 迁移完成!${NC}"
echo ""
echo "📈 统计:"
echo "   - 总变更数: $TOTAL_CHANGES"
echo "   - 备份位置: $BACKUP_DIR"
echo "   - 报告文件: $REPORT_FILE"
echo ""
echo "⚠️  下一步:"
echo "   1. 查看迁移报告: cat $REPORT_FILE"
echo "   2. 验证变更: git diff"
echo "   3. 测试关键 skills"
echo "   4. 提交变更: git add . && git commit -m 'refactor: CONTEXT → GLOSSARY migration (Matt v1.3.x)'"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
