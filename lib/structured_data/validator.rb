module StructuredData
  class Validator < ActiveModel::Validator
    def validate(record)
      layout = record.send(options[:attr])
      record.errors["#{options[:attr]}_data"].concat layout.validate
    end
  end
end
