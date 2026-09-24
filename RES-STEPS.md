# RES-STEPS：モジュール 3〜8 を貫く操作ステップ

モジュール 3 から 8 までの各単元は、**同一のサンプルリポジトリに対する連続した作業**の
ステップとして構成される。ファイルの内容は `RES-SITE.md` を参照。

## 前提となる約束

- 作業ディレクトリは `~/portfolio`（モジュール 6 以降はもう一つ `~/portfolio-suzuki` を使う）。
- **モジュール 5 までは「もう一人の開発者」をローカルの `main` への直接コミットで代用する。**
  リモートリポジトリを未習のため、2 リポジトリ体制はモジュール 6 で導入する。
  モジュール 5 の単元では、実際のチーム開発では別の人が別の場所で行う作業を自分の手元で再現している。
- コミットハッシュは環境ごとに異なる。教材の `a1b2c3d` などは**例示である**ことに注意。実際の値は `git log` で確認すること。

## チェックポイント

各モジュールの開始時点の状態。`RES-RESET/reset-to.sh` で再現できる。

| 記号 | 時点 | リポジトリの状態 |
|---|---|---|
| C1 | モジュール 3 開始 | `~/portfolio` が存在しない（何もない状態） |
| C2 | モジュール 4 開始 | RES-SITE V2 の全ファイルがコミット済み。作業ツリーは clean |
| C3 | モジュール 5 開始 | C2 と同じ（モジュール 4 は取り消し演習のため状態は変わらない） |
| C4 | モジュール 6 開始 | C2 ＋ V4（制作物セクション）と V5（配色変更）がマージ済み。`feature/works-section` は削除済み |
| C5 | モジュール 7 開始 | C4 ＋ V3（README 整備）、`origin` と接続済み、`docs/` の 2 ファイルあり |
| C6 | モジュール 8 開始 | C5 ＋ V7（alt 属性）が squash マージ済み、タグ `v1.0.0` あり |
| C7 | 総合演習 開始 | 何もない状態（受講者が最初からやり直す） |

---

## モジュール 3：ローカル操作の基本サイクル（C1 → C2）

| STEP | 単元 | 操作 | 確認点 |
|---|---|---|---|
| STEP-001 | U10 | `mkdir -p ~/portfolio && cd ~/portfolio` | — |
| STEP-002 | U10 | `git init` | `Initialized empty Git repository` の表示 |
| STEP-003 | U10 | `ls -a` で `.git` の存在を確認 | 既存ファイルは変更されていないこと |
| STEP-004 | U11 | RES-SITE V1 の 3 ファイルを作成 | 作業ツリーにファイルがある状態 |
| STEP-005 | U11 | `git status` | 3 ファイルが `Untracked files` に並ぶ |
| STEP-006 | U12 | `git add README.md` | — |
| STEP-007 | U12 | `git status` | `README.md` だけが `Changes to be committed` に移る |
| STEP-008 | U12 | `git add index.html css/style.css` | 3 ファイルすべてがステージされる |
| STEP-009 | U13 | `git commit -m "サイトの雛形を追加"` | **コミット 1** |
| STEP-010 | U13 | `git log --oneline` | コミットが 1 件、先頭 7 桁のハッシュ |
| STEP-011 | U13 | `git show --stat HEAD` | 記録者・日時・メッセージ・変更ファイル |
| STEP-012 | U14 | メッセージの良い例／悪い例を比較（操作なし・解説のみ） | — |
| STEP-013 | U15 | `index.html` を編集（RES-SITE V2 の `<img>` を追加） | — |
| STEP-014 | U15 | `git diff` | 作業ツリーとインデックスの差分 |
| STEP-015 | U15 | `git add index.html` → `git diff` | 何も表示されない（差分がインデックス側へ移った） |
| STEP-016 | U15 | `git diff --staged` | 次のコミットに入る内容 |
| STEP-017 | U15 | `images/profile.png` を追加 → `git add` → `git diff --staged` | `Binary files differ` の表示 |
| STEP-018 | U15 | `git commit -m "プロフィール画像を追加"` | **コミット 2** |
| STEP-019 | U16 | `README.md` に 2 種類の変更（目的の追記＋誤字修正）を同時に加える | — |
| STEP-020 | U16 | `git add -p README.md` で片方だけをステージ | diff のかたまり単位で選択できること |
| STEP-021 | U16 | `git commit -m "READMEにサイトの目的を追記"` | **コミット 3** |
| STEP-022 | U16 | 残りをコミット | **コミット 4** |
| STEP-023 | U16 | `git mv` / `git rm` の動作を確認（実行後は元に戻す） | Git 経由の移動・削除が記録されること |
| STEP-024 | U17 | RES-SITE V2 の `.gitignore` を作成 | — |
| STEP-025 | U17 | `mkdir tmp && echo dummy > tmp/work.log` → `git status` | `tmp/` が現れないこと |
| STEP-026 | U17 | `.gitignore` をコミット | **コミット 5**（※ C2 では 4 コミットに整えるため、STEP-024〜026 は STEP-009 の直後に行う構成でもよい。単元順は変えないこと） |
| STEP-027 | U17 | 追跡済みファイルを `.gitignore` に書いても無視されないことを実演 → `git rm --cached` | `.gitignore` の効力の範囲 |
| STEP-028 | U18 | `git status --ignored` / `git check-ignore -v tmp/work.log` | 無視の理由がどの行かを特定できる |
| STEP-029 | U18 | グローバル gitignore（`core.excludesfile`）を設定 | OS 由来のファイルは各自の環境で除外する |
| STEP-030 | U18 | `mv README.md Readme.md` → `git status` → 元に戻す | OS により結果が異なること |

