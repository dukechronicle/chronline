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
    $redis.hget(REDIS_KEY, @name)
  end

  def value=(val)
    $redis.hset(REDIS_KEY, @name, val)
  end

  def self.[](var)
    new(var)
  end

  def self.each(&proc)
    @@sitevars.map { |var, attrs| self[var] }.each(&proc)
  end

  private
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
