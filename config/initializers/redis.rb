if Rails.env.test?
  $redis = MockRedis.new
else
  options = { driver: :hiredis }
  options.merge!(Settings.redis)
  $redis = Redis.new(options)
  Resque.redis = $redis
end
