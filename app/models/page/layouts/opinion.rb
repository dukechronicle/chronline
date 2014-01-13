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
        'label' => 'Blog RSS Feed',
        'extends' => rss_schema,
        'required' => true,
      },
      'columnists' => {
        'label' => 'Columnists',
        'extends' => columnists_schema,
      },
      'cartoon' => {
        'label' => 'Cartoon',
        'extends' => image_schema,
        'required' => true,
      },
      'topic' => {
        'label' => 'Discussion Board ID',
        'required' => true,
        'extends' => topic_schema,
      },
    }
  end

end
