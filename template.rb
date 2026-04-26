gem_group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

gem_group :development do
  gem "rubocop-rails-omakase", require: false
end

after_bundle do
  generate "rspec:install"

  # FactoryBotのヘルパーをRSpecに組み込む
  inject_into_file "spec/rails_helper.rb", after: "RSpec.configure do |config|\n" do
    <<~RUBY
      config.include FactoryBot::Syntax::Methods

    RUBY
  end

  # factoriesディレクトリを作成
  empty_directory "spec/factories"

  # .rubocop.ymlを生成
  create_file ".rubocop.yml", <<~YAML
    inherit_gem:
      rubocop-rails-omakase: rubocop.yml
  YAML
end
