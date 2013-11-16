class Sitevar
  attr_reader :name, :label, :description, :type
  private_class_method :new


  def initialize(var, attrs)
    @name = var.to_s
    @label = attrs[:label] || @name.titlecase
    @description = attrs[:description]
    @type = attrs[:type]
  end

  def value
    @@config.redis.hget(@@config.key, @name)
  end

  def value=(val)
    @@config.redis.hset(@@config.key, @name, val)
  end

  def self.[](var)
    attrs = @@config.sitevars[var]
    new(var, attrs) unless attrs.nil?
  end

  def self.each(&proc)
    @@config.sitevars.map { |var, attrs| self[var] }.each(&proc)
  end

  def self.config
    @@config ||= Sitevar::Configuration.new
  end

  private
  def self.method_missing(method, value = nil)
    if method =~ /(.*)=$/
      var = $1
      if @@config.sitevars.include? var
        self[var].value = value
      else
        super
      end
    else
      var = method
      if @@config.sitevars.include? var
        self[var].value
      else
        super
      end
    end
  end

  class Configuration
    DEFAULT_KEY = 'configuration'

    attr_accessor :key, :redis, :sitevars

    def initialize
      self.key = DEFAULT_KEY
      self.sitevars = {}
    end

    def sitevars=(sitevars)
      @sitevars = HashWithIndifferentAccess.new(sitevars)
    end
  end
end
