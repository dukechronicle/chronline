require 'yaml'
require "net/https"
require "uri"

class PhotoShelterAPI
  config_file = '/Users/prithvi/Documents/Aptana Studio 3 Workspace/chronline/config/settings/development.local.yml';
  Settings = File.exists?(config_file) ? YAML.load_file(config_file) : {}

  def initialize
    @email = Settings['photoshelter']['username']
    @password = Settings['photoshelter']['password']
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
    #response.header.each_header {|key,value| puts "#{key} = #{value}" }
    all_cookies = response.get_fields('set-cookie')
    cookies_array = Array.new
    all_cookies.each { | cookie |
        if cookie.include?("deleted") then
          # puts cookie
        else
          cookies_array.push(cookie.split('; ')[0])
        end
    }
    @cookie = cookies_array.join('; ')
    # puts @cookie
  end

  def getGalleries
    uri = URI.parse("https://www.photoshelter.com/psapi/v1/gallery/query")
    args = {format: "json"}
    uri.query = URI.encode_www_form(args)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    request = Net::HTTP::Get.new(uri.request_uri)
    request.initialize_http_header({})
    # request['Accept'] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    # request['Accept-Charset'] = 'ISO-8859-1,utf-8;q=0.7,*;q=0.3'
    # request['Accept-Encoding'] = 'gzip,deflate,sdch'
    # request['Accept-Language'] = 'en-US,en;q=0.8'
    # request['Cache-Control'] = 'max-age=0'
    # request['Connection'] = 'keep-alive'
    request['Cookie'] = @cookie
    # request['Host'] = 'www.photoshelter.com'
    # request['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.43 Safari/537.31'
    #request.header.each_header {|key,value| puts "#{key} = #{value}" }
    response = http.request(request)
    puts response.body
  end

  def logout
    uri = URI.parse("http://www.photoshelter.com/psapi/v1/authenticate/logout?fomat=json")
    response = Net::HTTP.get_response(uri)
  end

end

api = PhotoShelterAPI.new
api.authenticate
api.getGalleries
#api.logout