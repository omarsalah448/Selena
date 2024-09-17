source "https://rubygems.org"

gem "rails", "~> 7.2.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "jbuilder"
gem "bcrypt", "~> 3.1.7"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem 'jwt'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'shoulda-matchers'
  gem 'rswag'
  gem 'rswag-specs'
end

group :development do
  gem "web-console"
  gem 'rswag-api'
  gem 'rswag-ui'
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
