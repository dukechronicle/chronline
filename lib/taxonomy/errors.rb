class Taxonomy
  module Errors

    class InvalidTaxonomyError < StandardError
      attr_reader :path

      def initialize(taxonomy, path)
        super(path)
        @taxonomy = taxonomy
        @path = path
      end
    end

    class UnknownTaxonomyError < StandardError
      attr_reader :taxonomy

      def initialize(taxonomy)
        super(taxonomy)
        @taxonomy = taxonomy
      end
    end

  end
end
