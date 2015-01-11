class Beta::BaseController < ApplicationController
  layout 'beta'

  # TODO: think about how to handle special pages on mobile
  before_filter :redirect_mobile, except: :custom_page


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

  def sitemap_proxy
    res = HTTParty.get("http://#{ENV['AWS_S3_BUCKET']}.s3.amazonaws.com" +
                       "/sitemaps/news/sitemap1.xml.gz")
    send_data res.body
  end

  def custom_page
    @page = Page.find_by_path!(request.path)
    @model = promise { @page.layout.model }
    @title = @page.title
    @description = @page.description
    render "beta/pages/#{@page.layout_template.to_s.underscore}"
  end

  def not_found
    render 'beta/404', status: :not_found
  end

end
