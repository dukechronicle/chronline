source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '3.2.14'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :production do
  gem 'le'
  gem 'pg'
  gem 'redis-rails'
  gem 'newrelic_rpm'
  gem 'asset_sync'
  gem 'unicorn'
end

group :development, :test do
  gem 'sqlite3', '~> 1.3.7'
  gem 'rspec-rails', '~> 2.14.0'
  gem 'rb-readline', '~> 0.4.2'
  gem 'ffaker'
  gem 'sunspot_solr'
  gem 'guard-rspec'
end

group :development do
  gem 'annotate'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'progress_bar'
  gem 'guard-spork'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.6'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'compass-rails', '~> 1.0.3'
  gem 'uglifier', '~> 2.1.2'
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
gem 'hiredis'
gem 'htmlentities'
gem 'httparty'
gem 'image_optim_bin'
gem 'jquery-rails'
gem 'json-schema', '~> 1.1.1'
gem 'nokogiri'
gem 'paperclip'
gem 'paperclip-optimizer'
gem 'promise'
gem 'rack-cors', :require => 'rack/cors'
gem 'rails_config'
gem 'rdiscount'
gem 'redis'
gem 'require_all'  # Used by old page implementation
gem 'resque', '~> 1.22.0'
gem 'rmagick'
gem 'ruby-oembed'
gem 'simple_form'
gem 'sitemap_generator'
gem 'subdomain-fu', :git => 'git://github.com/mbleigh/subdomain-fu.git'
gem 'sunspot_rails', '~> 2.0.0'
gem 'tinymce-rails', '~> 4.0.2'
gem 'will_paginate'

group :test do
  gem 'capybara'
  gem 'poltergeist'
  gem 'cucumber-rails', :require => false
  gem 'cucumber-websteps'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'guard-cucumber'
  gem 'guard-spork'
  gem 'shoulda-matchers'
  gem 'webmock'
  gem 'vcr'
  gem 'mock_redis'
end
