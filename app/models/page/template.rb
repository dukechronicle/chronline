class Page::Template
  require_rel 'template'  # loads in subclasses


  def generate_model(data)
    JSON::Validator.fully_validate(schema, data)
  end

  def schema
    {
      'type' => 'object',
      'required' => true,
      'properties' => model,
    }
  end

  def markdown
    {
      "type" => "string",
      "description" => "Markdown text",
    }
  end

end
