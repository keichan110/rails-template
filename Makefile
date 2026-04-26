.DEFAULT_GOAL := help
DOCKER_RUN := docker-compose run --rm app

.PHONY: help build rails-new setup up down console migrate rollback routes test lint format logs shell

help: ## コマンド一覧を表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Dockerイメージをビルド
	docker-compose build

rails-new: build ## Railsアプリを生成 (初回セットアップ)
	$(DOCKER_RUN) rails new . \
		--database=postgresql \
		--asset-pipeline=propshaft \
		--javascript=importmap \
		--template=template.rb \
		--force
	docker-compose build

setup: rails-new migrate ## rails-new + migrate を実行

up: ## Railsサーバーを起動
	docker-compose up

down: ## コンテナを停止
	docker-compose down

console: ## Railsコンソールを起動
	$(DOCKER_RUN) bin/rails console

migrate: ## DBマイグレーションを実行
	$(DOCKER_RUN) bin/rails db:migrate

rollback: ## マイグレーションをロールバック
	$(DOCKER_RUN) bin/rails db:rollback

routes: ## ルーティング一覧を表示
	$(DOCKER_RUN) bin/rails routes

test: ## テストを実行
	$(DOCKER_RUN) bundle exec rspec

lint: ## RuboCopでコードをチェック
	$(DOCKER_RUN) bundle exec rubocop

format: ## RuboCopで自動修正
	$(DOCKER_RUN) bundle exec rubocop -a

logs: ## ログを表示
	docker-compose logs -f

shell: ## コンテナ内のシェルを起動
	$(DOCKER_RUN) bash

bundle: ## bundle installを実行
	$(DOCKER_RUN) bundle install

generate: ## rails generate を実行 (例: make generate ARGS="model User name:string")
	$(DOCKER_RUN) bin/rails generate $(ARGS)

db-create: ## DBを作成
	$(DOCKER_RUN) bin/rails db:create

db-reset: ## DBをリセット
	$(DOCKER_RUN) bin/rails db:reset

db-schema: ## schemaを表示
	$(DOCKER_RUN) bin/rails db:schema:dump
	cat db/schema.rb
