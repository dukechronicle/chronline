class Api::ImagesController < ApplicationController
  before_filter :set_access_control_headers

  def index
    images = Image.order('created_at DESC')
    puts response.headers
    render json: images, methods: :thumbnail_url
  end

  private

  def set_access_control_headers
    if request.referrer
      origin = URI(request.referrer)
      origin_server = URI::Generic.build(scheme: origin.scheme,
                                         host: origin.host,
                                         port: origin.port).to_s
      target_domain = URI(request.url).host.sub(/^\w+\./, '')

      if origin.host =~ /^\w+\.#{target_domain}/
        response.headers['Access-Control-Allow-Origin'] = origin_server
      end
    end
  end

end
