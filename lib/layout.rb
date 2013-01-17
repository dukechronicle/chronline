require 'layout/validator'


class Layout
  require 'layout/schema'

  @@schemata = {}
  @@transformations = {}


  def initialize(data)
    @data = data
  end

  def validate
    JSON::Validator.fully_validate(json_schema, @data, validate_schema: true)
  end

  def generate_model
    Layout::Validator.new(json_schema, @data).validate
  end

  def model
    @model = generate_model if @model.nil?
    @model
  end

  def json_schema
    {
      '$schema' => Layout::Schema::SCHEMA_URI,
      'type' => 'object',
      'required' => true,
      'properties' => schema,
    }
  end

  def self.add_schema(name, schema={}, &proc)
    if block_given?
      schema[:transformation] = name
      @@transformations[name] = proc
    end
    @@schemata[name.to_s] = schema
  end

  def self.transform(transformation, elements)
    @@transformations[transformation].call(elements)
  end

  def method_missing(method)
    if method =~ /(\w+)_schema/ and @@schemata.has_key?($1)
      @@schemata[$1]
    else
      super
    end
  end

end

require 'layout/schemata'
