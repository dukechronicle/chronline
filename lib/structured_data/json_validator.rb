module StructuredData
  class JSONValidator < JSON::Validator
    attr_reader :data

    def initialize(schema_data, data, opts={})
      super
      # HAX: Only way I can see to get a hook into validate
      def @base_schema.validate(data, fragments, processor, options = {})
        super
        schema['definitions'].each do |_, definition|
          transformation = definition['transform']
          if transformation.try(:respond_to?, :execute)
            transformation.execute
          end
        end
        processor.perform_validations
      end
      @validations = []
    end

    def add_validation(fragments, definition, &error)
      @validations << [fragments.clone, definition, error]
    end

    def insert(fragments, value)
      if fragments.empty?
        @data = value
      else
        parent = fragments[0...-1].reduce(@data) do |struct, fragment|
          fragment = fragment.to_i if struct.is_a? Array
          struct[fragment]
        end
        key = fragments.last
        key = key.to_i if parent.is_a? Array
        parent[key] = value
      end
    end

    def perform_validations
      @validations.each do |fragments, definition, error|
        value = fragments.reduce(@data) do |struct, fragment|
          fragment = fragment.to_i if struct.is_a? Array
          struct[fragment]
        end
        message = definition.validate(value)
        error.call(message) unless message.blank?
      end
    end
  end
end
