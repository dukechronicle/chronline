class Site::BaseController < ApplicationController
  layout 'site'

  # TODO: think about how to handle special pages on mobile
  before_filter :redirect_mobile, except: :custom_page
  caches_action :custom_page, layout: false, expires_in: 1.day


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
    render 'site/404', status: :not_found
  end

end
