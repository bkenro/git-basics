#!/usr/bin/env bash
#
# RES-RESET : 題材リポジトリを任意のチェックポイントの状態に再現する
#
#   使い方:  ./reset-to.sh <c1|c2|c3|c4|c5|c6|c7> [作業ディレクトリ]
#   既定の作業ディレクトリは ~/portfolio
#
# 用途:
#   - 受講者が途中の単元から学習を始める
#   - 操作を誤って先へ進めなくなったときに、既知の状態へ戻す
#
# チェックポイントの定義は RES-STEPS.md を参照。
# ファイル内容は RES-SITE.md と一致させてある。変更する場合は両方を直すこと。
#
# c5 以降はリモートリポジトリを伴う。GitHub は使わず、ローカルの bare リポジトリを
# origin の代役として作る（学習用の再現であり、モジュール 6 の本番手順とは別物）。

set -euo pipefail

CP="${1:-}"
DIR="${2:-$HOME/portfolio}"
PEER="${DIR}-suzuki"
ORIGIN="${DIR}-origin.git"

usage() { sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 1; }
[ -z "$CP" ] && usage

AUTHOR_NAME="Taro Yamada"
AUTHOR_MAIL="taro@example.com"
PEER_NAME="Hanako Suzuki"
PEER_MAIL="hanako@example.com"

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

confirm_wipe() {
  for d in "$DIR" "$PEER" "$ORIGIN"; do
    [ -e "$d" ] && say "削除します: $d"
  done
  printf 'よろしいですか？ [y/N] '
  read -r ans
  case "$ans" in y|Y) ;; *) echo "中止しました"; exit 1 ;; esac
  rm -rf "$DIR" "$PEER" "$ORIGIN"
}

commit() { GIT_AUTHOR_DATE="$1" GIT_COMMITTER_DATE="$1" git commit -q -m "$2"; }

# ---------- ファイル生成 ----------

site_v1() {
  mkdir -p css
  cat > README.md <<'EOF'
# ポートフォリオサイト

自己紹介と制作物を掲載する静的な Web サイト。

TODO：目的

TODO：ローカルでの表示方法

TODO：動作環境

メモ：
EOF
  cat > index.html <<'EOF'
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>山田太郎のポートフォリオ</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <header>
    <h1>山田太郎</h1>
    <p>エンジニアを目指して学習中です。</p>
  </header>
</body>
</html>
EOF
  cat > css/style.css <<'EOF'
:root {
  --main-color: #1e88e5;
  --bg-color: #ffffff;
}

body {
  font-family: sans-serif;
  color: var(--main-color);
  background: var(--bg-color);
  margin: 0 auto;
  max-width: 720px;
  padding: 24px;
}
EOF
}

gitignore_v2() {
  cat > .gitignore <<'EOF'
# OS が生成するファイル
.DS_Store
Thumbs.db

# ログファイル
*.log

# 一時作業ディレクトリ
tmp/
EOF
}

profile_png() {
  # 1x1 の最小 PNG。受講者は自分の写真に差し替えてよい。
  # RES-SITE.md は 40KB 程度を想定しているが、差分が「Binary files differ」に
  # なることの確認にはこれで足りる。
  mkdir -p images
  printf '%s' \
'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==' \
    | base64 -d > images/profile.png
}

index_with_img() {
  # V2: <img> を追加（alt はあえて付けない。V7 の題材になる）
  perl -0pi -e 's|(  <header>\n)|$1    <img src="images/profile.png" width="120">\n|' index.html
}

readme_v2_purpose() {
  cat <<EOF > README.md
# ポートフォリオサイト

自己紹介と制作物を掲載する静的 Web サイトです。

TODO：目的

TODO：ローカルでの表示方法

TODO：動作環境

メモ：
学習の記録と制作物を 1 か所にまとめ、いつでも見せられる状態にしておくことを目的とする。
EOF
}

readme_v3() {
  cat > README.md <<'EOF'
# ポートフォリオサイト

自己紹介と制作物を掲載する静的 Web サイトです。

## 目的

エンジニアを目指す山田太郎の自己紹介と、これまでの制作物を公開します。

## ローカルでの表示方法

リポジトリを取得し、`index.html` をブラウザで開いてください。

    git clone git@github.com:<your-account>/portfolio.git
    cd portfolio
    open index.html      # Windows は start / Linux は xdg-open

## 動作環境

モダンブラウザ（Chrome / Firefox / Safari / Edge の最新版）
EOF
}

site_v4_html() {
  perl -0pi -e 's|(</body>)|  <section id="works">\n    <h2>制作物</h2>\n    <ul>\n      <li><a href="https://example.com/app1">タスク管理アプリ</a></li>\n      <li><a href="https://example.com/app2">天気予報ビューア</a></li>\n    </ul>\n  </section>\n$1|' index.html
}

site_v4_css() {
  perl -0pi -e 's|(  --main-color: \#1e88e5;\n)|$1  --accent-color: \#ff6f00;\n|' css/style.css
  cat >> css/style.css <<'EOF'

#works h2 {
  border-left: 4px solid var(--accent-color);
  padding-left: 8px;
}
EOF
}

site_v4_readme() {
  cat >> README.md <<'EOF'

## ディレクトリ構成

    portfolio/
    ├── index.html      トップページ
    ├── css/style.css   スタイル
    └── images/         画像
EOF
}

site_v5_css() { perl -pi -e 's|  --main-color: \#1e88e5;|  --main-color: #334155;|' css/style.css; }

site_v6_css() {
  # コンフリクト解消結果：両者の変更を活かす
  perl -0pi -e 's|  --main-color: \#1e88e5;|  --main-color: #334155;|' css/style.css
}

