module Admin::PagesHelper

  def page_url(page)
    URI.join("http://www.#{current_domain}", page.path).to_s
  end

  def page_layout_options
    StructuredData::Schema.all.map do |schema|
      [schema.title, schema.name, {'data-schema' => schema.json_schema.to_json}]
    end
  end

end
