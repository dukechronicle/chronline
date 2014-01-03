class Taxonomy
  class Validator < ActiveModel::Validator
    def validate(record)
      taxonomy_term = record[options[:attr]]
      if not taxonomy_term.is_a?(Taxonomy) or
          taxonomy_term.taxonomy != options[:taxonomy]
        record.errors[options[:attr]] <<
          "must be a valid \"#{options[:taxonomy]}\" taxonomy term"
      end
    end
  end
end
