Chronline::Application.config.session_store :redis_store, redis_server: ENV['REDIS_URL'], domain: ENV['DOMAIN'], expire_after: 3.days
