# 総合課題 解答

各フェーズについて、**① 実行するコマンド／操作 → ② その時点のリポジトリ状態 → ③ 学習のポイント** の順で示す。
③ は本講座の到達目標に対応する。

コマンド中の `<your-account>` は受講者の GitHub アカウント名に読み替える。

---

## フェーズ 0：Git を使える状態にする

### ① 操作

```bash
git --version
# git version 2.43.0

git config --global user.name  "Taro Yamada"
git config --global user.email "taro@example.com"
git config --global init.defaultBranch main
git config --global core.editor "code --wait"

# 改行コード：macOS / Linux
git config --global core.autocrlf input
# 改行コード：Windows
git config --global core.autocrlf true

git config --list --show-origin

# 7) ヘルプで調べる
git config -h            # 主要オプションの一覧（短い）
git help config          # 詳細なマニュアル（q で終了）
#   --global の項に「~/.gitconfig に書き込む」旨の記述がある
```

### ② 状態

リポジトリはまだ存在しない。設定は `~/.gitconfig` に書き込まれている。

```
~/.gitconfig
  user.name  = Taro Yamada
  user.email = taro@example.com
  init.defaultBranch = main
  core.editor  = code --wait
  core.autocrlf = input
```

### ③ 学習のポイント

- **なぜ最初に `user.name` / `user.email` か**：コミットは「誰が」を必ず記録する。未設定だとコミット時にエラーになる。後から設定しても既存コミットの著者情報は変わらない（変えるには履歴の書き換えが必要）ため、**最初に**設定する。
- **なぜメールアドレスが GitHub と一致すべきか**：GitHub は commit の author email でアカウントを紐づける。不一致だと GitHub 上で自分の貢献として表示されない。公開したくない場合は GitHub の noreply アドレス（`12345+username@users.noreply.github.com`）を使う。
- **`--global` の有無**：`--global` は「この端末のこの OS ユーザーの既定値」（`~/.gitconfig`）。付けない場合は「そのリポジトリだけの設定」（`.git/config`）で、こちらが優先される。会社用と個人用でメールアドレスを使い分ける場合、リポジトリ単位で上書きする。
- **`init.defaultBranch`**：Git の既定は歴史的に `master` だが、GitHub をはじめ現在の実務では `main` が主流。合わせておかないと push のたびに不整合が起きる。
- **`core.autocrlf`**：Windows のエディタは改行を CRLF で保存する。設定しないと、Windows と macOS の開発者の間で「1 文字も直していないのに全行が変更扱い」になる。`input`（Mac/Linux）＝コミット時に LF へ変換、`true`（Windows）＝加えてチェックアウト時に CRLF へ戻す。
- **`--show-origin`**：設定が意図しないファイル（システム設定・リポジトリ設定）で上書きされていないか切り分けるため。設定トラブルの一次調査はまずこれ。
- **なぜ最初にヘルプの引き方を扱うのか**：本講座は自習であり、修了後は自力で調べる必要がある。`git <サブコマンド> -h` は数秒で読める要約、`git help <サブコマンド>` は網羅的なマニュアル、という使い分けを最初に身につけておくと、以降の学習でオプションを丸暗記する必要がなくなる。**エラーメッセージ自体が最良の検索語である**ことも合わせて伝える。

---

## フェーズ 1：リポジトリを作り、最初のコミットを行う

### ① 操作

```bash
mkdir -p ~/portfolio/css ~/portfolio/images
cd ~/portfolio
git init
# Initialized empty Git repository in /home/taro/portfolio/.git/

# 課題末尾の「初期ファイルの内容」に従って 3 ファイルを作成
#   README.md / index.html / css/style.css

git status
#   Untracked files:
#     README.md
#     css/
#     index.html

git add README.md index.html css/style.css

git status
#   Changes to be committed:
#     new file:   README.md
#     new file:   css/style.css
#     new file:   index.html

git commit -m "サイトの雛形を追加"
git log --oneline
# a1b2c3d (HEAD -> main) サイトの雛形を追加
```

### ② 状態

```
作業ツリー          インデックス         リポジトリ(.git)
README.md    ──add──→  README.md   ──commit──→  ┌──────────┐
index.html   ──add──→  index.html               │ a1b2c3d  │ ← main ← HEAD
css/style.css──add──→  css/style.css            └──────────┘
```

### ③ 学習のポイント

- **`git init` が作るもの**：カレントディレクトリに `.git/` ディレクトリを作るだけで、既存ファイルには一切触れない。`.git/` を削除すれば「Git を使っていない普通のフォルダ」に戻る。この可逆性を理解していると、初学者は `git init` を恐れずに試せる。
- **なぜ `add` と `commit` の 2 段階か**：作業ツリーの変更をすべて記録するのではなく、**記録したい変更だけを選んで**次のコミットに積む場が必要だから。その場がインデックス（ステージングエリア）。この 2 段階があるおかげで、フェーズ 2 の「コミットを分ける」が可能になる。
- **`git status` を add の前後で見る意味**：`Untracked files`（Git が存在を知らない）→ `Changes to be committed`（次のコミットに含まれる）という状態遷移を目で確認する。この 2 つの見出しの違いが 3 領域モデルの実体である。
- **`git add .` を使わなかった理由**：この段階では意図せぬファイル（`.DS_Store` 等）が混入しても気づけない。まず明示的に列挙する習慣をつけ、`.gitignore` を整備してから（フェーズ 2 以降）`.` を使う。
- **コミットメッセージ**：「更新」「修正」ではなく「何をしたか」を書く。履歴は数か月後の自分と同僚への説明資料である。

---

## フェーズ 2：無視するファイルを設定し、コミットを分ける

### ① 操作

