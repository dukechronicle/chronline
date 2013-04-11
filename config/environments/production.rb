Chronline::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  config.action_controller.asset_host = "//#{Settings.content_cdn}"

  config.assets.initialize_on_precompile = true

  config.assets.precompile +=
    ['site.js', 'admin.js', 'mobile.js',
     'site.css', 'admin.css', 'mobile.css', 'print.css', 'ie.css',
     'galleria/themes/chronicle/galleria.chronicle.js',
     'galleria/themes/chronicle/galleria.chronicle.css']

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  config.logger = Le.new(Settings.logentries.token)

  # Use a different cache store in production
  config.cache_store = :redis_store, {
    url: Settings.redis.url,
    expires_in: 10.minutes,
    race_condition_ttl: 10.seconds
  }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5


  # TODO Remove Gmail for production!
  ActionMailer::Base.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true,
    domain: Settings.gmail.domain,
    user_name: Settings.gmail.username,
    password: Settings.gmail.password,
  }
end
