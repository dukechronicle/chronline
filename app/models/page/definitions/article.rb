class Page::Definitions::Article < StructuredData::Schema::Definition
  def initialize
    super
    @ids = []
  end

  def schema
    {
      type: 'integer',
      display: 'article-picker'
    }
  end

  def transform(value)
    @ids << value
    promise { @records[value] }
  end

  def execute
    records = Article.find(@ids)
    @records = records.inject({}) do |h, record|
      h[record.id] = record
      h
    end
  end
end
