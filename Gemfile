source 'https://rubygems.org'
ruby '2.1.2'

gem 'rails', '3.2.19'

group :production do
  gem 'asset_sync'
  gem 'newrelic_rpm'
  gem 'rails_12factor'
  gem 'unicorn', '~> 4.8.3'
end

group :development, :test do
  gem 'dotenv-rails', '~> 0.9.0'
  gem 'rb-readline', '~> 0.5.0', require: false
  gem 'rspec-rails', '~> 2.14.0'
  gem 'sunspot_solr', '~> 2.1.0'
end

group :development do
  gem 'annotate', '~> 2.6.1'
  gem 'byebug', '~> 2.5.0'
  gem 'pry-byebug', '~> 1.2.1'
  gem 'pry-doc', '~> 0.5.1'
  gem 'pry-rails', '~> 0.3.2'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'bower-rails', '~> 0.6.1'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'compass-rails', '~> 1.0.3'
  gem 'sass-rails',   '~> 3.2.6'
  gem 'uglifier', '~> 2.1.2'
end

gem 'acts-as-taggable-on'
gem 'aws-sdk', '~> 1.31.3'
gem 'bootstrap-will_paginate'
gem 'browser'
gem 'default_value_for'
gem 'delayed_paperclip'
gem 'devise', '~> 2.2.4'
gem 'feedzirra', '~> 0.2.0.rc2'
gem 'ffaker', '~> 1.22.1'
gem 'fog', '~> 1.19.0'
gem 'foundation-rails'
gem 'foundation-icons-sass-rails'
gem 'friendly_id'
gem 'gibbon', '~> 1.0.4'
gem 'haml'
gem 'hiredis', '~> 0.4.5'
gem 'htmlentities'
gem 'httparty'
gem 'image_optim_bin'
gem 'jade', git: 'git://github.com/dukechronicle/jade.git'
gem 'jquery-rails'
gem 'json-schema', '~> 1.1.1'
gem 'nokogiri'
gem 'omniauth-facebook', '~> 1.6.0'
gem 'omniauth-google-oauth2', '~> 0.2.2'
gem 'paperclip'
gem 'paperclip-optimizer'
gem 'promise'
gem 'pg', '~> 0.17.1'
gem 'rack-cors', require: 'rack/cors'
gem 'rdiscount'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'redis', '~> 3.0.6'
gem 'redis-rails', '~> 3.2.4'
gem 'require_all'  # Used by old page implementation
gem 'resque', '~> 1.22.0'
gem 'rmagick'
gem 'ruby-oembed'
gem 'simple_form'
gem 'sitemap_generator'
gem 'slim'
gem 'subdomain-fu', git: 'git://github.com/mbleigh/subdomain-fu.git'
gem 'sunspot_rails', '~> 2.1.0'
gem 'tinymce-rails', '~> 4.0.2'
gem 'unf'
gem 'will_paginate'
gem 'dalli'
gem 'memcachier'

group :test do
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'mock_redis'
  gem 'shoulda-matchers'
  gem 'spork-rails'
  gem 'turnip'
  gem 'vcr'
  gem 'turn'
  gem 'webmock'
end
