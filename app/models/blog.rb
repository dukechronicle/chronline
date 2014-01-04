class Blog
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # Blog class is not publicly instantiable
  private_class_method :new

  attr_reader :description, :name, :section_id, :twitter_widgets

  def initialize(attrs = {})
    @name = attrs[:name]
    @description = attrs[:description]
    @section_id = attrs[:id]
    @twitter_widgets = attrs[:twitter_widgets] || []
  end

  def ==(rhs)
    rhs.is_a?(self.class) && id == rhs.id
  end

  def id
    name.downcase.gsub(/\s/, '')
  end

  # Required to comply with ActiveModel interface
  def persisted?
    true
  end

  def posts
    Blog::Post.section(taxonomy)
  end

  def taxonomy
    Taxonomy.new(:blogs, [name])
  end

  def to_param
    id
  end

  def self.find(id)
    if id.is_a? Array
      ids = id
      ids.map { |id| find_by_id(id) }.compact
    else
      blog = find_by_id(id)
      # TODO: not an ActiveRecord error?
      raise ActiveRecord::RecordNotFound.new if blog.nil?
      blog
    end
  end

  def self.all
    Taxonomy.top_level(:blogs).map do |taxonomy|
      new(taxonomy.node.symbolize_keys)
    end
  end

  def self.each(&block)
    self.all.each(&block)
  end

  def self.find_by_taxonomy(taxonomy)
    self.all.find { |blog| taxonomy <= blog.taxonomy }
  end

  def self.find_by_id(id)
    self.all.find { |blog| id == blog.id }
  end
end
