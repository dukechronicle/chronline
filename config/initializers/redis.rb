options = {
  driver: :hiredis
}
options.merge!(Settings.redis) if defined?(Settings.redis)
$redis = Redis.new(options)
