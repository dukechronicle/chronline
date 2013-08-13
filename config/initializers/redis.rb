if Rails.env.test?
  $redis = MockRedis.new
else
  Resque.redis = $redis = Redis.new(url: Settings.redis, driver: :hiredis)
end
