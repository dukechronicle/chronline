require 'exceptions'


class Taxonomy
  include Exceptions


  def initialize(taxonomy)
    if taxonomy.is_a? String
      taxonomy = taxonomy.split '/'
    end
    @node = find_taxonomy_node(taxonomy)
    if @node.nil?
      raise InvalidTaxonomyError.new(taxonomy)
    end
  end

  def to_s
    @node[:taxonomy].map { |section| section.downcase + '/' }.join
  end

  def to_a
    @node[:taxonomy]
  end

  private

  def find_taxonomy_node(taxonomy)
    root = {children: Settings.taxonomy}
    fullTaxonomy = []
    taxonomy.each do |section|
      root = (root[:children] || []).select do |child|
        child.name.downcase == section.downcase
      end.first
      return nil if root.nil?
      fullTaxonomy << root.name
    end
    {taxonomy: fullTaxonomy, children: root.children}
  end

end
