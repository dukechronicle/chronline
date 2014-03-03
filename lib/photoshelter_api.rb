class PhotoshelterAPI
  include Errors

  BaseUri = "https://www.photoshelter.com/psapi/v2"

  def initialize
    @email ||= ENV['PHOTOSHELTER_EMAIL']
    @password ||= ENV['PHOTOSHELTER_PASSWORD']
    @api_key ||= ENV['PHOTOSHELTER_API_KEY']
    @user ||= ENV['PHOTOSHELTER_USER']
    authenticate
  end

  def authenticate
    path = "/mem/authenticate"
    args = {email: @email, password: @password}
    headers = {"X-PS-Api-Key" => @api_key}

    response = get_response path, headers, args

    all_cookies = response.get_fields("set-cookie")
    cookies_array = Array.new
    all_cookies.each do | cookie |
      # Remove unnecessary cookies from set-cookie header
      if !cookie.include?("deleted")
        cookies_array.push(cookie.split("; ")[0])
      end
    end
    @cookie = cookies_array.join('; ')
    return true
  end

  def get_all_galleries
    path = "/mem/gallery/query"

    json = get_session_response path
    json["data"]["gallery"]
  end

  def get_recently_updated_galleries
    path = "/gallery/recently_updated"

    json = get_session_response path, {user_id: @user}
    json["data"]["galleries"]
  end

  def get_gallery_images(gallery_id)
    path = "/gallery/#{gallery_id}/images"

    json = get_session_response path
    json["data"]["images"]
  end

  def get_image_info(image_id)
    path = "/mem/image/#{image_id}/iptc"

    json = get_session_response path
    json["data"]
  end

  def logout
    path = "/mem/authenticate/logout"
    get_session_response path
  end


  private

    def get_session_response(path, args={})
      response = get_response path, {"Cookie" => @cookie, "X-PS-Api-Key" => @api_key}, args
      ActiveSupport::JSON.decode response.body
    end

    def get_response(path, headers, args={})

      uri = URI.parse(BaseUri + path)
      uri.query = URI.encode_www_form(args)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)

      request.initialize_http_header({})
      headers.each_key do |key|
        request[key] = headers[key]
      end

      response = http.request(request) 
      if response.code != "200"
        raise PhotoshelterError.new(response.code)
      end

      return response
    end
end
