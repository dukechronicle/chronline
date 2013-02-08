class Page::Layouts::Newsletter < Layout

  def schema
    {
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
