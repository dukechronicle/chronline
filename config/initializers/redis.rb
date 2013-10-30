if Rails.env.test?
  $redis = MockRedis.new
else
  Resque.redis = $redis = Redis.new(url: Settings.redis.url, driver: :hiredis)

  # https://devcenter.heroku.com/articles/forked-pg-connections
  Resque.before_fork do
    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
  end

  Resque.after_fork do
    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
  end
end