site_v7_html() {
  perl -pi -e 's|<img src="images/profile.png" width="120">|<img src="images/profile.png" width="120" alt="山田太郎のプロフィール写真">|' index.html
}

# ---------- チェックポイントの構築 ----------

build_c2() {
  mkdir -p "$DIR"; cd "$DIR"
  git init -q -b main
  git config user.name  "$AUTHOR_NAME"
  git config user.email "$AUTHOR_MAIL"
  site_v1
  git add README.md index.html css/style.css
  commit '2026-04-01T10:00:00' 'サイトの雛形を追加'
  gitignore_v2
  git add .gitignore
  commit '2026-04-01T10:20:00' '作業中に生成されるファイルを追跡対象から除外'
  profile_png; index_with_img
  git add images/profile.png index.html
  commit '2026-04-01T11:00:00' 'プロフィール画像を追加'
  readme_v2_purpose
  git add README.md
  commit '2026-04-01T11:30:00' 'READMEにサイトの目的を追記'
}

build_c4() {
  build_c2
  cd "$DIR"
  git switch -q -c feature/works-section
  site_v4_html;   git add index.html;    commit '2026-04-02T09:00:00' '制作物セクションのHTMLを追加'
  site_v4_css;    git add css/style.css; commit '2026-04-02T09:20:00' '制作物セクションのスタイルを追加'
  site_v4_readme; git add README.md;     commit '2026-04-02T09:40:00' 'READMEにディレクトリ構成の説明を追記'

  # もう一人の開発者の変更（モジュール 5 ではローカルの main で代用する）
  git switch -q main
  site_v5_css; git add css/style.css
  commit '2026-04-02T10:00:00' '全体の配色を落ち着いたトーンに変更'

  # 統合（コンフリクトを解消した結果を直接作る）
  git switch -q feature/works-section
  if ! git merge -q --no-edit main 2>/dev/null; then
    site_v6_css
    perl -0pi -e 's|<<<<<<< HEAD\n||; s|=======\n.*?>>>>>>> main\n||s' css/style.css
    # 解消後の :root を確定させる
    perl -0pi -e 's|:root \{.*?\}|:root {\n  --main-color: #334155;\n  --accent-color: #ff6f00;\n  --bg-color: #ffffff;\n}|s' css/style.css
    git add css/style.css
    git commit -q --no-edit
  fi
  git switch -q main
  git merge -q --no-edit feature/works-section
  git branch -q -d feature/works-section
}

build_c5() {
  build_c4
  cd "$DIR"
  readme_v3; git add README.md
  commit '2026-04-03T09:00:00' 'READMEに目的とローカルでの表示方法を追記'

  # origin の代役となる bare リポジトリ
  git init -q --bare "$ORIGIN"
  # bare リポジトリの既定ブランチ名は Git の設定に依存する。main に固定する。
  git -C "$ORIGIN" symbolic-ref HEAD refs/heads/main
  git remote add origin "$ORIGIN"
  git push -q -u origin main

  # もう一人の開発者のクローン
  git clone -q "$ORIGIN" "$PEER"
  ( cd "$PEER"
    git config user.name  "$PEER_NAME"
    git config user.email "$PEER_MAIL"
    mkdir -p docs
    printf '# 貢献ガイド\n\n変更は必ずブランチを切って行い、Pull Request でレビューを受けてください。\n' > docs/CONTRIBUTING.md
    git add docs/CONTRIBUTING.md
    GIT_AUTHOR_DATE='2026-04-03T10:00:00' GIT_COMMITTER_DATE='2026-04-03T10:00:00' \
      git commit -q -m '貢献ガイドを追加'
    git push -q origin main )

  # 自分の側で分岐を作り、merge で取り込む（U39 の題材）
  mkdir -p docs
  printf '# 作業メモ\n\n- 制作物セクションの追加中\n' > docs/memo.md
  git add docs/memo.md
  commit '2026-04-03T10:10:00' '作業メモを追加'
  git config pull.rebase false
  git fetch -q origin
  git merge -q --no-edit origin/main
  git push -q origin main
}

build_c6() {
  build_c5
  cd "$DIR"
  git switch -q -c feature/alt-text
  site_v7_html; git add index.html
  commit '2026-04-04T09:00:00' 'プロフィール画像にalt属性を追加'
  git switch -q main
  # squash マージを再現（元コミットは main の先祖にならない）
  git merge -q --squash feature/alt-text
  commit '2026-04-04T09:30:00' 'プロフィール画像にalt属性を追加 (#1)'
  git branch -q -D feature/alt-text
  git tag -a v1.0.0 -m '初回リリース：自己紹介と制作物セクションを公開'
  git push -q origin main
  git push -q origin v1.0.0
}

# ---------- 実行 ----------

case "$CP" in
  c1|c7) confirm_wipe; say "$CP の状態にしました（何もない状態）。次を実行してください: mkdir -p $DIR && cd $DIR" ;;
  c2|c3) confirm_wipe; build_c2; say "$CP の状態にしました: $DIR" ;;
  c4)    confirm_wipe; build_c4; say "c4 の状態にしました: $DIR" ;;
  c5)    confirm_wipe; build_c5; say "c5 の状態にしました: $DIR （origin=$ORIGIN, もう一人=$PEER）" ;;
  c6)    confirm_wipe; build_c6; say "c6 の状態にしました: $DIR （origin=$ORIGIN, もう一人=$PEER）" ;;
  *)     usage ;;
esac

if [ -d "$DIR/.git" ]; then
  echo
  say "現在の履歴"
  git -C "$DIR" log --oneline --graph --decorate --all
  echo
  say "作業ツリーの状態"
  git -C "$DIR" status --short --branch
fi