```bash
cat > .gitignore <<'GITIGNORE'
# OS が生成するファイル
.DS_Store
Thumbs.db

# ログファイル
*.log

# 一時作業ディレクトリ
tmp/
GITIGNORE

git status          # .gitignore だけが Untracked
git add .gitignore
git commit -m "作業中に生成されるファイルを追跡対象から除外"

# 除外が効いているかの確認
mkdir -p tmp && echo "dummy" > tmp/work.log
git status          # 「nothing to commit, working tree clean」＝ 除外成功
git status --ignored   # 無視されているファイルを明示的に確認

# --- ここから 2 種類の変更を同時に行う ---
# 1) images/profile.png を追加し、index.html に <img> を追記
# 2) README.md にサイトの目的を追記

git status
#   Untracked files:   images/
#   Changes not staged for commit:   index.html, README.md

# 1 つ目のコミット：画像の追加
git add images/profile.png index.html
git commit -m "プロフィール画像を追加"

# 2 つ目のコミット：ドキュメントの追記
git add README.md
git commit -m "READMEにサイトの目的を追記"

# --- 小実験：ファイル名の大文字小文字 ---
mv README.md Readme.md
git status
#   macOS / Windows（既定）： nothing to commit, working tree clean   ← 検知されない
#   Linux                  ： deleted: README.md / Untracked files: Readme.md
mv Readme.md README.md      # 元に戻す
git status                  # clean

git log --oneline
# d4e5f6a (HEAD -> main) READMEにサイトの目的を追記
# c3d4e5f プロフィール画像を追加
# b2c3d4e 作業中に生成されるファイルを追跡対象から除外
# a1b2c3d サイトの雛形を追加
```

### ② 状態

```
a1b2c3d ── b2c3d4e ── c3d4e5f ── d4e5f6a  ← main ← HEAD
 雛形      .gitignore   画像追加    README追記

追跡対象外（コミットされない）：tmp/work.log
```

### ③ 学習のポイント

- **なぜ `.gitignore` 自体はコミットするのか**：「何を無視するか」はチーム全員で共有すべき決め事だから。`.gitignore` を無視してしまうと、各自が自分で設定し直す羽目になる。
- **無視すべきファイルの原則**：「**他のファイルから再生成できるもの**」（ビルド成果物、依存ライブラリ、キャッシュ）と「**環境固有・秘密のもの**」（OS 生成ファイル、API キー、ローカル設定）。逆に言えば、ソースコードと設定の雛形は必ず追跡する。
- **重要な制約**：`.gitignore` は「**まだ追跡されていない**ファイル」にしか効かない。一度コミットしたファイルは、後から `.gitignore` に書いても追跡され続ける。その場合は `git rm --cached <file>` で追跡を外す必要がある。この落とし穴はフェーズ 8 ケース 1 と直結する。
- **なぜコミットを 2 つに分けるのか**：
  1. **レビューしやすい**：1 コミット＝1 つの意図なら、レビュアーは「この変更は何のためか」を diff だけで判断できる。
  2. **取り消しやすい**：後から「画像追加だけをなかったことにしたい」となったとき、混ざっていると分離できない。フェーズ 8 ケース 2 の `revert` は、コミットが意味単位で分かれていて初めて有効に機能する。
  3. **原因を特定しやすい**：不具合の混入コミットを探すとき、粒度が粗いと「このコミットのどこが原因か」まで絞り込めない。
- **`git status --ignored`**：「なぜかコミットできないファイルがある」という初学者最頻出のつまずきは、大半が `.gitignore` に一致していることが原因。この確認手段を知っているかどうかで解決時間が変わる。
- **大文字小文字の実験が示すこと**：macOS と Windows の既定ファイルシステムは大文字小文字を区別しないため、Git もリネームを検知できない。一方 Linux は区別する。この非対称性が、**「手元では動くのに CI やサーバでだけファイルが見つからない」**という原因の分かりにくい事故を生む。
  - 対処：リネームは `git mv README.md Readme.md` のように **Git 経由で行う**（Git が明示的に記録する）。
  - 予防：ファイル名・ディレクトリ名は小文字とハイフンに統一するなど、チームで規約を決める。

---

## フェーズ 3：GitHub に公開する

### ① 操作

```bash
# 1) GitHub の Web 画面で新規リポジトリ portfolio を作成
#    - 公開範囲：本課題は公開を前提とした成果物のため Public を選ぶ（Private でも課題は成立する）
#    - 「Add a README file」「Add .gitignore」はチェックしない（重要）

# 2) SSH 鍵の生成（既に ~/.ssh/id_ed25519 があれば省略）
ssh-keygen -t ed25519 -C "taro@example.com"
#   保存先はそのまま Enter、パスフレーズは任意（推奨：設定する）

# 3) 公開鍵を GitHub に登録
cat ~/.ssh/id_ed25519.pub
#   出力全体をコピーし、GitHub の Settings > SSH and GPG keys > New SSH key に貼り付け

# 4) 接続確認
ssh -T git@github.com
#   Hi <your-account>! You've successfully authenticated, ...

# 5) リモートの登録と送信
git remote add origin git@github.com:<your-account>/portfolio.git
git remote -v
#   origin  git@github.com:<your-account>/portfolio.git (fetch)
#   origin  git@github.com:<your-account>/portfolio.git (push)

git push -u origin main
git branch -vv
#   * main d4e5f6a [origin/main] READMEにサイトの目的を追記

# 6) GitHub の Web 画面でコミット履歴を確認
# 7) トップページに README.md の内容が表示されていることを確認
# 8) README を目的・表示方法まで整えて追記（内容は下記）
git add README.md
git commit -m "READMEに目的とローカルでの表示方法を追記"
git push
```

整えた `README.md`：

~~~markdown
# ポートフォリオサイト

自己紹介と制作物を掲載する静的 Web サイトです。

## 目的

エンジニアを目指す山田太郎の自己紹介と、これまでの制作物を公開します。

## ローカルでの表示方法

リポジトリを取得し、`index.html` をブラウザで開いてください。

    git clone git@github.com:<your-account>/portfolio.git
    cd portfolio
    open index.html      # Windows は start / Linux は xdg-open
~~~

### ② 状態

```
ローカル (~/portfolio)                GitHub (origin)
  main ──────► e5f6a7b                  main ──► e5f6a7b
  origin/main ► e5f6a7b  （追跡ブランチ：ローカルが記憶している「GitHub の main の位置」）

  … ── d4e5f6a ── e5f6a7b   ← README を整備したコミット
```

### ③ 学習のポイント

