class Page::Layouts::ArticleGrid < Layout

  def schema
    {
      'articles' => {
        'type' => 'array',
        'label' => 'Articles',
        'required' => true,
        'items' => article_schema,
      },
    }
  end

end
