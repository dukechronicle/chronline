require "yaml"
require "net/https"
require "uri"

class PhotoShelterAPI

  def initialize(email, password)
    @email = email
    @password = password
    authenticate
  end

  def authenticate
    uri = URI.parse("https://www.photoshelter.com/psapi/v1/authenticate")
    args = {email: @email, password: @password, format: "json"}
    uri.query = URI.encode_www_form(args)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    all_cookies = response.get_fields("set-cookie")
    cookies_array = Array.new
    all_cookies.each { | cookie |
        if !cookie.include?("deleted") then
          cookies_array.push(cookie.split("; ")[0])
        end
    }
    @cookie = cookies_array.join('; ')
  end

  def get_galleries
    uri = URI.parse("https://www.photoshelter.com/psapi/v1/gallery/query")
    args = {format: "json"}
    uri.query = URI.encode_www_form(args)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    request = Net::HTTP::Get.new(uri.request_uri)
    request.initialize_http_header({})
    request['Cookie'] = @cookie
    response = http.request(request)
    puts response.body
  end

  def logout
    uri = URI.parse("http://www.photoshelter.com/psapi/v1/authenticate/logout?fomat=json")
    response = Net::HTTP.get_response(uri)
  end

end

config_file = '/Users/prithvi/Documents/Aptana Studio 3 Workspace/chronline/config/settings/development.local.yml';
Settings = File.exists?(config_file) ? YAML.load_file(config_file) : {}

api = PhotoShelterAPI.new(Settings['photoshelter']['username'], Settings['photoshelter']['password'])
api.get_galleries
#api.logout