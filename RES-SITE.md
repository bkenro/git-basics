# RES-SITE：題材サイトのファイル内容

モジュール 3〜8 および総合演習で共通して使うサンプルサイト
「山田太郎のポートフォリオ」の全ファイル内容を、版ごとに収録する。

Uxx という番号は、教材の単元 xx を表す。（例：U10 = 単元10）


## 版の一覧

| 版 | 呼称 | 初出 | 内容 |
|---|---|---|---|
| V1 | 雛形 | U10 | README / index.html / style.css の 3 ファイル |
| V2 | 除外設定と画像 | U17 | .gitignore と images/ を追加、index.html と README を更新 |
| V3 | README 整備 | U35 | README を公開に耐える内容へ拡充 |
| V4 | 制作物セクション | U27 | feature ブランチで index.html と style.css を拡張 |
| V5 | 配色変更 | U30 | もう一人の開発者が style.css の `--main-color` を変更 |
| V6 | コンフリクト解消後 | U31 | V4 と V5 を統合した style.css |
| V7 | レビュー指摘の反映 | U43 | index.html の `<img>` に alt 属性を追加 |

補助ファイル（`docs/`・`config/`）は末尾にまとめて掲載する。

---

## V1：雛形

### `README.md`

```markdown
# ポートフォリオサイト

自己紹介と制作物を掲載する静的な Web サイト。

TODO：目的

TODO：ローカルでの表示方法

TODO：動作環境

メモ：
```

### `index.html`

```html
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
```

### `css/style.css`

```css
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
```

---

## V2：除外設定と画像

### `.gitignore`（新規）

```gitignore
# OS が生成するファイル
.DS_Store
Thumbs.db

# ログファイル
*.log

# 一時作業ディレクトリ
tmp/
```

### `images/profile.png`（新規・バイナリ）

任意の画像で構わないが、**教材中では 40KB 程度の PNG とする**。
バイナリファイルが差分表示されないこと（`git diff` が `Binary files differ` と出すこと）を
U15 で示すために必要。

### `index.html`（`<header>` 内に `<img>` を追加）

```html
  <header>
    <img src="images/profile.png" width="120">
    <h1>山田太郎</h1>
    <p>エンジニアを目指して学習中です。</p>
  </header>
```

> **注意**：この時点では `alt` 属性を**あえて付けない**。V7 でレビュー指摘として修正する題材になる。

### `README.md`（1 段落を追記）

```markdown
# ポートフォリオサイト

自己紹介と制作物を掲載する静的 Web サイトです。

TODO：目的

TODO：ローカルでの表示方法

TODO：動作環境

メモ：
学習の記録と制作物を 1 か所にまとめ、いつでも見せられる状態にしておくことを目的とする。
```

---

## V3：README 整備

### `README.md`（全面差し替え）

```markdown
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
```

---

## V4：制作物セクション（`feature/works-section` ブランチ）

### `index.html`（`</body>` の直前に追加）

```html
  <section id="works">
    <h2>制作物</h2>
    <ul>
      <li><a href="https://example.com/app1">タスク管理アプリ</a></li>
      <li><a href="https://example.com/app2">天気予報ビューア</a></li>
    </ul>
  </section>
```

### `css/style.css`（2 箇所を変更）

`:root` に 1 行追加：

```css
:root {
  --main-color: #1e88e5;
  --accent-color: #ff6f00;   /* ← 追加 */
  --bg-color: #ffffff;
}
```

ファイル末尾に追加：

```css
#works h2 {
  border-left: 4px solid var(--accent-color);
  padding-left: 8px;
}
```

### `README.md`（末尾に追記）

```markdown
## ディレクトリ構成

    portfolio/
    ├── index.html      トップページ
    ├── css/style.css   スタイル
    └── images/         画像
```

---

## V5：配色変更（もう一人の開発者・`main` ブランチ）

### `css/style.css`（`--main-color` の値のみ変更）

```css
:root {
  --main-color: #334155;
  --bg-color: #ffffff;
}
```

> **設計上の要点**：V4 は `--main-color` の**直下の行**に `--accent-color` を追加し、
> V5 は `--main-color` の**その行自体**を変更する。行が隣接しているため Git は自動統合できず、
> 確実にコンフリクトが発生する。「同じファイルを触ったからではなく、
> 同じ・隣接する行を双方が変更したから起きる」という原則を示すための仕込みである。
> **この 2 つの変更内容を勝手に変えないこと。**

---

## V6：コンフリクト解消後

### コンフリクト発生時の `css/style.css`（マーカー付き）

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

| 区画 | 内容 |
|---|---|
| `<<<<<<< HEAD` 〜 `=======` | 今いるブランチ（`feature/works-section`）＝ 自分の変更 |
| `=======` 〜 `>>>>>>> main` | 取り込もうとしているブランチ（`main`）＝ もう一人の変更 |

### 解消後の `css/style.css`（両者の変更を活かす）

```css
:root {
  --main-color: #334155;
  --accent-color: #ff6f00;
  --bg-color: #ffffff;
}
```

> **正解は「両方を残す」。** 配色変更と新セクション用の色追加は目的が異なり両立する。
> `--ours` / `--theirs` による片側採用は、実務では機能の消失事故になる。

---

## V7：レビュー指摘の反映

### `index.html`（`<img>` に alt 属性を追加）

```html
    <img src="images/profile.png" width="120" alt="山田太郎のプロフィール写真">
```

---

## 補助ファイル

### `docs/CONTRIBUTING.md`（U38 で使用・もう一人の開発者が作成）

```markdown
# 貢献ガイド

変更は必ずブランチを切って行い、Pull Request でレビューを受けてください。
```

### `docs/memo.md`（U39 で使用・自分が作成）

```markdown
# 作業メモ

- 制作物セクションの追加中
```

### `config/api-key.txt`（U50 で使用・機密情報の混入事故の題材）

```
SECRET_TOKEN=abcdef123456
```

> **取扱注意**：これは**架空の値**である。実在の認証情報を教材に載せないこと。
> また、この題材を扱う単元では「Git の操作では漏洩は取り消せない。
> 最優先は認証情報の失効・再発行である」を必ず併記すること。
