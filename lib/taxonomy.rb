class Taxonomy
  include Errors

  attr_reader :id, :taxonomy, :node, :archived

  @@taxonomies = {}


  def initialize(taxonomy, path = nil)
    if path.nil?
      path = []
    elsif path.is_a? String
      path = path.split('/')[1..-1] || []
    end

    if @@taxonomies.include? taxonomy
      @taxonomy = taxonomy
    else
      raise UnknownTaxonomyError.new(taxonomy)
    end

    find_taxonomy_node(@@taxonomies[@taxonomy], path)
  end

  ###
  # Comparision operators
  ###

  def ==(rhs)
    rhs.is_a? Taxonomy and @path == rhs.path
  end

  def <=(rhs)
    if not rhs.is_a? Taxonomy
      raise TypeError('compared with non Taxonomy object')
    end
    self.to_s.start_with?(rhs.to_s)
  end

  def <(rhs)
    self <= rhs && self != rhs
  end

  def >(rhs)
    rhs < self
  end

  def >=(rhs)
    rhs <= self
  end

  def [](i)
    @path[i]
  end

  def as_json(options = nil)
    path
  end

  def children(include_archived: false)
    @children.map do |child|
      node = self.class.new(@taxonomy, path << child)
      node if not node.archived or include_archived
    end.compact
  end

  def parent
    unless root?
      self.class.new(@taxonomy, path[0...-1])
    end
  end

  def parents
    parents = [self]
    until parents.last.root?
      parents.push(parents.last.parent)
    end
    parents.reverse.drop(1)
  end

  def root?
    @path.empty?
  end

  def path
    Array.new(@path)
  end

  def name
    @path.last
  end

  def to_a
    path
  end

  def to_param
    path
  end

  def to_s
    '/' + @path.map { |section| section.downcase + '/' }.join
  end

  def self.top_level(taxonomy)
    @@taxonomies[taxonomy]['children'].map do |section|
      self.new(taxonomy, [section['name']])
    end
  end

  def self.levels(taxonomy, include_archived: true)
    level = self.top_level(taxonomy)
    levels = []
    until level.empty?
      levels << level
      level = levels.last.map do |taxonomy|
        taxonomy.children(include_archived: include_archived)
      end.flatten
    end
    levels
  end

  def self.nodes(include_archived: false)
    @@taxonomies.map do |_taxonomy, tree|
      list_nodes(tree, include_archived: include_archived)
    end.flatten
  end

  def self.set_taxonomy_tree(taxonomy, tree)
    @@taxonomies[taxonomy] = { 'children' => tree }
  end

  private
  def find_taxonomy_node(root, path)
    @path = []
    path.each do |section|
      root = (root['children'] || []).find do |child|
        child['new_id'].nil? && child['name'].downcase == section.downcase
      end
      raise InvalidTaxonomyError.new(@taxonomy, path) if root.nil?
      @path << root['name']
    end

    @node = root
    @id = root['id']
    @archived = root['archived']
    @children = (root['children'] || [])
      .select { |child| child['new_id'].nil? }  # Taxonomy term has been renamed
      .map { |child| child['name'] }
  end

  def self.list_nodes(root, include_archived: false)
    return [] if root['children'].nil?
    root['children'].map do |child|
      child_node =  {
        id: child['id'],
        name: child['name'],
        taxonomy: 'sections',
        parent_id: root['id'],
      }
      child_node[:new_id] = child['new_id'] unless child['new_id'].nil?
      if not child['archived'] or include_archived
        list_nodes(
          child, include_archived: include_archived).insert(0, child_node)
      end
    end.compact.flatten
  end
end

# Configuration is wiped when reloaded
load Rails.root.join('config', 'initializers', 'taxonomy.rb') if Rails.env.development?
