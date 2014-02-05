class Page::Layouts::VideoSlideshow < Layout

  def schema
    {
      'slideshow' => {
        'type' => 'array',
        'label' => 'Slideshow Articles',
        'required' => true,
        'items' => article_schema,
      },
      'list_title' => {
        'type' => 'string',
        'label' => 'Article List Label',
      },
      'top_articles' => {
        'type' => 'array',
        'label' => 'Top List Articles',
        'required' => true,
        'items' => article_schema,
      },
      'video_1' => {
        'label' => 'Featured Embed Code',
        'type' => 'string',
        'format' => 'multiline',
        'required' => true,
      }, 
      'video_2' => {
        'label' => 'Featured Embed Code',
        'type' => 'string',
        'format' => 'multiline',
        'required' => true,
      }, 
      'video_3' => {
        'label' => 'Featured Embed Code',
        'type' => 'string',
        'format' => 'multiline',
        'required' => true,
      }, 
      'bottom_articles' => {
        'type' => 'array',
        'label' => 'Bottom Block Articles',
        'required' => false,
        'items' => {
          'extends' => article_schema,
          'required' => false,
        }
      }
    }
  end

end
