module StructuredData
  class Schema
    @@schemata = {}


    def initialize(schema)
      @schema = schema
    end

    def description
      @schema['description']
    end

    def json_schema
      {
        '$schema' => StructuredData::JSONSchema::SCHEMA_URI,
        'definitions' => definitions
      }.merge(@schema)
    end

    def title
      @schema['title']
    end

    private
    def definitions
      pairs = Definition.subclasses.map do |definition|
        [definition.schema_name, definition.new.schema]
      end
      Hash[pairs]
    end

    class << self
      def all
        @@schemata.map { |name, schema| self.new(schema) }
      end

      def each(&block)
        self.all.each(&block)
      end

      def [](schema_name)
        if @@schemata.include? schema_name.to_s
          self.new(@@schemata[schema_name.to_s])
        end
      end

      def load_schemata!(*path)
        # Glob of JSON files in directory
        dir_path = Rails.root.join(*(path + ['*.json']))

        # Regex to extract schema name from filepath
        path_pattern = Rails.root.join(*(path + ['(.*).json']))
        path_regex = Regexp.new(path_pattern.to_s)

        Dir[dir_path].each do |filepath|
          schema_name = path_regex.match(filepath)[1]
          File.open(filepath, 'r') do |file|
            @@schemata[schema_name] = JSON.load(file)
          end
        end
      end
    end
  end
end

StructuredData::Schema.load_schemata!('app', 'models', 'page', 'schemata') if Rails.env.development?

