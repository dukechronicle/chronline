class Sitevar
  REDIS_KEY = 'configuration'

  @@sitevars = ActiveSupport::HashWithIndifferentAccess.new
  attr_reader :name, :label, :description, :type
  private_class_method :new


  def initialize(var)
    attrs = @@sitevars[var]
    @name = var
    @label = attrs[:label] || @name.titlecase
    @description = attrs[:description]
    @type = attrs[:type]
  end

  def value
    local_cache(@name) do
      $redis.hget(REDIS_KEY, @name)
    end
  end

  def value=(val)
    $redis.hset(REDIS_KEY, @name, val)
    prop = "@#{@name}"
    if self.class.instance_variable_defined? prop
      self.class.remove_instance_variable(prop)
    end
  end

  def self.[](var)
    new(var)
  end

  def self.fetch
    values = $redis.hgetall(REDIS_KEY)
    @@sitevars.each do |var, _|
      instance_variable_set("@#{var}", values[var])
    end
  end

  def self.each(&proc)
    self.fetch
    @@sitevars.map { |var, attrs| self[var] }.each(&proc)
  end

  private
  def local_cache(var)
    prop = "@#{var}"
    unless self.class.instance_variable_defined? prop
      self.class.instance_variable_set(prop, yield)
    end
    self.class.instance_variable_get(prop)
  end

  def self.sitevar(var, label: nil, description: nil, type: :string)
    @@sitevars[var] = {
      label: label,
      description: description,
      type: type,
    }
  end

  def self.method_missing(method, value = nil)
    if method =~ /(.*)=$/
      var = $1
      if @@sitevars.include? var
        self[var].value = value
      else
        super
      end
    else
      var = method
      if @@sitevars.include? var
        self[var].value
      else
        super
      end
    end
  end

  sitevar :issuu, label: 'Issuu Embed', type: :text
end
