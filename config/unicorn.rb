worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 30
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
  $redis.quit
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)

  # HAX: Reset all redis connections
  ObjectSpace.each_object(ActionDispatch::Session::RedisStore) do |store|
    store.pool.reconnect
  end
  #Rails.cache.reconnect
  Resque.redis = Sitevar.config.redis = $redis =
    Redis.new(url: ENV['REDIS_URL'], driver: :hiredis)
end
