class Page::Layouts::Commencement < Layout

  def schema
    {
      'slideshow' => {
        'label' => 'Photoshelter Embed',
        'type' => 'string',
        'required' => true,
        'format' => 'multiline',
      },
      'schedule' => {
        'label' => 'Commencement Schedule',
        'required' => true,
        'extends' => markdown_schema,
      },
      'speaker_articles' => {
        'type' => 'array',
        'label' => 'Speaker Articles',
        'required' => true,
        'items' => article_schema,
      },
      'freshman' => {
        'label' => 'Freshman Year',
        'required' => true,
        'extends' => article_schema,
      },
      'sophomore' => {
        'label' => 'Sophomore Year',
        'required' => true,
        'extends' => article_schema,
      },
      'junior' => {
        'label' => 'Junior Year',
        'required' => true,
        'extends' => article_schema,
      },
      'senior' => {
        'label' => 'Senior Year',
        'required' => true,
        'extends' => article_schema,
      },
      'articles' => {
        'type' => 'array',
        'label' => 'Articles',
        'items' => article_schema,
      },
    }
  end

end
