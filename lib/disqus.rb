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
    HTTParty.get(uri.to_s)
  end

  def popular_articles(forum, limit)
    res = request(:threads, :list_hot, limit: limit, forum: forum)['response']
    slugs = res.map do |thread|
      slug = URI.parse(thread['link']).path.gsub(%r{^/article/}, '')
      [slug, thread['posts']]
    end
    articles = Article.where(slug: slugs.map(&:first))
    results = slugs.map do |slug, comments|
      article = articles.find {|article| article.slug == slug}
      [article, comments] unless article.nil?  # TODO: this shouldn't be needed
    end.compact
    results.sort_by! {|slug, comments| -comments}
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

end
