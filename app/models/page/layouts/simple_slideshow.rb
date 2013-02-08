class Page::Layouts::SimpleSlideshow < Layout

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
