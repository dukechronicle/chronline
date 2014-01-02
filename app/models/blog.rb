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

  # Required to comply with ActiveModel interface
  def persisted?
    true
  end

  def posts
    Blog::Post.section(taxonomy)
  end

  def id
    name.downcase.gsub(/\s/, '')
  end

  def to_param
    id
  end

  def taxonomy
    Taxonomy.new(:blogs, [name])
  end

  def self.find(id)
    if id.is_a? Array
      ids = id
      ids.map { |id| @all[id] }.compact
    else
      # TODO: not an ActiveRecord error?
      raise ActiveRecord::RecordNotFound.new unless @all.include?(id)
      @all[id]
    end
  end

  def self.all
    @all.values
  end

  def self.each(&block)
    self.all.each(&block)
  end

  def self.find_by_taxonomy(taxonomy)
    self.all.find { |blog| taxonomy <= blog.taxonomy }
  end

  def self.load_blog_data(blogs)
    @all = blogs.reduce({}) do |all, data|
      blog = new(data.symbolize_keys)
      all[blog.id] = blog
      all
    end
  end

  load_blog_data(YAML.load_file(Rails.root.join('config', 'blogs.yml')))
end
