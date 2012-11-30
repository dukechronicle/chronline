class Taxonomy

  def initialize(taxonomy)
    #taxonomy = taxonomy.map |section| { section.downcase + '/' }.join
    @taxonomy = taxonomy
  end

  def to_s
    @taxonomy.map { |section| section.downcase + '/' }.join
  end

  def to_a
    @taxonomy
  end

end
