require "yaml"
require "json"
require "net/https"
require "uri"

class PhotoShelterAPI

  BaseUri = 'https://www.photoshelter.com/psapi/v1'

  def initialize(email, password)
    @email = email
    @password = password
    authenticate
  end

  def get_all_galleries
    path = "/gallery/query"
    args = {format: "json"}
    headers = {"Cookie" => @cookie}

    response = get_response path, args, headers
    
    json = JSON.parse response.body
    galleries = json["data"]["gallery"]

    return galleries
  end

  def logout
    path = "/authenticate/logout"
    args = {format: "json"}
    headers = {"Cookie" => @cookie}

    response = get_response path, args, headers

    unless response.code != 200
      raise "Error logging out. Code: #{response.code}"
    end
  end


  private
    def authenticate
      path = "/authenticate"
      args = {email: @email, password: @password, format: "json"}
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
      
      return http.request(request)
    end
end

config_file = '/Users/prithvi/Documents/Aptana Studio 3 Workspace/chronline/config/settings/development.local.yml';
Settings = File.exists?(config_file) ? YAML.load_file(config_file) : {}

api = PhotoShelterAPI.new(Settings['photoshelter']['username'], Settings['photoshelter']['password'])
galleries = api.get_all_galleries
api.logout