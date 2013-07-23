if Rails.env.test?
  $redis = MockRedis.new
else
  $redis = Redis.new(url: Settings.redis, driver: :hiredis)
end
