class Page::Template::SingleBlock < Page::Template

  def model
    {
      contents: {
        extends: {'$ref' => :markdown},
        required: true,
        label: 'Body Contents',
      }
    }
  end

end