> **コミット件数は実演をどこまで巻き戻したかで変わる。**
> 状態は必ず `git log --oneline` で各自に確認すること。
> 教材の図はあくまで例示である。`reset-to.sh` が作る状態が正典である。

---

## モジュール 4：履歴の閲覧と取り消し（C2 → C3）

| STEP | 単元 | 操作 | 確認点 |
|---|---|---|---|
| STEP-031 | U20 | `git log` / `git log --oneline` | 既定出力に含まれる情報 |
| STEP-032 | U20 | `git log --graph --decorate --stat -3` | 整形オプションの効果 |
| STEP-033 | U21 | `git log --author` / `--since` / `-- css/style.css` / `-S "--main-color"` | 目的のコミットを絞り込む |
| STEP-034 | U21 | `git show <hash>` / `git show <hash> --stat` | 特定コミットの内容 |
| STEP-035 | U21 | `git blame css/style.css` | 各行が最後に変更されたコミット |
| STEP-036 | U22 | `git log --oneline` の先頭に `HEAD -> main` が付くことを確認 | HEAD が指すもの |
| STEP-037 | U22 | `git show HEAD~1` / `git show HEAD~2` | 相対参照でハッシュを使わず指定 |
| STEP-038 | U23 | `index.html` を編集 → `git restore index.html` | 未コミットの変更が消える（**取り消せない**） |
| STEP-039 | U23 | 編集 → `git add` → `git restore --staged index.html` | ステージング解除。変更内容は残る |
| STEP-040 | U24 | 適当な変更をコミット → `git commit --amend` でメッセージを修正 | ハッシュが変わること |
| STEP-041 | U24 | `git reset --soft HEAD~1` → `git status` | コミットだけ取り消し、変更はステージに残る |
| STEP-042 | U24 | `git reset --mixed HEAD~1` / `git reset --hard HEAD~1` の違いを実演 | 3 モードの差 |
| STEP-043 | U24 | `git revert <hash>` → 打ち消しコミットができる → その後 `git reset --hard` で C3 に戻す | revert は履歴を書き換えない |

> **C3 の定義**：モジュール 4 の操作はすべて取り消し演習であり、
> 最終的に C2 と同じ 4 コミットの状態に戻す。
> 単元教材の末尾で演習の跡を片付けて C3 の状態に戻す。

---

## モジュール 5：ブランチとマージ（C3 → C4）

