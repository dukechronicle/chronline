class Blog
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # Must initialize Blog::Data here so that it is present on reload
  File.open(File.join(Rails.root, "config", "blogs.yml")) do |file|
    Blog::Data = YAML.load(file)
  end

  # Blog class is not publicly instantiable
  private_class_method :new

  attr_accessor :id, :name, :logo, :banner, :description, :twitter_widget


  def initialize(attributes={})
    attributes.each do |attr, value|
      send("#{attr}=", value)
    end
  end

  # Required to comply with ActiveModel interface
  def persisted?
    true
  end

  def posts
    Blog::Post.where(blog: id)
  end

  def to_param
    id
  end

  def ==(other)
    other.is_a? Blog and self.id == other.id
  end

  def self.find(id)
    if id.is_a? Array
      ids = id
      ids.map { |id| lookup(id) }.compact
    else
      blog = lookup(id)
      # TODO: not an ActiveRecord error?
      raise ActiveRecord::RecordNotFound.new if blog.nil?
      blog
    end
  end

  def self.all
    Blog::Data.map {|key, _| self.find(key)}
  end

  def self.each(&block)
    self.all.each(&block)
  end

  private
  def self.lookup(id)
    if Blog::Data[id]
      attributes = Hash[Blog::Data[id]]
      attributes['id'] = id
      self.send(:new, attributes)
    end
  end

end
