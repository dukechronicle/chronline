module HasTaxonomy
  def has_taxonomy(field_name, taxonomy)
    scope field_name, ->(taxonomy) { where("#{field_name} LIKE ?", "#{taxonomy.to_s}%") }

    validates_with Taxonomy::Validator, attr: field_name, taxonomy: taxonomy
    serialize field_name, Taxonomy::Serializer.new(taxonomy)

    define_method("#{field_name}=") do |taxonomy_term|
      unless taxonomy_term.is_a?(Taxonomy)
        taxonomy_term = Taxonomy.new(taxonomy, taxonomy_term)
      end
      super(taxonomy_term)
    end
  end
end
