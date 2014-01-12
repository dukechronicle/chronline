class Page::Layouts::Newsletter < Layout

  def schema
    {
      'teaser' => {
        'label' => 'Email Teaser',
        'type' => 'string',
        'required' => true,
        'format' => 'multiline',
      },
      'featured' => {
        'label' => 'Featured',
        'type' => 'array',
        'required' => true,
        'minLength' => 2,
        'maxLength' => 2,
        'items' => article_schema
      },
      'news' => {
        'label' => 'News',
        'type' => 'array',
        'items' => {
          'extends' => article_schema,
          'required' => false,
        }
      },
      'sports' => {
        'label' => 'Sports',
        'type' => 'array',
        'items' => {
          'extends' => article_schema,
          'required' => false,
        }
      },
      'opinion' => {
        'label' => 'Opinion',
        'type' => 'array',
        'items' => {
          'extends' => article_schema,
          'required' => false,
        }
      },
      'recess' => {
        'label' => 'Recess',
        'type' => 'array',
        'items' => {
          'extends' => article_schema,
          'required' => false,
        }
      },
      'towerview' => {
        'label' => 'Towerview',
        'type' => 'array',
        'items' => {
          'extends' => article_schema,
          'required' => false,
        }
      }
    }
  end

end
