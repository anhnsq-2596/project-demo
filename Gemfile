source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.0"

gem "bcrypt", "~> 3.1.16"
gem "factory_bot_rails"
gem "kaminari"
gem "kaminari-mongoid"
gem "bootstrap4-kaminari-views"
gem "mongoid", "~> 7.3.1"
gem "rails", "~> 6.1.4"
gem "rails-i18n", "~> 6.0.0"
gem "puma", "~> 5.0"
gem "sass-rails", ">= 6"
gem "webpacker", "~> 5.0"
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.7"
gem "bootsnap", ">= 1.4.4", require: false

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails", "~> 5.0.0"
  gem "rubocop", "~> 1.18", require: false
  gem "rubocop-rails"
  gem "rubocop-rspec"
end

group :development do
  gem "web-console", ">= 4.1.0"
  gem "rack-mini-profiler", "~> 2.0"
  gem "listen", "~> 3.3"
  gem "spring"
end

group :test do
  gem "shoulda-matchers", "~> 5.0"
  gem "rails-controller-testing"
  gem "database_cleaner-mongoid"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
