class Page::Layouts::News < Layout

  def schema
    {
      'featured' => {
        'label' => 'Featured Article',
        'required' => true,
        'extends' => article_schema,
      },
      'headlines' => {
        'label' => 'Headlines',
        'type' => 'array',
        'required' => true,
        'minLength' => 2,
        'maxLength' => 2,
        'items' => article_schema,
      },
      'popular' => {
        'label' => 'Popular in section',
        'required' => true,
        'default' => 'news',
        'extends' => popular_schema,
      },
      'right_headlines' => {
        'label' => 'Right Headlines',
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
      'more_news' => {
        'label' => 'More News',
        'type' => 'array',
        'required' => true,
        'maxLength' => 6,
        'items' => article_schema,
      },
    }
  end

end
