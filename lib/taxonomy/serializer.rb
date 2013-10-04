class Taxonomy
  class Serializer
    def load(taxonomy)
      Taxonomy.new(taxonomy)
    end

    def dump(taxonomy)
      taxonomy.to_s
    end
  end
end