- **なぜ README を自動生成させないのか**：GitHub 側で README を作ると、GitHub 側に**ローカルに存在しないコミット**ができる。すると最初の `git push` が「履歴が食い違う」として拒否され、初学者が最も詰まりやすい状況になる。空のリポジトリを作れば push は必ず成功する。
- **SSH と HTTPS の選択**：HTTPS + Personal Access Token でも同じことができるが、トークンには有効期限があり、期限切れ時に「昨日まで動いていた push が通らない」という原因の分かりにくい障害になる。SSH 鍵は一度登録すれば継続して使えるため、学習用途では SSH を推奨する。**なお、いずれの方式でも GitHub のパスワードそのものは使えない**（2021 年に廃止）。
- **`ssh -T` を先に実行する理由**：認証の問題と Git の問題を切り分けるため。`git push` が失敗したとき、それが「鍵の設定ミス」なのか「リポジトリ URL の誤り」なのか「履歴の食い違い」なのかを、この 1 コマンドで一段絞り込める。
- **`origin` とは何か**：リモートリポジトリの URL に付けた**別名**。慣習的に「自分がクローンした元」を `origin` と呼ぶだけで、Git の予約語ではない。複数のリモート（`origin` と `upstream` 等）を登録できる。
- **`-u`（`--set-upstream`）が設定するもの**：ローカルの `main` に「対応する相手は `origin/main` である」という関係（追跡ブランチ）を記録する。これにより以後は `git push` / `git pull` だけで済み、また `git status` が「origin/main より 2 コミット進んでいます」と教えてくれるようになる。
- **`origin/main` の正体**：GitHub の現在の状態ではなく、**最後に通信したときの GitHub の状態を記憶したローカルのブックマーク**。他人が GitHub を更新しても、`git fetch` するまでこの値は動かない。この理解がフェーズ 6 の前提になる。
- **Public と Private の選択（課題の問い）**：Public は**全世界から閲覧・複製が可能**になる。一度公開した内容は、後で Private に戻してもフォークや検索エンジンのキャッシュに残りうる。ポートフォリオのように「見せるために作る」ものは Public、業務や学習途中のものは Private が原則。
  - 置いてはいけないファイルの例：**認証情報**（API キー、パスワード、秘密鍵）、**個人情報**（他人の氏名・連絡先を含むデータ）、**権利のないもの**（業務で書いたコード、ライセンスを確認していない素材）。
  - 判断の基準は「このファイルが検索結果に出ても困らないか」。
- **README がリポジトリの入口である理由**：GitHub はリポジトリのトップページに `README.md` を自動で描画する。訪問者が最初に読むのはコードではなく README であり、**「何のためのものか」「どう動かすか」が書かれていないリポジトリは、他人にとって存在しないのと同じ**。最低限、目的・使い方（動かし方）・前提環境の 3 点を書く。逆に、認証情報や未確定の内部事情は書かない。

---

## フェーズ 4：ブランチを切って機能を追加する

### ① 操作

```bash
git switch -c feature/works-section
# Switched to a new branch 'feature/works-section'

# --- 変更 1：index.html に制作物セクションを追加 ---
```
```html
  <section id="works">
    <h2>制作物</h2>
    <ul>
      <li><a href="https://example.com/app1">タスク管理アプリ</a></li>
      <li><a href="https://example.com/app2">天気予報ビューア</a></li>
    </ul>
  </section>
```
```bash
git add index.html
git commit -m "制作物セクションのHTMLを追加"

# --- 変更 2：css/style.css にスタイルを追加 ---
```
```css
:root {
  --main-color: #1e88e5;
  --accent-color: #ff6f00;   /* ← 追加（--main-color の直下） */
  --bg-color: #ffffff;
}

/* ファイル末尾に追加 */
#works h2 {
  border-left: 4px solid var(--accent-color);
  padding-left: 8px;
}
```
```bash
git add css/style.css
git commit -m "制作物セクションのスタイルを追加"

# --- 変更 3：README にディレクトリ構成を追記 ---
git add README.md
git commit -m "READMEにディレクトリ構成の説明を追記"

git push -u origin feature/works-section

git log --oneline --graph --decorate --all
# * b8c9d0e (HEAD -> feature/works-section, origin/feature/works-section) READMEにディレクトリ構成の説明を追記
# * a7b8c9d 制作物セクションのスタイルを追加
# * f6a7b8c 制作物セクションのHTMLを追加
# * e5f6a7b (origin/main, main) READMEに目的とローカルでの表示方法を追記
```

### ② 状態

```
                          f6a7b8c ── a7b8c9d ── b8c9d0e  ← feature/works-section ← HEAD
                        /
a1b2c3d ── … ── e5f6a7b                                  ← main
```

### ③ 学習のポイント

- **ブランチの実体**：ブランチは「コミットを指す 41 バイトの付箋」に過ぎず、コピーではない。だから作成は一瞬で、コストを気にせず何本でも切れる。この事実を理解していないと、初学者は「ブランチを作るとファイルが複製される」と誤解して使うのを避けてしまう。
- **`HEAD` とは**：「今どのブランチにいるか」を指す参照。`git commit` は HEAD が指すブランチの付箋を、新しいコミットへ**前に進める**。
- **ブランチを切り替えると何が起きるか**：`.git` の中身は不変で、**作業ツリーのファイルがそのブランチの内容に書き換わる**。ゆえに未コミットの変更を抱えたまま切り替えると、警告が出るか変更を持ち越すことになる（対処は `git stash` またはコミット）。
- **なぜ main で直接作業しないのか**：main は「いつでもリリースできる状態」に保つ。作業途中の壊れた状態を main に置くと、他の開発者が壊れたコードを取り込んでしまう。また、作業を丸ごと破棄したいときにブランチごと削除すれば済む。
- **ブランチ名の付け方**：`feature/` `fix/` `docs/` のようにスラッシュ区切りの接頭辞を付けると、種類が一目で分かり、GitHub の一覧でも階層表示される。個人名（`taro-branch`）ではなく**作業内容**を名前にする。
- **CSS 変数を `:root` に追加した意図（教材上の設計）**：フェーズ 6 で鈴木さんが同じ `:root` ブロックの隣接行を編集するため、確実にコンフリクトが発生する。コンフリクトは「同じファイルを触ったから」ではなく「**同じ、または隣接する行**を両者が変更したから」起きる、という原則をここで体験させる。

---

## フェーズ 5：もう一人の開発者として main を更新する

### ① 操作

