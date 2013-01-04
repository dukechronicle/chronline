class Site::BaseController < ApplicationController
  layout 'site'

  before_filter :redirect_mobile


  def redirect_mobile
    if browser.mobile?
      url = URI(request.url)
      url.host.sub!(/^www/, 'm')
      redirect_to url.to_s
    end
  end

end
