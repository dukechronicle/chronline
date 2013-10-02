require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Chronline
  class Application < Rails::Application
    # Load application settings into Settings global constant
    RailsConfig.load_and_set_settings(
      Rails.root.join("config", "settings.yml").to_s,
      Rails.root.join("config", "settings", "#{Rails.env}.yml").to_s,
      Rails.root.join("config", "environments", "#{Rails.env}.yml").to_s,

      Rails.root.join("config", "settings.local.yml").to_s,
      Rails.root.join("config", "settings", "#{Rails.env}.local.yml").to_s,
      Rails.root.join("config", "environments", "#{Rails.env}.local.yml").to_s
    )

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Don't connect to database on precompile
    # https://devcenter.heroku.com/articles/rails-asset-pipeline
    config.assets.initialize_on_precompile = false

    # Add Bower components to asset search path
    config.assets.paths <<
      File.join(Rails.root, 'vendor', 'assets', 'bower_components')

    # Action mailer configuration
    config.action_mailer.default_url_options = { host: Settings.domain }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true

    # Allow HTTP response access to all subdomains
    config.middleware.use Rack::Cors do
      allow do
        origins %r{https?://\w+\.#{Settings.domain}}
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    # Use routes to handle exceptions (https://coderwall.com/p/w3ghqq)
    config.exceptions_app = self.routes

    config.action_dispatch.tld_length = Settings.domain.count('.')
  end
end

# Load extensions
Dir[File.join(Rails.root, "lib", "extensions", "**", "*.rb")].each do |file|
  require file
end