```bash
cd ~
# あえて HTTPS 形式で clone する（clone 自体は公開リポジトリなら認証なしで成功する）
git clone https://github.com/<your-account>/portfolio.git portfolio-suzuki
cd portfolio-suzuki

# このリポジトリだけの設定（--global を付けない）
git config user.name  "Hanako Suzuki"
git config user.email "hanako@example.com"
git config user.name          # Hanako Suzuki

git branch -a
# * main
#   remotes/origin/HEAD -> origin/main
#   remotes/origin/feature/works-section
#   remotes/origin/main

# css/style.css の --main-color を変更
#   --main-color: #1e88e5;  →  --main-color: #334155;

git diff
git add css/style.css
git commit -m "全体の配色を落ち着いたトーンに変更"

git push origin main
#   Username for 'https://github.com':
#   Password for 'https://...':
#   remote: Support for password authentication was removed on August 13, 2021.
#   fatal: Authentication failed for 'https://github.com/<your-account>/portfolio.git/'

# 原因：HTTPS 形式では毎回の認証が必要で、GitHub のパスワードは使えない
#       （Personal Access Token を発行するか、SSH 形式に切り替える）
git remote -v
#   origin  https://github.com/<your-account>/portfolio.git (fetch/push)

git remote set-url origin git@github.com:<your-account>/portfolio.git
git remote -v
#   origin  git@github.com:<your-account>/portfolio.git (fetch/push)

git push origin main       # 今度は登録済みの SSH 鍵で通る
```

### ② 状態

```
GitHub (origin)
  main ──► e5f6a7b ── c9d0e1f   ← 鈴木さんのコミット
  feature/works-section ──► b8c9d0e

A のローカル (~/portfolio)：まだ c9d0e1f の存在を知らない
  origin/main ──► e5f6a7b   （古い記憶のまま）
```

### ③ 学習のポイント

- **`git clone` が一度に行うこと**：(1) `.git` を含むリポジトリ全体（全履歴）の複製、(2) `origin` リモートの自動登録、(3) 既定ブランチのチェックアウトと追跡設定。`init` + `remote add` + `fetch` + `switch` をまとめた操作である。
- **分散型バージョン管理の要点**：clone した時点で、鈴木さんの手元にも**完全な履歴**がある。中央サーバに問い合わせなくても `git log` も `git diff` もブランチ作成も可能で、これが Subversion 等の集中型との決定的な違い。オフラインで作業できる理由でもある。
- **なぜ `--global` を付けてはいけないか**：付けると端末全体の既定が `Hanako Suzuki` に変わり、`~/portfolio` での自分のコミットまで鈴木さん名義になる。**設定の適用範囲（システム < グローバル < リポジトリ）**を体で理解させるのが本フェーズの狙い。実務でも「会社のリポジトリだけ会社のメールアドレス」という形で日常的に使う。
- **鈴木さんが main へ直接 push している点について**：実務では main への直接 push を禁止する（ブランチ保護）のが一般的だが、本課題では A 側にコンフリクトを起こす状況を最短で作るために意図的にこうしている。**教材ではこの点を注記**。
- **HTTPS でつまずかせる意図**：`clone` は成功したのに `push` で認証に失敗する、という現象は初学者の最頻出障害の一つ。原因は「公開リポジトリの読み取りは認証不要、書き込みは認証必須」という非対称性にある。
  - **GitHub のパスワードは 2021 年 8 月に廃止**されており、パスワード欄に何を入れても通らない。エラーメッセージ本文がそう告げている点を必ず読ませる。
  - 解決策は 2 つ。(1) Personal Access Token を発行してパスワード欄に入力する、(2) `git remote set-url` でリモート URL を SSH 形式に変更する。既に SSH 鍵を登録済み（フェーズ 3）なので、ここでは (2) が最短。
  - **URL 形式の見分け方**：`https://github.com/user/repo.git` は HTTPS、`git@github.com:user/repo.git` は SSH。`git remote -v` で常に確認できる。
  - リモート URL は**リポジトリごとの設定**であり、`~/portfolio` 側は SSH のままで影響を受けない。

---

## フェーズ 6：他人の変更を取り込み、コンフリクトを解消する

### ① 操作

```bash
cd ~/portfolio

# 1) 取得のみ。作業ツリーは書き換えない
git fetch origin

# 2) 差分の確認：何が増えるか（コミット単位）と、何が変わるか（ファイル単位）
git log --oneline main..origin/main
#   c9d0e1f 全体の配色を落ち着いたトーンに変更
git diff --stat main origin/main
#   css/style.css | 2 +-
git diff main origin/main
#   -  --main-color: #1e88e5;
#   +  --main-color: #334155;

# 3) ローカルの main を追いつかせる（fast-forward）
git switch main
git merge origin/main
#   Updating e5f6a7b..c9d0e1f
#   Fast-forward

# 4) feature ブランチに main を取り込む
git switch feature/works-section
git merge main
#   Auto-merging css/style.css
#   CONFLICT (content): Merge conflict in css/style.css
#   Automatic merge failed; fix conflicts and then commit the result.

# 5) コンフリクトしているファイルの確認
git status
#   Unmerged paths:
#     both modified:   css/style.css
git diff --name-only --diff-filter=U
#   css/style.css
```

`css/style.css` の中身：

```css
:root {
<<<<<<< HEAD
  --main-color: #1e88e5;
  --accent-color: #ff6f00;
=======
  --main-color: #334155;
>>>>>>> main
  --bg-color: #ffffff;
}
```

| 記号 | 意味 |
|---|---|
| `<<<<<<< HEAD` 〜 `=======` | **今いるブランチ**（`feature/works-section`）＝ 自分の変更 |
| `=======` 〜 `>>>>>>> main` | **取り込もうとしているブランチ**（`main`）＝ 鈴木さんの変更 |

両者を活かす形に手で書き換える：

```css
:root {
  --main-color: #334155;
  --accent-color: #ff6f00;
  --bg-color: #ffffff;
}
```

