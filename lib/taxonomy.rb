require 'taxonomy/errors'

class Taxonomy
  include Errors

  attr_reader :id, :taxonomy

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

  def children
    @children.map { |child| self.class.new(@taxonomy, path << child) }
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

  def self.levels(taxonomy)
    level = self.top_level(taxonomy)
    levels = []
    until level.empty?
      levels << level
      level = levels.last.map {|taxonomy| taxonomy.children}.flatten
    end
    levels
  end

  def self.nodes
    @@taxonomies.map do |_taxonomy, tree|
      list_nodes(tree)
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

    @id = root['id']
    @children = (root['children'] || [])
      .select { |child| child['new_id'].nil? }  # Taxonomy term has been renamed
      .map { |child| child['name'] }
  end

  def self.list_nodes(root)
    return [] if root['children'].nil?
    root['children'].map do |child|
      child_node =  {
        id: child['id'],
        name: child['name'],
        taxonomy: 'sections',
        parent_id: root['id'],
      }
      child_node[:new_id] = child['new_id'] unless child['new_id'].nil?
      list_nodes(child).insert(0, child_node)
    end.flatten
  end
end
