class Page::Layouts::Recess < Layout

  def schema
    {
      'slideshow' => {
        'label' => "Slideshow",
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'editors_notes' => {
        'label' => "Editor's Notes",
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'music' => {
        'label' => 'Music Articles',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'film' => {
        'label' => 'Film Articles',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'art' => {
        'label' => 'Art Articles',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'multimedia' => {
        'label' => 'Embedded Multimedia',
        'type' => 'array',
        'required' => true,
        'items' => {
          'type' => 'string',
          'format' => 'multiline',
        }
      },
    }
  end

end
