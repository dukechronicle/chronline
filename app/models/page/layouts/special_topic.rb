class Page::Layouts::SpecialTopic< Layout

  def schema
    {
      'image' => {
        'label' => 'Image',
        'required' => true,
        'extends' => image_schema,
      },
      'list_title' => {
        'type' => 'string',
        'label' => 'Article List Label',
      },
      'side_articles' => {
        'type' => 'array',
        'label' => 'Side List Articles',
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
      },
      'description' => {
        'label' => 'description',
        'extends' => markdown_schema
      }
    }
  end
end
