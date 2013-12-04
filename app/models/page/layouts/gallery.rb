class Page::Layouts::Gallery < Layout

  def schema
    {
      'featured' => {
        'label' => 'Featured Gallery',
        'required' => true,
        'extends' => gallery_schema,
      },
    }
  end
end
