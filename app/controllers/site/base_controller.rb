class Site::BaseController < ApplicationController
  layout 'site'

  before_filter :redirect_mobile


  def redirect_mobile
    if browser.mobile?
      if params[:force_full_site]
        session[:force_full_site] = true
      end

      if not session[:force_full_site]
        url = URI(request.url)
        url.host.sub!(/^www/, 'm')
        redirect_to url.to_s
      end
    end
  end

  def custom_page
    @page = Page.find_by_path!(request.path)
    @model = @page.layout.model
    @title = @page.title
    render "site/pages/#{@page.layout_template.to_s.underscore}"
  end

  def not_found
    render 'site/404'
  end

end
