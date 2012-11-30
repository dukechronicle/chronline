module Exceptions

  class InvalidTaxonomyError < StandardError
    attr_reader :taxonomy

    def initialize(taxonomy)
      @taxonomy = taxonomy
    end
  end

end
