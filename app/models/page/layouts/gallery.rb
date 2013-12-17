class Page::Layouts::Gallery < Layout

  def schema
    {
      'featured' => {
        'label' => 'Featured Gallery',
        'required' => true,
        'extends' => gallery_schema,
      },
      'row1' => {
        'label' => 'Row One Galleries',
        'type' => 'array',
        'items' => gallery_schema,
      },
      'row2' => {
        'label' => 'Row Two Galleries',
        'type' => 'array',
        'items' => gallery_schema,
      },
      'row3' => {
        'label' => 'Row Three Galleries',
        'type' => 'array',
        'items' => gallery_schema,
      },
    }
  end
end
