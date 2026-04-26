# Rails Template

RailsアプリケーションをDockerで爆速開発するためのテンプレートです。
このリポジトリをフォークして、新しいRailsプロジェクトを即座に開始できます。

## このリポジトリについて

`rails new` を実行する直前の状態を維持しており、フォークするだけでDockerベースのRails開発環境が手に入ります。

## テックスタック

| 項目 | バージョン |
|------|-----------|
| Ruby | 4.0 系最新 |
| Rails | 8.1 系最新 |
| PostgreSQL | 18 系最新 |
| Docker | 最新安定版 |

### バージョンについて

`Dockerfile` の `ruby:4.0`、`docker-compose.yml` の `postgres:18` は各シリーズの最新パッチを指すタグです。
フォーク時点の最新が自動的に使われますが、**本番運用するプロジェクトではパッチバージョンを固定することを推奨します**。

```dockerfile
# Dockerfile — フォーク先で固定する場合
ARG RUBY_VERSION=4.0.3   # 例: 4.0.3 に固定
```

```yaml
# docker-compose.yml — フォーク先で固定する場合
image: postgres:18.3      # 例: 18.3 に固定
```

最新イメージを明示的に取得するには `docker-compose build --pull` を実行してください。

## 前提条件

- Docker
- Docker Compose

## セットアップ

### 1. リポジトリをフォーク・クローン

```bash
git clone https://github.com/<your-username>/rails-template.git my-app
cd my-app
```

### 2. Railsアプリを生成

```bash
make rails-new
```

このコマンドで以下が実行されます:
- Dockerイメージのビルド（Ruby 4.0 系最新）
- `rails new .` の実行
- Gemfileが更新された後に再ビルド

### 3. 開発サーバーを起動

```bash
make up
```

http://localhost:3000 にアクセスして確認してください。

## コマンド一覧

```bash
make help        # コマンド一覧を表示
make build       # Dockerイメージをビルド
make rails-new   # Railsアプリを生成（初回のみ）
make setup       # rails-new + migrate を一括実行
make up          # 開発サーバーを起動
make down        # コンテナを停止
make console     # Railsコンソールを起動
make migrate     # DBマイグレーションを実行
make rollback    # マイグレーションをロールバック
make routes      # ルーティング一覧を表示
make test        # テストを実行
make logs        # ログを表示
make shell       # コンテナ内シェルを起動
make bundle      # bundle install を実行
make generate ARGS="model User name:string"  # rails generate
make db-create   # DBを作成
make db-reset    # DBをリセット
```

## ディレクトリ構成

```
rails-template/
├── docker/
│   └── entrypoint.sh      # コンテナ起動スクリプト
├── docker-compose.yml
├── Dockerfile
├── Gemfile                # rails new 実行後に上書きされます
├── Makefile
└── README.md
```

## ライセンス

MIT
