module Admin::PagesHelper

  def page_url(page)
    URI.join("http://www.#{current_domain}", page.path).to_s
  end

end
