# TODO: find a better way to make a global variable
$redis = Redis.new(url: Settings.redis_url, driver: :hiredis)