```bash
# 6) 解消の記録
git add css/style.css
git status         # All conflicts fixed but you are still merging
git commit         # エディタが開く。既定のメッセージのままで可
git push

# 7) 履歴の確認
git log --oneline --graph --decorate --all
# *   d0e1f2a (HEAD -> feature/works-section, origin/feature/works-section) Merge branch 'main' into feature/works-section
# |\
# | * c9d0e1f (origin/main, main) 全体の配色を落ち着いたトーンに変更
# * | b8c9d0e READMEにディレクトリ構成の説明を追記
# * | a7b8c9d 制作物セクションのスタイルを追加
# * | f6a7b8c 制作物セクションのHTMLを追加
# |/
# * e5f6a7b READMEに目的とローカルでの表示方法を追記

# --- 8) 履歴が「分岐」した状態で pull するとどうなるか ---

# 8-1) 鈴木さん役：新しいファイルを追加して push
cd ~/portfolio-suzuki
git pull
mkdir -p docs && echo "# 貢献ガイド" > docs/CONTRIBUTING.md
git add docs/CONTRIBUTING.md
git commit -m "貢献ガイドを追加"
git push                                    # origin/main = e1f2a3b

# 8-2) 自分：pull せずに main でコミットする
cd ~/portfolio
git switch main
mkdir -p docs && echo "# 作業メモ" > docs/memo.md
git add docs/memo.md
git commit -m "作業メモを追加"               # ローカル main = f2a3b4c

# 8-3) この状態で pull すると停止する
git pull
#   hint: You have divergent branches and need to specify how to reconcile them.
#   hint:   git config pull.rebase false  # merge
#   hint:   git config pull.rebase true   # rebase
#   hint:   git config pull.ff only       # fast-forward only
#   fatal: Need to specify how to reconcile divergent branches.

# 8-4) 既定動作を明示して取り込む（このリポジトリのみの設定）
git config pull.rebase false
git pull
#   Merge made by the 'ort' strategy.
#    docs/CONTRIBUTING.md | 1 +

git log --oneline --graph -4
# *   a3b4c5d (HEAD -> main) Merge branch 'main' of github.com:<your-account>/portfolio
# |\
# | * e1f2a3b (origin/main) 貢献ガイドを追加
# * | f2a3b4c 作業メモを追加
# |/
# * c9d0e1f 全体の配色を落ち着いたトーンに変更

git push
```

### ② 状態

```
手順 6 完了時点：

                f6a7b8c ─ a7b8c9d ─ b8c9d0e ─┐
              /                               ├─ d0e1f2a ← feature/works-section
e5f6a7b ─────┴────────── c9d0e1f ─────────────┘
                            ↑ main

手順 8 完了時点（main が分岐して再合流）：

                          f2a3b4c ─┐          （自分：docs/memo.md）
                        /           ├─ a3b4c5d ← main
c9d0e1f ───────────────┴─ e1f2a3b ─┘          （鈴木さん：docs/CONTRIBUTING.md）
```

### ③ 学習のポイント

- **`fetch` と `pull` の違い**：`pull` = `fetch` + `merge`。`fetch` は「GitHub の最新状態を**取ってきて `origin/main` を更新するだけ**」で、作業ツリーもローカルブランチも動かさない。`pull` はそこから自動でマージまで進む。**内容を確認してから取り込みたい場面では `fetch` → 差分確認 → `merge` の 3 段階に分ける**。初学者に `pull` だけを教えると、意図しないマージやコンフリクトが突然発生して混乱する。
- **`main..origin/main` の読み方**：「`origin/main` にあって `main` にないコミット」＝これから取り込まれる分。取り込み前に何が来るかを把握する常套手段。
- **fast-forward とは**：分岐がなく、片方がもう片方の先祖である場合、Git はマージコミットを作らずブランチの付箋を前へずらすだけで済ませる。手順 3 がこれに該当する（ローカル main では何も作業していないため）。
- **手順 4 の向き（`main` を feature に取り込む）を選ぶ理由**：main は共有ブランチであり、壊れた状態にしてはならない。**統合作業とコンフリクト解消は、自分の作業ブランチ側で行い、main には解決済みの状態だけをマージする**。これが実務の鉄則。
- **なぜコンフリクトが起きたのか**：両ブランチが `css/style.css` の**同一行付近**を別々に変更したため。Git は行単位で自動統合を試み、どちらを採用すべきか判断できない箇所だけを人間に委ねる。ファイルが同じでも変更箇所が離れていれば自動でマージされる。
- **解消時に人間が担う判断**：Git はどちらが「正しい」かを知らない。ここでは「配色変更（鈴木さん）」と「新セクション用の色追加（自分）」は**目的が異なり両立する**ため、両方採用が正解。片方の意図を消す解消（`--ours` / `--theirs` の安易な適用）は、実務では機能の消失事故になる。
- **`git commit` でエディタが開く理由**：マージコミットは Git が既定メッセージを用意する。マージ中に限り `git commit` を引数なしで実行してよい（`-m` で上書きしても構わない）。
- **コンフリクトを途中でやめたい場合**：`git merge --abort` でマージ開始前の状態に完全に戻せる。**逃げ道があることを先に教える**ことが、初学者の心理的な障壁を下げる。
- **rebase という選択肢**：`git rebase main` を使えば、自分のコミットを main の先端に付け替え、履歴が一直線になる。ただし (1) コミット単位で解消を求められることがある、(2) コミットハッシュが変わるため既に push 済みのブランチでは強制 push が必要、という難しさがある。**本課題では merge を正解とし、rebase はフェーズ 7 の squash と合わせて「履歴を整える手法」として紹介するに留める**。

#### 手順 8（分岐した状態での pull）について

- **「分岐（divergent）」とは何か**：共通の祖先から、ローカルとリモートが**それぞれ独自のコミットを持って**進んだ状態。`git status` は「ahead 1, behind 1」と表示する。手順 3 の fast-forward（ローカルに独自コミットがなく、ただ遅れているだけ）とは根本的に別の状況である。
- **なぜ Git は止まるのか**：Git 2.27 以降、分岐時の `pull` は**既定動作を明示していないとエラーで停止する**。以前は黙って merge していたが、意図しないマージコミットが量産される問題があったため、利用者に選ばせる仕様に変わった。**現行の Git を使う限り、初学者は必ずこの画面に遭遇する。**
- **3 つの選択肢の意味**：

  | 設定 | 動作 | 結果の履歴 |
  |---|---|---|
  | `pull.rebase false` | fetch + merge | マージコミットが 1 つ増える |
  | `pull.rebase true` | fetch + rebase | 一直線。自分のコミットのハッシュが変わる |
  | `pull.ff only` | fast-forward できるときのみ実行 | 分岐時は何もせず停止する（明示的に対処させる） |

