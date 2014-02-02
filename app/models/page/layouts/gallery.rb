class Page::Layouts::Gallery < Layout

  def schema
    {
      'slideshow' => {
        'label' => 'Featured Gallery',
        'required' => true,
        'type' => 'array',
        'items' => gallery_schema,
      }, 
      'twitter_widget' => {
        'label' => 'Twitter Widget ID',
        'type' => 'string',
        'required' => true,
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
    }
  end
end
