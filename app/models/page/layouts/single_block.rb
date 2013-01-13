class Page::Layouts::SingleBlock < Layout

  def schema
    {
      'contents' => {
        'extends' => markdown_schema,
        'required' => true,
        'label' => 'Body Contents',
      }
    }
  end

end
