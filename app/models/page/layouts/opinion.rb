class Page::Layouts::Opinion < Layout

  def schema
    {
      'featured' => {
        'label' => "Today's Columns",
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'editorial_board' => {
        'label' => 'Editorial Board Section',
        'description' => 'This should never change',
        'required' => true,
        'default' => '/opinion/editorial board/',
        'extends' => section_articles_schema,
      },
      'blog' => {
        'extends' => rss_schema,
        'required' => true,
      },
      'cartoon' => {
        'extends' => image_schema,
        'required' => true,
      },
    }
  end

end
