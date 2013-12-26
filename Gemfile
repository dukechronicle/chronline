source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '3.2.16'

group :production do
  gem 'newrelic_rpm'
  gem 'asset_sync'
  gem 'unicorn'
end

group :development, :test do
  gem 'dotenv-rails', '~> 0.9.0'
  gem 'ffaker', '~> 1.22.1'
  gem 'rb-readline', '~> 0.5.0', require: false
  gem 'rspec-rails', '~> 2.14.0'
  gem 'sunspot_solr', '~> 2.1.0'
end

group :development do
  gem 'annotate'
  gem 'pry-rails'
  gem 'pry-doc'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.6'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'compass-rails', '~> 1.0.3'
  gem 'uglifier', '~> 2.1.2'
  gem 'bower-rails', git: 'git://github.com/jimpo/bower-rails.git'
end

gem 'acts-as-taggable-on'
gem 'aws-sdk'
gem 'bootstrap-will_paginate'
gem 'browser'
gem 'default_value_for'
gem 'delayed_paperclip'
gem 'devise', '~> 2.2.4'
gem 'devise_invitable'
gem 'feedzirra', '~> 0.2.0.rc2'
gem 'fog'
gem 'friendly_id'
gem 'gibbon', '~> 1.0.0'
gem 'haml'
gem 'hiredis', '~> 0.4.5'
gem 'htmlentities'
gem 'httparty'
gem 'image_optim_bin'
gem 'jquery-rails'
gem 'json-schema', '~> 1.1.1'
gem 'nokogiri'
gem 'paperclip'
gem 'paperclip-optimizer'
gem 'promise'
gem 'pg', '~> 0.17.1'
gem 'rack-cors', require: 'rack/cors'
gem 'rails_config'
gem 'rdiscount'
gem 'redis', '~> 3.0.6'
gem 'redis-rails', '~> 3.2.4'
gem 'require_all'  # Used by old page implementation
gem 'resque', '~> 1.22.0'
gem 'rmagick'
gem 'ruby-oembed'
gem 'simple_form'
gem 'sitemap_generator'
gem 'subdomain-fu', git: 'git://github.com/mbleigh/subdomain-fu.git'
gem 'sunspot_rails', '~> 2.1.0'
gem 'tinymce-rails', '~> 4.0.2'
gem 'will_paginate'

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
  gem 'webmock'
end
