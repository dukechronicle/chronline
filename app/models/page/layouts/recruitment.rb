class Page::Layouts::Recruitment < Layout
  def schema
   {
      'pitch' => {
        'label' => "Editor's Pitch",
        'extends' => markdown_schema,
        'required' => true,
      },
      'schedule' => {
        'label' => "Schedule",
        'extends' => markdown_schema,
        'required' => true,
      },
      'departments' => {
        'label' => 'Departments',
        'type' => 'array',
        'items' => {
          'type' => 'object',
          'properties' => {
            'name' => {
              'label' => 'Name',
              'type' => 'string',
            },
            'description' => {
              'label' => 'Description',
              'extends' => markdown_schema,
            }
          }
        }
      },
      'form_embed' => {
        'required' => true,
        'type' => 'string',
        'label' => 'Form Embed Code',
      }
    }
  end
end
