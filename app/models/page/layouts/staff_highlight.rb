class Page::Layouts::StaffHighlight < Layout

  def schema
    {
      'senior_columns' => {
        'type' => 'array',
        'label' => 'Staff Columns',
        'required' => true,
        'items' => article_schema,
      },
      'editor_columns' => {
        'type' => 'array',
        'label' => 'Editor Columns',
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
