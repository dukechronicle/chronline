module HasTaxonomy
  def has_taxonomy(field_name, taxonomy)
    include InstanceMethods
    scope field_name, ->(taxonomy) { where("#{field_name} LIKE ?", "#{taxonomy.to_s}%") }

    validates_with Taxonomy::Validator, attr: field_name, taxonomy: taxonomy
    serialize field_name, Taxonomy::Serializer.new(taxonomy)

    define_method("#{field_name}=") do |taxonomy_term|
      unless taxonomy_term.is_a?(Taxonomy)
        taxonomy_term = Taxonomy.new(taxonomy, taxonomy_term)
      end
      super(taxonomy_term)
    end

    define_singleton_method(:taxonomy=) do |taxonomy|
      @taxonomy = taxonomy
      validates_with Taxonomy::Validator, attr: field_name, taxonomy: taxonomy
      serialize field_name, Taxonomy::Serializer.new(taxonomy)
    end
    private_class_method :taxonomy=
  end

  module InstanceMethods
    private
    def taxonomy
      self.class.instance_variable_get(:@taxonomy)
    end
  end
end
