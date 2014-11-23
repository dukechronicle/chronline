class Page::Layouts::Sports2 < Layout

  def schema
    {
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
          }
        }
      },
      'twitter_widget' => {
        'label' => 'Twitter Widget ID',
        'type' => 'string',
        'required' => true,
      },
      'poll' => {
        'label' => 'Poll',
        'extends' => poll_schema,
      },
      'multimedia' => {
        'label' => 'Embedded Multimedia',
        'type' => 'array',
        'required' => true,
        'items' => {
          'type' => 'string',
          'format' => 'multiline',
        }
      },
      'columns' => {
        'label' => 'Columns',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'features' => {
        'label' => 'Features',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'bottom_articles' => {
        'label' => 'Bottom Articles',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'nav_links' => {
        'label' => 'Navigation links',
        'type' => 'array',
        'items' => {
          'type' => 'object',
          'properties' => {
            'name' => {
              'label' => 'Label',
              'type' => 'string',
            },
            'href' => {
              'label' => 'Path',
              'type' => 'string',
            }
          }
        }
      }
    }
  end

end

