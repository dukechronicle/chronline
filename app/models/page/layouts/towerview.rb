class Page::Layouts::Towerview < Layout

  def schema
    {
      'featured' => {
        'label' => "Featured",
        'type' => 'array',
        'required' => true,
        'minLength' => 3,
        'maxLength' => 3,
        'items' => article_schema,
      },
      'bus_stop' => {
        'label' => "The Bus Stop",
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'plaza' => {
        'label' => "The Plaza",
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'inquisitor' => {
        'label' => "The Inquisitor",
        'extends' => article_schema,
        'required' => true,
      },
      'editors_note' => {
        'label' => "Editor's Note",
        'extends' => article_schema,
        'required' => true,
      },
      'multimedia' => {
        'label' => 'Multimedia',
        'type' => 'array',
        'required' => true,
        'items' => {
          'type' => 'string',
          'format' => 'multiline',
        }
      },
      'issuu' => {
        'label' => "Issuu Embed",
        'type' => 'string',
        'required' => true,
        'format' => 'multiline',
      }
    }
  end

end
