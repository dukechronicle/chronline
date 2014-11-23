class Page::Layouts::Recess2 < Layout

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
      'playground' => {
        'label' => "Playground",
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'more_articles' => {
        'label' => 'More Articles',
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
