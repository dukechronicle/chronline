class Page::Layouts::Towerview < Layout

  def schema
    {
      'featured' => {
        'label' => "Featured",
        'type' => 'array',
        'required' => true,
        'minLength' => 3,
        'maxLength' => 3,
        'items' => article_schema,
      },
      'savvy' => {
        'label' => "Savvy",
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'wisdom' => {
        'label' => "Wisdom",
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'prefix' => {
        'label' => "Prefix",
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'editors_note' => {
        'label' => "Editor's Note",
        'extends' => article_schema,
        'required' => true,
      },
      'issuu' => {
        'label' => "Issuu Embed",
        'type' => 'string',
        'required' => true,
        'format' => 'multiline',
      }
    }
  end

end
