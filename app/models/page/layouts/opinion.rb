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
      'columnists' => {
        'label' => 'Columnists',
        'extends' => columnists_schema,
      },
      'topic' => {
        'label' => 'Discussion Board ID',
        'required' => true,
        'extends' => topic_schema,
      },
    }
  end

end