| STEP | 単元 | 操作 | 確認点 |
|---|---|---|---|
| STEP-044 | U26 | `git branch` で現在のブランチを確認 | ブランチは「コミットを指す付箋」 |
| STEP-045 | U27 | `git switch -c feature/works-section` | 作成と切り替えが一度に |
| STEP-046 | U27 | `git branch -v` / 命名規則の解説 | — |
| STEP-047 | U28 | 未コミットの変更を抱えたまま `git switch main` を試す | 警告または持ち越しの挙動 |
| STEP-048 | U28 | `git stash` → `git switch` → `git stash pop` | 一時退避 |
| STEP-049 | U28 | `git switch <hash>` で detached HEAD を体験 → `git switch -` で復帰 | 発生条件と復帰方法 |
| STEP-050 | U27 | `feature/works-section` で RES-SITE V4 の 3 変更を 3 コミットに分けて記録 | **コミット +3** |
| STEP-051 | U29 | `git switch main` → `git merge feature/works-section` を**一度試して fast-forward を確認 → `git reset --hard` で戻す** | fast-forward の条件 |
| STEP-052 | U30 | `git switch main` → RES-SITE V5 の変更を加えてコミット（「もう一人の開発者」役） | **コミット +1**。main と feature が分岐 |
| STEP-053 | U30 | `git switch feature/works-section` → `git merge main` | コンフリクト発生 |
| STEP-054 | U30 | `git status` / `git diff --name-only --diff-filter=U` | どのファイルが未解決か |
| STEP-055 | U31 | RES-SITE V6 のとおりにマーカーを解消 → `git add` → `git commit` | **マージコミット** |
| STEP-056 | U31 | `git merge --abort` を別途実演（解消前に戻せること） | 安全弁の存在 |
| STEP-057 | U31 | `git diff main feature/works-section` / `--stat` / `--name-only` | 2 時点の比較 |
| STEP-058 | U32 | `git switch main` → `git merge feature/works-section`（3-way ではなく fast-forward になる） | 統合の完了 |
| STEP-059 | U32 | rebase と squash は**実演のみ**（別ブランチを作って試し、`reset --hard` で戻す） | 履歴の形の違い |
| STEP-060 | U32 | `git branch -d feature/works-section` | マージ済みブランチの削除 |

> **モジュール 5 の注記**：STEP-052 は本来「もう一人の開発者」が行う作業である。
> リモートリポジトリが未習のため自分の手元で代用していることに注意。
> **C4 の状態**：`main` に V4・V5 の内容が統合済み、`feature/works-section` は削除済み。

---

## モジュール 6：リモートリポジトリと共同作業（C4 → C5）

| STEP | 単元 | 操作 | 確認点 |
|---|---|---|---|
| STEP-061 | U34 | GitHub のアカウント作成、リポジトリ `portfolio` を作成（README・.gitignore は生成しない） | 空で作る理由 |
| STEP-062 | U35 | 公開範囲（Public / Private）の選択と、置いてはいけないファイルの確認 | 判断基準 |
| STEP-063 | U35 | RES-SITE V3 のとおり `README.md` を整備してコミット | **コミット +1** |
| STEP-064 | U36 | `ssh-keygen -t ed25519` → 公開鍵を GitHub に登録 → `ssh -T git@github.com` | 認証の切り分け |
| STEP-065 | U36 | `git remote add origin git@github.com:<account>/portfolio.git` → `git remote -v` | `origin` は別名にすぎない |
| STEP-066 | U37 | HTTPS 形式と SSH 形式の違い、`git remote set-url` による切り替え | push で認証に失敗する典型例 |
| STEP-067 | U37 | `git push -u origin main` → `git branch -vv` | 追跡ブランチの設定 |
| STEP-068 | U37 | 別ディレクトリに `git clone`（もう一人の開発者役 `~/portfolio-suzuki`） | clone が一度に行うこと |
| STEP-069 | U37 | `~/portfolio-suzuki` で `git config user.name`（`--global` を付けない） | 設定の適用範囲 |
| STEP-070 | U38 | `~/portfolio-suzuki` で RES-SITE 補助ファイル `docs/CONTRIBUTING.md` を作成しコミット・push | **コミット +1** |
| STEP-071 | U38 | `~/portfolio` で `git log origin/main` を見る（まだ古い） | `origin/main` は記憶であること |
| STEP-072 | U38 | `git fetch origin` → `git log origin/main` | fetch は作業ツリーを変えない |
| STEP-073 | U39 | `git log --oneline main..origin/main` / `git diff --stat main origin/main` | 何が増えるか・何が変わるか |
| STEP-074 | U39 | `git merge origin/main`（fast-forward）または `git pull` | 取り込みの完了 |
| STEP-075 | U39 | `~/portfolio` で `docs/memo.md` を作成しコミット（pull せずに） → `git pull` | 分岐の警告が出る |
| STEP-076 | U39 | `git config pull.rebase false` → `git pull` | 既定動作を明示する |
| STEP-077 | U40 | fetch と pull の使い分けを整理（操作なし・解説のみ） | — |
| STEP-078 | U40 | もう一人の側で push → 自分の側で pull せずに push を試す | non-fast-forward による拒否 |
| STEP-079 | U40 | 一時ブランチを push → `git push origin --delete` → `git fetch --prune` | リモートブランチの掃除 |

