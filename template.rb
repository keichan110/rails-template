gem_group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

gem_group :development do
  gem "rubocop-rails-omakase", require: false
  gem "bullet"
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

  # Bulletの設定をdevelopment.rbに追加
  environment nil, env: "development" do
    <<~RUBY
      config.after_initialize do
        Bullet.enable = true
        Bullet.rails_logger = true
      end
    RUBY
  end

  # Bulletの設定をtest.rbに追加
  environment nil, env: "test" do
    <<~RUBY
      config.after_initialize do
        Bullet.enable = true
        Bullet.raise = true
      end
    RUBY
  end

  # BulletのフックをRSpecに組み込む
  inject_into_file "spec/rails_helper.rb", after: "RSpec.configure do |config|\n" do
    <<~RUBY
      if Bullet.enable?
        config.before(:each) { Bullet.start_request }
        config.after(:each) do
          Bullet.perform_out_of_channel_notifications if Bullet.notification?
          Bullet.end_request
        end
      end

    RUBY
  end
end
