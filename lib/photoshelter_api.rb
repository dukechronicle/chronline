require 'net/http'

class PhotoShelterAPI

  def initialize
    @email = "dukechroniclephoto@gmail.com"
    @password = "chronic"
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
    @cookie = response.response['set-cookie']
  end

  def logout
    uri = URI.parse("http://www.photoshelter.com/psapi/v1/authenticate/logout?fomat=json")
    response = Net::HTTP.get_response(uri)
  end

  def getGalleries
    uri = URI.parse("http://www.photoshelter.com/psapi/v1/gallery/query?format=json")
    http = Net::HTTP.new(uri.host, uri.port)
    
    puts @cookie
    headers = { "Cookie" => @cookie}
    response = http.get(uri.path, headers ) 
    puts response.body
  end


end

api = PhotoShelterAPI.new
api.authenticate
api.getGalleries
api.logout
