# Be sure to restart your server when you modify this file.

if Rails.env.production?
  Chronline::Application.config.session_store :redis_store, redis_server: Settings.redis.url, domain: Settings.domain, expire_after: 3.days
else
  Chronline::Application.config.session_store :cookie_store, key: '_chronline_session', domain: Settings.domain
end

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Chronline::Application.config.session_store :active_record_store
