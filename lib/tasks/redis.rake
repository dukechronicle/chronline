namespace :redis do
    options = {
      config: "#{Rails.root}/config/redis.conf",
      daemonize: "no",
      pidfile: "#{Rails.root}/tmp/redis.pid",
      host: '127.0.0.1',
      port: 6379,
      timeout: 0,
      dbfilename: "#{Rails.root}/db/dump.rdb",
      dir: "#{Rails.root}",
      loglevel: 'notice',
      logfile: 'stdout'
    }
  desc "Create redis configuration file"
  task :config do
    puts "WARNING: redis-server executable could not be found
please ensure you have redis installed.
" if not find_command('redis-server')
    options.merge! Settings.redis.to_hash if defined?(Settings.redis)
    config = options[:config]
    File.open(config, 'w') do |f|
      %w{daemonize pidfile port timeout dbfilename dir loglevel logfile}.each do |opt|
        f.puts "#{opt} #{options[opt.to_sym]}"
      end
      f.puts "bind #{options[:host]}"
      f.puts "save 900 1
              save 300 10
              save 60 10000".gsub(/^\s+/,'')
    end
    puts "Created Redis configration at #{config}"
  end

  desc "Start the Redis server"
  task :run => [:config, :start]

  task :start do
    File.open "#{Rails.root}/log/redis.log", 'a'

    config = defined?(Settings.redis.config) ? Settings.redis.config : "#{Rails.root}/config/redis.conf"
    if !File.exists?(config)
      raise "Redis configuration file expected at '#{config}' but none was found! Aborting...
Run `rake redis:config` to create a redis configuration"
    end
    redis_server "#{Rails.root}/config/redis.conf"
  end

end

def redis_server(arguments)
  redis = find_command('redis-server') or
    raise "Redis server not found! Please install Redis."
  system("#{redis} #{arguments}")
end
