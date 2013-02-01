# TODO replace Configz with more robust configuration scheme and replace
# `has_key?` with something definite
config_file = File.join(Dir.pwd, 'config', 'settings', 'test.local.yml')
Configz = File.exists?(config_file) ? YAML.load_file(config_file) : {}

def base_configs
  # When using Spork, loading more in this block will cause your tests to run
  # faster. However, if you change any configuration or code from libraries
  # loaded here, you'll need to restart spork for it take effect.
  require 'cucumber/rails'
  require 'capybara/poltergeist'
  require 'rspec/rails'
  require 'webmock/cucumber'

  # Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
  # order to ease the transition to Capybara we set the default here. If you'd
  # prefer to use XPath just remove this line and adjust any selectors in your
  # steps to use the XPath syntax.
  Capybara.default_selector = :css
  Capybara.default_driver = :poltergeist

  # By default, any exception happening in your Rails application will bubble up
  # to Cucumber so that your scenario will fail. This is a different from how
  # your application behaves in the production environment, where an error page will
  # be rendered instead.
  #
  # Sometimes we want to override this default behaviour and allow Rails to rescue
  # exceptions and display an error page (just like when the app is running in production).
  # Typical scenarios where you want to do this is when you test your error pages.
  # There are two ways to allow Rails to rescue exceptions:
  #
  # 1) Tag your scenario (or feature) with @allow-rescue
  #
  # 2) Set the value below to true. Beware that doing this globally is not
  # recommended as it will mask a lot of errors for you!
  #
  ActionController::Base.allow_rescue = false

  DatabaseCleaner.strategy = :truncation

  # You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
  # See the DatabaseCleaner documentation for details. Example:
  #
  #   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
  #     # { :except => [:widgets] } may not do what you expect here
  #     # as tCucumber::Rails::Database.javascript_strategy overrides
  #     # this setting.
  #     DatabaseCleaner.strategy = :truncation
  #   end
  #
  #   Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
  #     DatabaseCleaner.strategy = :transaction
  #   end
  #

  # Possible values are :truncation and :transaction
  # The :transaction strategy is faster, but might give you threading problems.
  # See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
  Cucumber::Rails::Database.javascript_strategy = :truncation

  WebMock.disable_net_connect!(allow_localhost: true)

  # Uncomment the following to use VCR to record network requests

  # VCR.configure do |c|
  #   c.cassette_library_dir = 'vcr_cassettes'
  #   c.hook_into :webmock
  #   c.ignore_localhost = true
  #   c.default_cassette_options = {record: :all}
  #   c.allow_http_connections_when_no_cassette = true
  # end

  # VCR.cucumber_tags {|t| t.tag '@vcr'}

  SolrTestServer.stub

  Before("@solr") do
    SolrTestServer.start
    Sunspot.remove_all!
    Sunspot.commit
  end

  AfterStep('@solr') do
    Sunspot.commit
    Sunspot.unstub
  end

end
def forkable_configs
end

if Configz.has_key? 'spork'
  require 'spork'
  # Uncomment the following line to use spork with the debugger
  # require 'spork/ext/ruby-debug'
  Spork.prefork do
    base_configs
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
