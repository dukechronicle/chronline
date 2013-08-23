if Rails.env.test?
  $redis = MockRedis.new
else
  options = { driver: :hiredis }
  options.merge!(Settings.redis)
  $redis = Redis.new(options)
  Resque.redis = $redis

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
