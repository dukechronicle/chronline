class Taxonomy
  class Serializer
    def initialize(taxonomy)
      @taxonomy = taxonomy
    end

    def load(path)
      Taxonomy.new(@taxonomy, path)
    end

    def dump(taxonomy)
      taxonomy.to_s
    end
  end
end