- **本課題で `false`（merge）を選ぶ理由**：この時点で rebase は未習であり、履歴の書き換えを伴う操作を「よく分からないまま既定にする」のは危険だから。実務では `pull.rebase true` や `pull.ff only` を選ぶチームも多い。**重要なのは、どれを選ぶかより「チームで揃えて明示する」こと**。
- **なぜ今回はコンフリクトしなかったのか**：双方が**別々のファイル**を追加したため。分岐＝コンフリクトではない。Git は変更箇所が重ならなければ自動で統合する。
- **コンフリクトを起こしにくくする習慣（確認事項の解答例）**：
  1. **作業を始める前に必ず最新を取り込む**（`git switch main && git pull` してからブランチを切る）。今回のコンフリクトは、A が作業開始後に鈴木さんが main を変更したために起きた。取り込み間隔が長いほど衝突面積は広がる。
  2. **ブランチを長生きさせない**。変更を小さく保ち、こまめに PR を出してマージする。1 週間放置したブランチは、それだけで衝突の温床になる。
  3. **同じ箇所を同時に触らないよう分担する**。特に CSS 変数の定義部・設定ファイル・共通定数のような「全員が触る 1 箇所」は、あらかじめ担当や変更タイミングを決めておく。
  → コンフリクトは**解消技術より運用で減らす**。解消手順だけを覚えて安心してはいけない。

---

## フェーズ 7：Pull Request でレビューを受けてマージする

### ① 操作

```
GitHub Web 画面：
  1. リポジトリの [Pull requests] > [New pull request]
  2. base: main  ←  compare: feature/works-section
  3. タイトル：制作物セクションを追加
     説明：
       ## 変更内容
       - index.html に制作物セクション（#works）を追加
       - style.css に --accent-color を新設し、見出しの装飾に使用
       - README.md にディレクトリ構成を追記
       ## 確認方法
       index.html をブラウザで開き、制作物セクションが表示されること
  4. [Create pull request]
```

レビュー指摘への対応：

```bash
cd ~/portfolio
git switch feature/works-section
# index.html の <img> に alt 属性を追加
git add index.html
git commit -m "プロフィール画像にalt属性を追加"     # b4c5d6e
git push
#   → Pull Request の画面が自動で更新される（PR を作り直す必要はない）
```

```
GitHub Web 画面：
  5. [Merge pull request] のドロップダウンから [Squash and merge] を選択
  6. コミットメッセージを確認して [Confirm squash and merge]
```

```bash
# ローカルの後片付け
git switch main
git pull
git log --oneline --graph -6
# * c5d6e7f (HEAD -> main, origin/main) 制作物セクションを追加 (#1)
# *   a3b4c5d Merge branch 'main' of github.com:<your-account>/portfolio
# |\
# | * e1f2a3b 貢献ガイドを追加
# * | f2a3b4c 作業メモを追加
# |/
# * c9d0e1f 全体の配色を落ち着いたトーンに変更

git branch -d feature/works-section
#   error: The branch 'feature/works-section' is not fully merged.
git branch -D feature/works-section    # 内容がmainに入っていることを確認済みなので強制削除

git push origin --delete feature/works-section
git fetch --prune                      # 削除済みリモートブランチの記録を掃除
```

### ② 状態

```
■ squash マージ前

       f6a7b8c─a7b8c9d─b8c9d0e─┐
      /                        ├─ d0e1f2a ── b4c5d6e   ← feature/works-section
e5f6a7b ────── c9d0e1f ────────┘                         （5 コミット）
                    │
                    └── f2a3b4c ─┐
                                  ├─ a3b4c5d            ← main
                     e1f2a3b ────┘

■ squash マージ後の main

e5f6a7b ─ c9d0e1f ─ f2a3b4c ─ e1f2a3b ─ a3b4c5d ─ c5d6e7f
                                                      ↑
                                     feature の 5 コミット分の変更が
                                     新しい 1 コミットに圧縮されている
                                     （元の 5 コミットは main の先祖ではない）
```

### ③ 学習のポイント

- **Pull Request は Git の機能ではない**：GitHub / GitLab 等のホスティングサービスが提供する仕組みで、「このブランチを取り込んでほしい」という依頼と、そこに紐づくレビュー・議論・自動テストの場である。Git 自体は PR を知らない。この区別を曖昧にすると、他のサービスや `git` 単体の環境で応用が利かなくなる。
- **なぜブランチを push してから PR を作るのか**：PR は GitHub 上の 2 ブランチを比較する。ローカルにしかないブランチは比較対象にできない。
- **PR に追加 push すると自動反映される理由**：PR が参照しているのは「特定のコミット」ではなく「ブランチ」だから。修正のたびに PR を作り直す必要はない。
- **マージ方式の使い分け**：

  | 方式 | main に残る履歴 | 向いている場面 |
  |---|---|---|
  | Merge commit | 全コミット + マージコミット | 作業過程も履歴として残したい／大きな機能 |
  | Squash and merge | 1 コミットに圧縮 | 途中の試行錯誤コミットが多い／main を読みやすく保ちたい |
  | Rebase and merge | 全コミットを一直線に | コミット 1 つ 1 つが整理されている |

  実務では **Squash and merge を既定にするチームが多い**。「main の 1 コミット = 1 つの PR = 1 つの機能」となり、履歴が読みやすく、`revert` の単位も明確になるため。
- **`git branch -d` が失敗する理由（重要な学習ポイント）**：`-d` は「このブランチのコミットが現在のブランチに含まれているか」を**コミットハッシュで**判定する。squash マージは元の 4 コミットを捨てて**新しい 1 コミット**を作るため、`f6a7b8c` 等は main の先祖に存在しない。よって Git は「未マージ」と判断する。内容は間違いなく main に入っているので `-D` で削除してよい。
  → **`-D` は「内容が取り込まれていることを自分で確認した」場合にのみ使う**。確認せずに `-D` する癖は、作業の消失につながる。
- **`git fetch --prune`**：GitHub 側で削除したブランチも、ローカルの `origin/xxx` の記憶は残り続ける。`--prune` で実体のない記録を掃除する。`git branch -a` に消したはずのブランチが並ぶ現象の対処法。

