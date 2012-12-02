require 'exceptions'


class Taxonomy
  include Exceptions


  def initialize(taxonomy=[])
    if taxonomy.is_a? String
      taxonomy = taxonomy.split('/')[1..-1]
    end
    @node = find_taxonomy_node(taxonomy)
    if @node.nil?
      raise InvalidTaxonomyError.new(taxonomy)
    end
  end

  def ==(rhs)
    rhs.is_a? Taxonomy and to_a == rhs.to_a
  end

  def children
    @node[:children].map do |child|
      Taxonomy.new(to_a + [child.name])
    end
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

  def to_a
    @node[:taxonomy]
  end

  def to_s
    '/' + @node[:taxonomy].map { |section| section.downcase + '/' }.join
  end

  def self.main_sections
    Settings.taxonomy.map {|section| Taxonomy.new([section.name])}
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
    root = {children: Settings.taxonomy}
    full_taxonomy = []
    taxonomy.each do |section|
      root = (root[:children] or []).select do |child|
        child.name.downcase == section.downcase
      end.first
      return nil if root.nil?
      full_taxonomy << root.name
    end
    {taxonomy: full_taxonomy, children: root[:children] || []}
  end

end
