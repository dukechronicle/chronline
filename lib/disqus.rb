class Disqus
  DISQUS_HOST = 'disqus.com'


  def initialize(api_key, options={})
    @api_key = api_key
    @options = {
      api_version: '3.0',
      format: 'json',
      query: {},
    }
    @options.merge!(options)
  end

  def request(resource, action, options={})
    uri = URI::HTTPS.build(host: DISQUS_HOST,
                           path: request_path(resource, action),
                           query: request_query(options))
    Rails.logger.debug(uri.to_s)
    handle_response(HTTParty.get(uri.to_s))
  end


  private

  def request_path(resource, action)
    "/api/%s/%s/%s.%s" % [@options[:api_version],
                          resource,
                          action.to_s.camelcase(:lower),
                          @options[:format]]
  end

  def request_query(params)
    query = @options[:query].merge(params).merge(api_key: @api_key)
    query.map {|key, value| "#{key}=#{value}"}.join('&')
  end

  def handle_response(response)
    if response.code == Rack::Utils.status_code(:ok)
      ActiveSupport::JSON.decode(response.body)
    end
  end

end
