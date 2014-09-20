class Page::Layouts::News < Layout

  def schema
    {
      'featured' => {
        'label' => 'Featured Article',
        'required' => true,
        'extends' => article_schema,
      },
      'headlines' => {
        'label' => 'Headlines',
        'type' => 'array',
        'required' => true,
        'minLength' => 2,
        'maxLength' => 2,
        'items' => article_schema,
      },
      'right_headlines' => {
        'label' => 'Right Headlines',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
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
      'more_news' => {
        'label' => 'More News',
        'type' => 'array',
        'required' => true,
        'maxLength' => 6,
        'items' => article_schema,
      },
      'blog' => {
        'label' => 'Blog',
        'type' => 'object',
        'properties' => {
          'url' => {
            'label' => 'URL',
            'type' => 'string',
            'required' => true,
          },
          'feed' => {
            'label' => 'RSS Feed',
            'extends' => rss_schema,
            'required' => true,
          }
        }
      },
      'poll' => {
        'label' => 'Poll',
        'extends' => poll_schema,
      },
      'popular' => {
        'label' => 'Popular in section',
        'required' => true,
        'default' => 'news',
        'extends' => popular_schema,
      },
      'twitter_widget' => {
        'label' => 'Twitter Widget ID',
        'type' => 'string',
      },
    }
  end

end
