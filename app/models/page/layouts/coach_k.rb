class Page::Layouts::CoachK < Layout

  def schema
    {
      'note' => {
        'label' => 'Editors Note',
        'required' => true,
        'extends' => markdown_schema,
      },
      'image_url' => {
        'label' => 'Image URL',
        'required' => true,
        'type' => 'string',
      },
      'featured_stories' => {
        'label' => 'Featured Articles',
        'type' => 'array',
        'required' => true,
        'items' => {
          'type' => 'object',
          'properties' => {
            'article' => {
              'label' => 'Article',
              'required' => true,
              'extends' => article_schema,
            },
            'video' => {
              'label' => 'Video',
              'type' => 'string',
            },
            'headline' => {
              'label' => 'Display Tag',
              'type' => 'string',
            }
          }
        }
      },
      'stories' => {
        'label' => 'Recent Articles',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'twitter_widgets' => {
        'label' => 'Twitter Widgets',
        'type' => 'array',
        'items' => {'type' => 'string'},
      },
      'count_up' => {
        'type' => 'number',
        'required' => true,
        'label' => 'Count Up',
      },
      'standings_url' => {
        'type' => 'string',
        'required' => true,
      },
      'twitter' => {
        'type' => 'string',
        'required' => true,
      },
      'facebook' => {
        'type' => 'string',
        'required' => true,
      }
    }
  end

end
