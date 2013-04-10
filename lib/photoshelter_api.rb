require "yaml"
require "json"
require "net/https"
require "uri"

class PhotoShelterAPI

  BaseUri = "https://www.photoshelter.com/psapi/v1"

  def initialize(email, password)
    @email = email
    @password = password
    authenticate
  end

  def get_all_galleries
    path = "/gallery/query"
    args = {}
    headers = {"Cookie" => @cookie}

    response = get_response path, args, headers

    json = JSON.parse response.body
    galleries = json["data"]["gallery"]

    return galleries
  end

  def get_gallery_images(gallery_id)
    path = "/gallery/#{gallery_id}/images"
    args = {}
    headers = {"Cookie" => @cookie}

    response = get_response path, args, headers

    json = JSON.parse response.body
    images = json["data"]["images"]

    return images
  end

  def get_image_info(image_id)
    path = "/image/#{image_id}/iptc"
    args = {}
    headers = {"Cookie" => @cookie}

    response = get_response path, args, headers

    json = JSON.parse response.body
    image_info = json["data"]

    return image_info
  end

  def logout
    path = "/authenticate/logout"
    args = {}
    headers = {"Cookie" => @cookie}

    response = get_response path, args, headers
  end


  private
    def authenticate
      path = "/authenticate"
      args = {email: @email, password: @password}
      headers = {}

      response = get_response path, args, headers

      all_cookies = response.get_fields("set-cookie")
      cookies_array = Array.new
      all_cookies.each { | cookie |
          if !cookie.include?("deleted") then
            cookies_array.push(cookie.split("; ")[0])
          end
      }
      @cookie = cookies_array.join('; ')
    end

    def get_response(path, args, headers)
      args.merge!({:format => "json"})

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

      unless response.code != 200
        raise "Bad response code: #{response.code}"
      end

      return response
    end
end

config_file = '/Users/prithvi/Documents/Aptana Studio 3 Workspace/chronline/config/settings/development.local.yml';
Settings = File.exists?(config_file) ? YAML.load_file(config_file) : {}

api = PhotoShelterAPI.new(Settings['photoshelter']['username'], Settings['photoshelter']['password'])
galleries = api.get_all_galleries
images = api.get_gallery_images galleries.first["id"]
puts api.get_image_info images.first["id"]
api.logout