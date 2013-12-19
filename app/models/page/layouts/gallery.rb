class Page::Layouts::Gallery < Layout

  def schema
    {
      'slideshow' => {
        'label' => 'Featured Gallery',
        'required' => true,
        'extends' => gallery_schema,
      }, 
      'twitter_widget' => {
        'label' => 'Twitter Widget ID',
        'type' => 'string',
        'required' => true,
      },
      'featured' => {
        'label' => 'Featured Galleries',
        'type' => 'array',
        'items' => gallery_schema,
      },
      'news' => {
        'label' => 'Row One Galleries',
        'type' => 'array',
        'items' => gallery_schema,
      },
      'sports' => {
        'label' => 'Row Two Galleries',
        'type' => 'array',
        'items' => gallery_schema,
      },
      'recess' => {
        'label' => 'Row Three Galleries',
        'type' => 'array',
        'items' => gallery_schema,
      },
    }
  end
end
