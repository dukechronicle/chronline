# TODO replace Configz with more robust configuration scheme and replace
# `has_key?` with something definite
config_file = File.join(Dir.pwd, 'config', 'settings', 'test.local.yml')
Configz = File.exists?(config_file) ? YAML.load_file(config_file) : {}

def base_configs
  # When using Spork, loading more in this block will cause your tests to run
  # faster. However, if you change any configuration or code from libraries
  # loaded here, you'll need to restart spork for it take effect.
  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)

  require 'rspec/rails'
  require 'rspec/autorun'
  require 'webmock/rspec'
  require 'database_cleaner'
  require 'capybara/rspec'
  require 'capybara/poltergeist'
  require 'sunspot/rails/spec_helper'
  Capybara.javascript_driver = :poltergeist

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  RSpec.configure do |config|

    config.mock_with :rspec

    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you'd prefer not to run each of your examples within a transaction,
    # remove the following line or assign false instead of true.
    config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"
    config.include FactoryGirl::Syntax::Methods

    # Formatting
    config.color = true
    config.formatter = Configz['rspec']['formatter'] if defined?(Configz['rspec']['formatter'])

    # Solr configuration
    # TODO fix for sporking
     config.before(:each) do
    if example.metadata[:solr] # it "...", solr: true do ... to have real SOLR
      SolrTestServer.start
      Sunspot.remove_all!
      Sunspot.commit
    else
      SolrTestServer.stub
    end
  end

  end
end

def forkable_configs
  if Configz.has_key? 'simplecov'
    require 'simplecov'
    SimpleCov.start 'rails'
  end
end

if Configz.has_key? 'spork'
  # Uncomment the following line to use spork with the debugger
  # require 'spork/ext/ruby-debug'
  require 'spork'

  Spork.prefork do
    base_configs
    RSpec.configure do |config|
      config.drb = true
    end
  end

  Spork.each_run do
    # This code will be run each time you run your specs.
    forkable_configs
    FactoryGirl.reload
  end
else
 base_configs
 forkable_configs
end
