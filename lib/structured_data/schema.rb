module StructuredData
  class Schema

    def initialize(schema)
      @schema = schema
    end

    def self.[](schema_name)

    end

    def json_schema
      {
        '$schema' => StructuredData::JSONSchema::SCHEMA_URI,
        'type' => 'object',
        'required' => true,
        'properties' => @schema,
      }
    end

  end
end
