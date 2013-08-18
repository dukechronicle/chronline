class Taxonomy
  class Validator < ActiveModel::Validator

    def validate(record)
      begin
        unless record.send(options[:attr]).is_a? Taxonomy
          validation_error(record)
        end
      rescue Taxonomy::InvalidTaxonomyError
        validation_error(record)
      end
    end

    private
    def validation_error(record)
      record.errors[options[:attr]] << "must be a valid taxonomy term"
    end

  end
end
