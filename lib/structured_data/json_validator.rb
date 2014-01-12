module StructuredData
  class JSONValidator < JSON::Validator
    attr_reader :data

    def initialize(schema_data, data, opts={})
      super
      # HAX: Only way I can see to get a hook into validate
      def @base_schema.validate(data, fragments, processor, options = {})
        super
        schema['definitions'].each do |_, definition|
          if definition['transform'].try(:respond_to?, :execute)
            definition['transform'].execute
          end
        end
      end
    end

    def insert(fragments, value)
      if fragments.empty?
        @data = value
      else
        parent = fragments[0...-1].reduce(@data) do |struct, fragment|
          fragment = fragment.to_i if struct.is_a? Array
          struct = struct[fragment]
        end
        key = fragments.last
        key = key.to_i if parent.is_a? Array
        parent[key] = value
      end
    end
  end
end
