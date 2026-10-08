#!/bin/bash
# 检查并报告哪些项目需要 CONTEXT → GLOSSARY 迁移

echo "🔍 检查使用 WEN Skills 的项目..."
echo ""

# 你可以修改这个路径为你的项目根目录
PROJECTS_ROOT="${1:-$HOME/Develop}"

if [ ! -d "$PROJECTS_ROOT" ]; then
    echo "❌ 目录不存在: $PROJECTS_ROOT"
    exit 1
fi

echo "搜索范围: $PROJECTS_ROOT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 查找所有包含 CONTEXT.md 的项目
FOUND=0
while IFS= read -r context_file; do
    FOUND=$((FOUND + 1))
    PROJECT_DIR=$(dirname "$context_file")

    echo "📁 需要迁移: $PROJECT_DIR"
    echo "   文件: $(basename "$context_file")"

    # 检查是否还有 CONTEXT-MAP.md
    if [ -f "$PROJECT_DIR/CONTEXT-MAP.md" ]; then
        echo "   文件: CONTEXT-MAP.md"
    fi

    # 检查引用数量
    REF_COUNT=$(find "$PROJECT_DIR" -name "*.md" -type f -exec grep -l "CONTEXT\.md" {} \; 2>/dev/null | wc -l)
    echo "   引用数量: $REF_COUNT 个文件"
    echo ""
done < <(find "$PROJECTS_ROOT" -name "CONTEXT.md" -type f 2>/dev/null)

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $FOUND -eq 0 ]; then
    echo "✅ 没有找到需要迁移的项目"
    echo ""
    echo "所有项目都已使用 GLOSSARY.md，或者没有使用 WEN Skills。"
else
    echo "📊 总结:"
    echo "   需要迁移的项目: $FOUND 个"
    echo ""
    echo "💡 迁移步骤:"
    echo "   1. cd /path/to/project"
    echo "   2. git mv CONTEXT.md GLOSSARY.md"
    echo "   3. git mv CONTEXT-MAP.md GLOSSARY-MAP.md  # 如果有"
    echo "   4. find . -name '*.md' -exec sed -i '' 's/CONTEXT\\.md/GLOSSARY.md/g' {} \\;"
    echo "   5. find . -name '*.md' -exec sed -i '' 's/CONTEXT-MAP\\.md/GLOSSARY-MAP.md/g' {} \\;"
    echo "   6. git add . && git commit -m 'refactor: migrate CONTEXT → GLOSSARY'"
fi

echo ""