---

## フェーズ 8：事故に対処する

### ケース 1：機密ファイルを含むコミット（未 push）

#### ① 操作

```bash
mkdir -p config
echo "SECRET_TOKEN=abcdef123456" > config/api-key.txt
# index.html の <h1> を修正

git add .
git commit -m "設定ファイルを追加"

# 混入に気づく
git show --stat HEAD
#   config/api-key.txt | 1 +
#   index.html         | 2 +-

# コミットだけを取り消す（変更はインデックスに残す）
git reset --soft HEAD~1
git status
#   Changes to be committed:
#     new file:   config/api-key.txt
#     modified:   index.html

# 機密ファイルをインデックスから外す
git restore --staged config/api-key.txt
git status
#   Changes to be committed:   modified: index.html
#   Untracked files:           config/

# 再発防止
echo "config/" >> .gitignore
git add .gitignore
git commit -m "設定ファイルのディレクトリを追跡対象から除外"

# 本来したかった修正を単独でコミット
git add index.html
git commit -m "見出しの表記を修正"

git status         # config/ は無視され、clean になる
```

#### ③ 学習のポイント

- **なぜ `--soft` か**：`git reset` の 3 つのモードの違いが本ケースの核心。

  | モード | HEAD | インデックス | 作業ツリー | 用途 |
  |---|---|---|---|---|
  | `--soft` | 戻す | そのまま | そのまま | **コミットだけをやり直す** |
  | `--mixed`（既定） | 戻す | 戻す | そのまま | add をやり直す |
  | `--hard` | 戻す | 戻す | **戻す** | 変更を完全に破棄（危険） |

  ここで `--hard` を使うと `index.html` の修正も消える。課題文の「修正内容は失わずに」という条件が、モード選択を強制している。
- **`HEAD~1` の意味**：HEAD の 1 つ前のコミット。「そこまで巻き戻す」と読む。
- **`git commit --amend` ではだめか**：`git rm --cached config/api-key.txt` の後に `--amend` でも同じ結果が得られ、実務ではこちらも一般的。ただし amend は「直前のコミットを差し替える」操作で、reset より内部の動きが見えにくい。**教材としては 3 領域の動きが明示的に追える reset を主、amend を別解として扱う**。
- **未 push だから安全にやり直せる**：この操作は履歴の書き換えである。GitHub に送信していない＝他人がそのコミットを持っていないため、書き換えても誰にも影響しない。**「push 前なら履歴は自由に整えてよい」**が原則。

---

### ケース 2：誤った内容を push してしまった

#### ① 操作

```bash
# 誤りの作り込み
echo "このサイトは Ruby on Rails で構築されています。" >> README.md
git add README.md
git commit -m "READMEに技術構成を追記"
git push

# 誤りに気づく
git log --oneline -3
#   f8a9b0c (HEAD -> main, origin/main) READMEに技術構成を追記

# 打ち消しコミットを作る（履歴は書き換えない）
git revert f8a9b0c
#   エディタが開く → 既定メッセージ "Revert "READMEに技術構成を追記"" のまま保存

git log --oneline -3
#   a9b0c1d (HEAD -> main) Revert "READMEに技術構成を追記"
#   f8a9b0c READMEに技術構成を追記

git push
```

#### ③ 学習のポイント

- **なぜ `reset` ではなく `revert` か**：`f8a9b0c` は既に GitHub にあり、他の開発者が `pull` している可能性がある。`reset` + 強制 push で消すと、**そのコミットを持っている人のローカル履歴と食い違い**、次の pull でコンフリクトや作業消失が起きる。
  → **原則：push 済みの履歴は書き換えない。打ち消したいときは「打ち消すコミットを新しく積む」。**
- **`revert` の動作**：指定コミットの変更内容を**逆向きに適用した新しいコミット**を作る。履歴には「誤りを入れた事実」と「打ち消した事実」の両方が残る。これは欠点ではなく、**監査可能性という利点**である。
- **`git revert` と `git reset` の使い分け（本課題最重要）**：

  | 状況 | 使うもの | 理由 |
  |---|---|---|
  | まだ push していない | `reset` / `commit --amend` | 誰も知らないので書き換えてよい |
  | すでに push した | `revert` | 他人の履歴を壊さない |
  | 手元の作業を捨てたい | `restore` | コミットには関係しない |

- **機密情報を push してしまった場合の正解（課題の問い）**：
  1. **最初にすべきことは、その認証情報を無効化・再発行すること。** push した時点で漏洩は成立しており、Git の操作では解決しない。
  2. 履歴からの完全削除は `git filter-repo` 等で可能だが、全コミットハッシュが変わり、全員に強制 push と再クローンを強いる大掛かりな作業になる。
  3. GitHub のフォークやキャッシュ、クローン済みの他人の手元には残り続ける可能性がある。
  → **「Git で消せば安全」ではない。鍵を失効させることが唯一の確実な対処**という理解が、実務上の安全に直結する。

---

### ケース 3：コミットを消してしまった

#### ① 操作

```bash
echo "更新履歴：2026-09-01 公開" >> README.md
git add README.md
git commit -m "READMEに更新履歴を追記"
git log --oneline -1
#   b0c1d2e (HEAD -> main) READMEに更新履歴を追記

# 誤操作
git reset --hard HEAD~1
git log --oneline -1
#   a9b0c1d (HEAD -> main) Revert "READMEに技術構成を追記"
#   → b0c1d2e が履歴から消え、README.md の追記も消えている

# 復旧
git reflog
#   a9b0c1d HEAD@{0}: reset: moving to HEAD~1
#   b0c1d2e HEAD@{1}: commit: READMEに更新履歴を追記   ← これ
#   a9b0c1d HEAD@{2}: commit: Revert "READMEに技術構成を追記"

git reset --hard b0c1d2e       # HEAD@{1} でも可
git log --oneline -1
#   b0c1d2e (HEAD -> main) READMEに更新履歴を追記
```

#### ③ 学習のポイント

