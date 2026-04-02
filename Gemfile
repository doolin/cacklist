source 'https://rubygems.org'

ruby '3.2.6'

gem 'rails', '~> 7.1.0'

gem 'bcrypt', '~> 3.1'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.0'
gem 'sprockets-rails'
gem 'will_paginate', '~> 4.0'

group :development, :test do
  gem 'debug'
  gem 'factory_bot_rails', '~> 6.0'
  gem 'faker', '~> 3.0'
  gem 'rspec-rails', '~> 6.0'
end

group :development do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'rubocop', '~> 1.0', require: false
  gem 'rubocop-rails', require: false
  gem 'web-console'
end

group :test do
  gem 'capybara', '~> 3.0'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
end
