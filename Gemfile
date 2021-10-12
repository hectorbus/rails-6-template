source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.5'
#ruby-gemset=template_six

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.1'
# Use pg as the database for Active Record
gem 'pg', '~> 1.1.4'
# Use Puma as the app server
gem 'puma', '~> 4.3.9'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Flexible authentication solution for Rails with Warden
gem 'devise', '~> 4.0'
# Simple Rails app configuration.
gem 'figaro', '~> 1.1.1'
# Provides the generator settings required for Rails to use Slim
gem 'slim-rails', '~> 3.2', '>= 3.2.0'
# Search Engine Optimization (SEO) plugin for Ruby on Rails applications.
gem 'meta-tags', '~> 2.13.0'
# i18n-js to use internationalization in javascript
gem 'i18n-js', '~> 3.5.0'
# A simple Ruby on Rails plugin for creating and managing a breadcrumb navigation.
gem 'breadcrumbs_on_rails', '~> 3.0.1'
# Use will paginate
gem 'will_paginate', '~> 3.1.0'
# ClientSideValidations for Ruby on Rails
gem 'client_side_validations', '~> 16.0.3'
# Use to upload files
gem 'carrierwave', '~> 2.0'
# Audited logs all changes to your models.
gem 'audited', '~> 4.8'
# Seedbank to structure your apps seed data instead of having it all dumped into one large file.
gem 'seedbank', '~> 0.5.0'
# Object oriented authorization for Rails applications.
gem 'pundit', '~> 2.1.0'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Database cleaner to ensure a clean state for testing
  gem "database_cleaner", '~> 1.7.0'

  # Rspec rails testing framework
  gem "rspec-rails", '~> 3.7.2'

  # Factory bot rails to create objects in database
  gem 'factory_bot_rails', '~> 4.10.0'

  # Shoulda Matchers to test common Rails functionality
  gem 'shoulda-matchers', '~> 3.1'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Provides a better error page for Rails
  gem 'better_errors', '~> 2.4.0'
  gem 'binding_of_caller', '~> 0.8.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'annotate', '3.0.3'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.30.0'

  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers', '~> 4.0'

  # Capybara email to test the ActionMailer and Mailer messages with Capybara
  gem 'capybara-email', '~> 3.0.1'

  # Selenium webdriver is a tool for writing automated tests, it aims to mimic the behaviour of a real user
  # gem "selenium-webdriver", '~> 3.12.0'

  # Easy installation and use of chromedriver to run system tests with Chrome
  # gem 'chromedriver-helper', '1.2.0'

  # Simplecov for code coverage with a powerful configuration library and automatic merging of coverage across test suites
  gem 'simplecov', '~> 0.16.1', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Use Ransack
gem 'ransack', '~> 2.3.0'
