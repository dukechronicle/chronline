class Page::Layouts::Sponsor < Layout
  def schema
    {
      'logo_url' => {
        'label' => 'Logo URL',
        'required' => true,
        'type' => 'string',
      },
      'description' => {
        'label' => 'Description',
        'required' => true,
        'extends' => markdown_schema,
      },
      'sponsor_bar' => {
        'label' => 'Sponsor Bar',
        'required' => true,
        'type' => 'string',
      },
      'sponsors' => {
        'label' => 'Sponsors',
        'type' => 'array',
        'items' => {
          'type' => 'object',
          'properties' => {
            'image_url' => {
              'label' => 'image url',
              'type' => 'string',
              'required' => true
            },
            'image_link'  => {
              'label' => 'image link',
              'type' => 'string',
              'required' => true
            }
          }
        }
      }
    }
  end
end
