class Page::Template

  def schema
    {
      type: :object,
      required: true,
      properties: model,
    }
  end

end
