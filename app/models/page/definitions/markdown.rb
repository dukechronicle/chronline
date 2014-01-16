class Page::Definitions::Markdown < StructuredData::Schema::Definition
  def schema
    {
      type: 'string',
      display: 'text'
    }
  end

  def transform(value)
    RDiscount.new(value).to_html
  end
end
