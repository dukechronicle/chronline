class Page::Definitions::HasImage < StructuredData::Schema::Definition
  def validate(record)
    if record.image.nil?
      "Record must have an image"
    end
  end
end
