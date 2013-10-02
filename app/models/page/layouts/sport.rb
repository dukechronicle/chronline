class Page::Layouts::Sport < Layout

  def schema
    {
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
      'information' => {
        'type' => 'object',
        'required' => true,
        'label' => 'Game Information',
        'properties' => {
          'date' => {
            'required' => true,
            'extends' => datetime_schema,
          },
          'location' => {
            'type' => 'string',
            'required' => true,
          },
          'channel' => {
            'type' => 'string',
            'required' => true,
          },
          'espn_url' => {
            'type' => 'string',
            'required' => true,
          }
        }
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
