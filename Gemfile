source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.3"

gem "bootsnap", require: false

gem "discard", "~> 1.2"

gem "erb_lint", require: false

gem "inline_svg"

gem "gretel"

gem "meta-tags"
gem "mjml-rails"

gem "pagy"
gem "pg"
gem "propshaft"
gem "puma"

# attractor uses Sinatra for web interface, which requires rack < 3.0 as of 2023-12-05
gem "rack", "~> 2.2"
gem "bcrypt"
gem "rodauth-rails"
gem "rodauth-omniauth"

gem "rails", "~> 7.0.8"
gem "redis", "~> 5.0"

gem "strong_migrations"

gem "turbo-rails"

gem "view_component"
gem "vite_rails"

group :development, :test do
  gem "erb_lint", require: false

  gem "factory_bot_rails"
  gem "ffaker"

  gem "letter_opener"

  gem "pry"
  gem "pry-byebug"

  gem "rubocop-rails-omakase", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-faker", require: false
  gem "rubocop-md", require: false
end

group :development do
  gem "annotate"
  gem "attractor"
  gem "attractor-ruby"

  gem "brakeman"
  gem "bundler-audit", require: false


  gem "web-console"
  gem "lookbook"
end

group :test do
  gem "simplecov", require: false
end
