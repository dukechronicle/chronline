module HasTaxonomy
  def has_taxonomy
    include Instancemethods

    scope :section, ->(taxonomy) { where('section LIKE ?', "#{taxonomy.to_s}%") }

    validates_with Taxonomy::Validator, attr: :section, taxonomy: :sections
    serialize :section, Taxonomy::Serializer.new(:sections)
  end

  module Instancemethods
    ##
    # Writer for section attribute. Creates a Taxonomy object if section is a
    # string.
    #
    def section=(section)
      unless section.is_a?(Taxonomy)
        section = Taxonomy.new(:sections, section)
      end
      super(section)
    end
  end
end
