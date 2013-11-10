class Sitevars
  REDIS_KEY = 'configuration'

  @@sitevars = %w(issuu)

  def self.fetch
    values = $redis.hgetall(REDIS_KEY)
    @@sitevars.each do |var|
      instance_variable_set("@#{var}", values[var])
    end
  end

  def self.each
    self.fetch
    @@sitevars.each do |var|
      yield var, self.send(var)
    end
  end

  private
  def self.local_cache(var)
    prop = "@#{var}"
    unless instance_variable_defined? prop
      instance_variable_set(prop, yield)
    end
    instance_variable_get(prop)
  end

  class << self
    @@sitevars.each do |var|
      define_method(var) do
        local_cache(var) do
          $redis.hget(REDIS_KEY, var)
        end
      end

      define_method("#{var}=") do |val|
        $redis.hset(REDIS_KEY, var, val)
        remove_instance_variable("@#{var}")
      end
    end
  end
end