---

## モジュール 7：チーム開発のワークフロー（C5 → C6）

| STEP | 単元 | 操作 | 確認点 |
|---|---|---|---|
| STEP-080 | U42 | `feature/alt-text` ブランチを作り push | PR には push 済みブランチが必要 |
| STEP-081 | U42 | GitHub 上で Pull Request を作成（タイトルと説明の書き方） | PR は Git の機能ではない |
| STEP-082 | U42 | Fork の画面を確認（操作は行わない・解説のみ） | clone との違い |
| STEP-083 | U43 | レビュー指摘を想定し、RES-SITE V7 のとおり `alt` 属性を追加してコミット・push | PR に自動反映される |
| STEP-084 | U43 | Squash and merge でマージ | 履歴が 1 コミットに圧縮される |
| STEP-085 | U43 | `git switch main` → `git pull` → `git branch -d` が失敗 → `git branch -D` | squash マージ後の落とし穴 |
| STEP-086 | U44 | ブランチ保護の設定画面を確認、ブランチ戦略と Issue 連携を解説 | 運用ルール |
| STEP-087 | U45 | コミットメッセージ規約、`git cherry-pick` の実演、コンフリクト予防の整理 | — |
| STEP-088 | U46 | `git tag -a v1.0.0 -m "初回リリース"` → `git push origin v1.0.0` | push はタグを送らない |
| STEP-089 | U46 | GitHub の Tags / Releases を確認 | — |

---

## モジュール 8：落とし穴と復旧（C6 → 終了）

| STEP | 単元 | 操作 | 確認点 |
|---|---|---|---|
| STEP-090 | U48 | push 前後で使える手段が変わることを整理（操作なし・解説のみ） | 履歴書き換えの境界 |
| STEP-091 | U48 | restore / amend / reset / revert の使い分け表を確認 | 判断基準 |
| STEP-092 | U49 | `--force` と `--force-with-lease` の違いを解説（**実行はさせない**） | 他人のコミットを消しうる |
| STEP-093 | U49 | 変更をコミット → `git reset --hard HEAD~1` で消す | コミットが履歴から消える |
| STEP-094 | U49 | `git reflog` → 該当行を特定 → `git reset --hard <hash>` で復旧 | 消えたのではなく見えないだけ |
| STEP-095 | U50 | RES-SITE 補助ファイル `config/api-key.txt` を作り、他の変更と一緒にコミットしてしまう | 事故の再現 |
| STEP-096 | U50 | `git reset --soft HEAD~1` → `git restore --staged config/api-key.txt` → `.gitignore` に追記 | 他の変更を失わずに除去 |
| STEP-097 | U50 | 巨大ファイル・バイナリの問題と Git LFS を解説（操作なし） | 一度入れると履歴から消えない |
| STEP-098 | U51 | 空ディレクトリが記録されないことを実演、`.gitkeep` の慣習 | — |
| STEP-099 | U51 | `git branch --merged` → 不要ブランチの削除、`git fetch --prune` | 後片付け |

> **STEP-095 の取扱注意**：`config/api-key.txt` の値は架空である。
> push してしまった場合、Git の操作では漏洩は取り消せない。
> 最優先は認証情報の失効・再発行である。