- **`reflog` とは**：HEAD が過去に指していた位置の**ローカルの操作ログ**。commit / reset / merge / switch など HEAD を動かすたびに記録される。`git log` が「履歴を辿った結果」を見せるのに対し、`reflog` は「自分がどう動いたか」を見せる。
- **なぜ復旧できるのか**：`reset --hard` はブランチの付箋を動かすだけで、**コミットオブジェクト自体はすぐには消えない**（既定で 90 日間残る）。参照されなくなって「見えなくなった」だけである。この仕組みを知っていることが、事故時に慌てないための最大の保険。
- **`reset --hard` は何を失うか**：コミット済みの内容は reflog から戻せる。しかし**コミットしていない作業ツリーの変更は戻せない**。「怖いのは reset ではなく、コミットしていないこと」。こまめなコミットが最良の防御である。
- **`reflog` はローカル限定**：clone しても他人の reflog は付いてこない。復旧作業は事故が起きた本人の端末で行う必要がある。

---

## フェーズ 9：リリースと履歴の説明

### ① 操作

```bash
git switch main
git pull

git tag -a v1.0.0 -m "初回リリース：自己紹介と制作物セクションを公開"
git tag
#   v1.0.0
git show v1.0.0 --stat

git push origin v1.0.0
#   GitHub の [Tags] / [Releases] に表示される

git log --oneline --graph --decorate --all
```

### ② 最終状態

```
* b0c1d2e (HEAD -> main, tag: v1.0.0, origin/main) READMEに更新履歴を追記
* a9b0c1d Revert "READMEに技術構成を追記"
* f8a9b0c READMEに技術構成を追記
* e7f8a9b 見出しの表記を修正
* d6e7f8a 設定ファイルのディレクトリを追跡対象から除外
* c5d6e7f 制作物セクションを追加 (#1)
*   a3b4c5d Merge branch 'main' of github.com:<your-account>/portfolio
|\
| * e1f2a3b 貢献ガイドを追加
* | f2a3b4c 作業メモを追加
|/
* c9d0e1f 全体の配色を落ち着いたトーンに変更
* e5f6a7b READMEに目的とローカルでの表示方法を追記
* d4e5f6a READMEにサイトの目的を追記
* c3d4e5f プロフィール画像を追加
* b2c3d4e 作業中に生成されるファイルを追跡対象から除外
* a1b2c3d サイトの雛形を追加
```

読み取れること：

| 履歴上の特徴 | 何が起きたか |
|---|---|
| `a3b4c5d` のマージコミットと `\|/` の分岐 | 2 人が同時に別々のファイルを追加し、pull 時に自動統合された（フェーズ 6-8） |
| `c5d6e7f` に `(#1)` が付いている | Pull Request 経由で squash マージされた（フェーズ 7）。feature ブランチの 5 コミットは残っていない |
| `f8a9b0c` と `a9b0c1d` が対になっている | 誤った変更と、それを打ち消した記録の両方が残っている（フェーズ 8 ケース 2） |
| `feature/works-section` が表示されない | マージ後に削除済み（フェーズ 7） |
| `tag: v1.0.0` が最新コミットに付いている | この時点をリリースとして公開した |

### 履歴の説明（解答例・約 200 字）

> このリポジトリでは、まずサイトの雛形を作り、不要ファイルの除外設定と画像・説明の追加を行いました。その後「制作物セクション」を別ブランチで開発する一方、もう一人の開発者が全体の配色を変更したため、両者の変更を統合してコンフリクトを解消しています。統合した機能は Pull Request でレビューを受け、1 つのコミットにまとめて公開しました。途中で誤った説明を追記した箇所は、打ち消しのコミットで訂正しています。最新の状態を v1.0.0 として公開しました。

### ③ 学習のポイント

- **注釈付きタグ（`-a`）と軽量タグの違い**：`-a` を付けると、タグ自体が作成者・日時・メッセージを持つ独立したオブジェクトになる。リリースの記録として残すなら `-a` を使う。付けない場合は単なるコミットへの別名で、情報が残らない。
- **`git push` はタグを送らない**：ブランチとタグは別管理のため、`git push origin v1.0.0`（または `--tags`）が必要。「タグを打ったのに GitHub に出ない」は頻出のつまずき。
- **`--decorate` の意味**：どのコミットにブランチ・タグ・`HEAD` が付いているかを表示する。**ブランチとタグが「コミットに付けた付箋」であること**が視覚的に確認できる、講座全体の総まとめとなる出力。
- **履歴を説明させる意図**：Git の到達点は「操作できること」ではなく「**履歴が読める／読ませられること**」。コミットメッセージの品質、コミットの粒度、ブランチ運用のすべてが、この説明のしやすさに現れる。ここで説明に詰まる受講者は、前段のどこかで粒度やメッセージが崩れている。

---

## 本課題がカバーする主要概念（フェーズ対応表）

| 概念 | 主な登場フェーズ |
|---|---|
| 設定の適用範囲（system / global / local） | 0, 5 |
| リポジトリ・`.git` ディレクトリ | 1, 5 |
| 3 領域（作業ツリー / インデックス / リポジトリ） | 1, 2, 8-1 |
| コミット・コミットハッシュ・コミットの粒度 | 1, 2, 4 |
| 追跡対象と `.gitignore` | 2, 8-1 |
| リモート・`origin`・追跡ブランチ | 3, 5, 6 |
| 認証（SSH 鍵 / PAT） | 3 |
| clone と分散型の意味 | 5 |
| ブランチ・HEAD・参照 | 4, 6, 9 |
| fetch / pull / push の違い | 3, 6 |
| マージ（fast-forward / 3-way）とコンフリクト | 6 |
| Pull Request とレビュー | 7 |
| squash マージと履歴の設計 | 7 |
| reset の 3 モード / restore / revert | 8 |
| reflog と復旧 | 8-3 |
| 履歴書き換えの境界（push 前後） | 8-1, 8-2 |
| 機密情報の取り扱い | 8-1, 8-2 |
| タグとリリース | 9 |
| 履歴を読む・説明する | 4, 6, 9 |
| ヘルプによる自己解決 | 0 |
| ファイル名の大文字小文字（環境差異） | 2 |
| リポジトリの公開範囲と README | 3 |
| リモート URL の形式（SSH / HTTPS）と変更 | 5 |
| コミット・ブランチ間の差分比較と履歴の範囲指定 | 6 |
| 分岐した状態での pull と既定動作の設定 | 6 |
| コンフリクトの予防 | 6 |
