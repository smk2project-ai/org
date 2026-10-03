#!/bin/bash
# 組織管理の画面を GitHub Pages（https://smk2project-ai.github.io/org/）に出す。
# 元は MK2/gas/org/Index.html（Googleの中の画面と同じファイル）。アイコンと manifest の行だけ足して index.html にする。
# 使い方: ./publish.sh "変更の説明"
set -e
cd "$(dirname "$0")"
SRC="../../gas/org/Index.html"
python3 - "$SRC" <<'PY'
import sys
s = open(sys.argv[1], encoding='utf-8').read()
tag = '<title>組織管理</title>'
add = tag + '\n<link rel="manifest" href="manifest.webmanifest">\n<link rel="apple-touch-icon" href="icon-180.png">\n<link rel="icon" href="icon-192.png">'
assert s.count(tag) == 1
open('index.html', 'w', encoding='utf-8').write(s.replace(tag, add))
PY
git add index.html manifest.webmanifest icon-*.png publish.sh
if git diff --cached --quiet; then echo "変更なし"; exit 0; fi
git commit -q -m "${1:-画面を更新}" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
git push -q origin main
echo "公開しました: https://smk2project-ai.github.io/org/"
