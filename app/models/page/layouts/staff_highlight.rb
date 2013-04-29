class Page::Layouts::StaffHighlight < Layout

  def schema
    {
      'articles' => {
        'type' => 'array',
        'label' => 'Staff Articles',
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
      }
    }
  end

end
