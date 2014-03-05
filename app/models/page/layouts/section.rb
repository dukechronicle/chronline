class Page::Layouts::Section < Layout

  def schema
    {
      'top_headline' => {
        'label' => 'Top Headline Story',
        'type' => 'object',
        'properties' => {
          'article' => {
            'label' => 'Article',
            'extends' => article_schema,
            'required' => false,
          },
          'breaking' => {
              'label' => 'Breaking?',
              'type' => 'boolean',
          },
          'page' => {
            'label' => 'Page',
            'extends' => page_schema,
            'required' => false,
          },
        }
      },
      'slideshow' => {
        'label' => 'Slideshow',
        'type' => 'object',
        'required' => true,
        'properties' => {
          'articles' => {
            'label' => 'Articles',
            'type'=> 'array',
            'required'=> true,
            'items'=> article_schema,
          },
          'pages' => {
            'label' => 'Page IDs',
            'type' => 'array',
            'items' => page_schema,
          },
          'pages_first' => {
            'label' => 'Pages First?',
            'type' => 'boolean',
          }
        }
      },
      'topnews' => {
        'label' => 'Top News',
        'type'=> 'array',
        'required'=> true,
        'items'=> article_schema,
      },
      'popular' => {
        'label' => 'Most Commented',
        'extends' => disqus_popular_schema,
      }
    }
  end

end
