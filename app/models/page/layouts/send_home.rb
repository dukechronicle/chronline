class Page::Layouts::SendHome < Layout

  def schema
    {
      'slideshow' => {
        'label' => 'Slideshow',
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
      'editors_note' => {
        'label' => "Editor's Note",
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'recruitment_info' => {
        'label' => "Recruitment Info",
        'extends' => markdown_schema,
      },
      'news' => {
        'label' => 'News',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'sports' => {
        'label' => 'Sports',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'recess' => {
        'label' => 'Recess',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'towerview' => {
        'label' => 'Towerview',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
    }
  end

end
