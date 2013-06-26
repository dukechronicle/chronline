module StructuredData
  class JSONValidator < JSON::Validator

    def insert(fragments, data)
      if fragments.empty?
        @struct = create_of_type(data)
      else
        parent = fragments[0...-1].reduce(@struct) do |struct, fragment|
          fragment = fragment.to_i if struct.is_a? Array
          struct = struct[fragment]
        end
        key = fragments.last
        key = key.to_i if parent.is_a? Array
        parent[key] = create_of_type(data)
      end
    end

    def struct
      self.validate unless instance_variable_defined? :@struct
      @struct
    end

    private
    def create_of_type(data)
      if data.is_a? Hash
        OpenStruct.new
      elsif data.is_a? Array
        []
      else
        begin
          data.clone
        rescue TypeError
          # Data is not cloneable
          data
        end
      end
    end

  end
end
