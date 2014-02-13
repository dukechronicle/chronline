class Page::Layouts::LargeEmbed < Layout

  def schema
    {
      'slideshow' => {
        'type' => 'array',
        'label' => 'Slideshow Images',
        'required' => true,
        'items' => image_schema,
       },
      'large_embed' => {
        'type' => 'string',
        'label' => 'Large Embed',
      },
      'video' => {
        'label' => 'Video Embed Code',
        'type' => 'string',
        'format' => 'multiline',
        'required' => true,
      },
      'side_articles' => {
        'type' => 'array',
        'label' => 'Block Articles',
        'required' => false,
        'items' => {
          'extends' => article_schema,
          'required' => false,
        }
      }
    }
  end
end
