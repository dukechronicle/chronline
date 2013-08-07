class Taxonomy
  include Errors

  # Must initialize Taxonomy::Tree here so that it is present on reload
  File.open(Rails.root.join("config", "taxonomy.yml")) do |file|
    Taxonomy::Tree = YAML.load(file)
  end


  def initialize(taxonomy=[])
    if taxonomy.nil?
      taxonomy = []
    elsif taxonomy.is_a? String
      taxonomy = taxonomy.split('/')[1..-1] || []
    end
    @node = find_taxonomy_node(taxonomy)
    if @node.nil?
      raise InvalidTaxonomyError.new(taxonomy)
    end
  end

  ###
  # Comparision operators
  ###

  def ==(rhs)
    rhs.is_a? Taxonomy and to_a == rhs.to_a
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
    @node[:taxonomy][i]
  end

  def as_json(options=nil)
    to_a
  end

  def children
    @node[:children]
      .select { |child| child['new_id'].nil? }
      .map { |child| Taxonomy.new(to_a << child['name']) }
  end

  def id
    @node[:id]
  end

  def name
    @node[:taxonomy].last
  end

  def parent
    if to_s == '/'
      nil
    else
      Taxonomy.new(to_a[0..-2])
    end
  end

  def parents
    parents = [self]
    while parents.last != Taxonomy.new
      parents.push(parents.last.parent)
    end
    parents[0..-2].reverse
  end

  def root?
    to_s == '/'
  end

  def to_a
    Array.new(@node[:taxonomy])
  end

  def to_s
    '/' + @node[:taxonomy].map { |section| section.downcase + '/' }.join
  end

  def self.main_sections
    Taxonomy::Tree.map {|section| Taxonomy.new([section['name']])}
  end

  def self.levels
    level = Taxonomy.main_sections
    levels = []
    while not level.empty? do
      levels << level
      level = levels.last.map {|taxonomy| taxonomy.children}.flatten
    end
    levels
  end

  private
  def find_taxonomy_node(taxonomy)
    root = {'children' => Taxonomy::Tree}
    full_taxonomy = []
    taxonomy.each do |section|
      root = (root['children'] or []).select do |child|
        child['new_id'].nil? && child['name'].downcase == section.downcase
      end.first
      return nil if root.nil?
      full_taxonomy << root['name']
    end
    {
      id: root['id'],
      taxonomy: full_taxonomy,
      children: root['children'] || [],
    }
  end

end
