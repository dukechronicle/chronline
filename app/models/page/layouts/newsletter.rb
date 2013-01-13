class Page::Layouts::Newsletter < Layout

  def schema
    {
      'news' => {
        'label' => 'News',
        'type' => 'array',
        'items' => article_schema,
      },
      'sports' => {
        'label' => 'Sports',
        'type' => 'array',
        'items' => article_schema,
      },
      'opinion' => {
        'label' => 'Opinion',
        'type' => 'array',
        'items' => article_schema,
      },
      'recess' => {
        'label' => 'Recess',
        'type' => 'array',
        'items' => article_schema,
      },
      'towerview' => {
        'label' => 'Towerview',
        'type' => 'array',
        'items' => article_schema,
      }
    }
  end

end
