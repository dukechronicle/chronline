module StructuredData
  class Schema
    SCHEMA_PATH = %w(app models page schemata)


    def initialize(schema)
      @schema = schema
    end

    def self.[](schema_name)
      path = SCHEMA_PATH + ["#{schema_name}.json"]
      File.open(Rails.root.join(*path), 'r')  do |file|
        self.new(JSON.load(file))
      end
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
