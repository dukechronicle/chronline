source 'https://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :production do
  gem 'le'
  gem 'pg'
  gem 'redis-rails'
  gem 'redis-store'
  gem 'thin'
end

group :development, :test do
  gem 'sqlite3', '1.3.5'
  gem 'rspec-rails', '2.11.0'
  gem 'rb-readline'
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
  gem 'meta_request', '0.2.1'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'
  gem 'asset_sync'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'active_attr'
gem 'aws-sdk'
gem 'bootstrap-will_paginate'
gem 'browser'
gem 'default_value_for'
gem 'devise', '2.1.2'  # https://github.com/scambra/devise_invitable/issues/265
gem 'devise_invitable'
gem 'friendly_id'
gem 'gibbon'
gem 'haml'
gem 'hiredis'
gem 'httparty'
gem 'jquery-rails'
gem 'json-schema'
gem 'paperclip'
gem 'rack-cors', :require => 'rack/cors'
gem 'rails_config'
gem 'rdiscount'
gem 'require_all'
gem 'redis'
gem 'simple_form'
gem 'subdomain-fu', :git => 'git://github.com/mbleigh/subdomain-fu.git'
gem 'sunspot_rails'
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

  platforms :mingw, :mswin do
    gem 'rb-fchange'
    gem 'rb-notifu'
    gem 'win32console'
  end

  platforms :ruby do
    gem 'rb-inotify',
      require: RbConfig::CONFIG['host_os'].include?('linux') && 'rb-inotify'
    gem 'libnotify',
      require: RbConfig::CONFIG['host_os'].include?('linux') && 'libnotify'
    gem 'rb-fsevent',
      require: RbConfig::CONFIG['host_os'].include?('darwin') && 'rb-fsevent'
  end

end

# Installed but manually required; equivalent of ":require => false"
group :install do
  gem 'spork'
  # Test Progress Bars
  gem 'nyan-cat-formatter'
  gem 'fuubar'
  gem 'fuubar-cucumber'
  gem 'simplecov'
  gem 'growl'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
