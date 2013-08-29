class Blog
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # Must initialize Blog::Data here so that it is present on reload
  File.open(Rails.root.join('config', 'blogs.yml')) do |file|
    Blog::Data = YAML.load(file)
  end

  # Blog class is not publicly instantiable
  private_class_method :new

  attr_accessor :id, :name, :logo, :banner, :description, :section_id,
    :twitter_widgets

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
    Blog::Post.where(section: "/blog/#{id}/")
  end

  def to_param
    id
  end

  def twitter_widgets
    @twitter_widgets ||= []
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
    self.find(Blog::Data.keys)
  end

  def self.each(&block)
    self.all.each(&block)
  end

  def self.nodes
    blog_root = {
      id: 1000,
      name: 'Blog',
      taxonomy: 'sections',
      parent_id: nil,
    }
    nodes = self.all.map do |blog|
      {
        id: blog.section_id,
        name: blog.id.titlecase,
        taxonomy: 'sections',
        parent_id: blog_root[:id],
      }
    end
    nodes.insert(0, blog_root)
    nodes
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
