#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/workspace/agent_news_repo"
README="$REPO_DIR/README.md"
INDEX="$REPO_DIR/INDEX.md"
DAILY_DIR="$REPO_DIR/daily"

cd "$REPO_DIR"
mkdir -p "$DAILY_DIR"

if [[ ! -f "$README" ]]; then
  cat > "$README" <<'EOF'
# Agent News Archive

这个仓库用于沉淀每日 Agent 方向简报，便于长期追踪、每周回顾和主题检索。

目录结构：

- `daily/`：每日技术研究摘要与最新进展，按日期单独成文
- `INDEX.md`：日报索引，按时间倒序汇总

约定：

- 每篇日报文件名使用 `YYYY-MM-DD.md`
- 每篇日报标题使用 `# Agent 日报 | YYYY-MM-DD`
EOF
fi

{
  echo "# Agent 日报索引"
  echo
  find "$DAILY_DIR" -maxdepth 1 -type f -name '*.md' -printf '%f\n' | sort -r | while read -r file; do
    date="${file%.md}"
    echo "- [$date](./daily/$file)"
  done
} > "$INDEX"

git add README.md INDEX.md daily/

if git diff --cached --quiet; then
  echo "No changes to commit."
  exit 0
fi

git commit -m "Update agent briefings archive"
git push origin main
