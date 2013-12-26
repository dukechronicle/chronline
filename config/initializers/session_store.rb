Chronline::Application.config.session_store :redis_store, redis_server: Settings.redis, domain: Settings.domain, expire_after: 3.days
