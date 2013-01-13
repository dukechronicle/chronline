module Admin::PagesHelper

  def page_url(page)
    URI.join("http://www.#{current_domain}", page.path).to_s
  end

  def page_layout_options
    Page::Layouts.all.each_pair.map do |name, layout_class|
      [name, name, {'data-schema' => layout_class.new(nil).json_schema.to_json}]
    end
  end

end
