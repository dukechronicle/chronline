# @author Faraz <faraz.yashar@gmail.com>
#
# A convenience wrapper and presenter for article searching with Solr
# To interact with Solr directly for article search use the `Article::search`
# class method as defined by the Sunspot API
#
class Article::Search
  include ActiveAttr::Model

  attribute :query

  attribute :title
  attribute :teaser
  attribute :body

  attribute :authors
  attribute :section
  attribute :year

  attribute :page
  attribute :sort
  attribute :order

  attr_accessible :query

  validates :query, :length => {:minimum => 2}, format: {with: /\A[\w]+\z/}

  # Returns results for an initialized search object with fields optionally
  # highlighted; highlights with the `<mark />` tag by default
  #
  # @example Getting search results with custom highlighting
  #
  #   @article_search = Article::Search.new(params[:article_search])
  #   @article_search.valid? # validate the search
  #   @articles = @article_search.results :highlight => {
  #     title: {prefix: '*', postfix: '*'},
  #     :subtitle,
  #     :body
  #   }
  #
  # @todo custom prefix/suffix
  #
  # @param [Hash] options
  # @option options [<Symbol>] :highlight the attributes to highlight
  # @return [<Article>] This should actually be a
  #   `Sunspot::Search::PaginatedCollection` of `Article`s however there is an
  #   [outstanding issue in sunspot](https://github.com/sunspot/sunspot/issues/354)
  def results options = {}
    request = build_request
    if options.empty?
      return request.results
    elsif options.has_key?(:highlight)
      results = []
      hits.each do |hit|
        highlighted = {}
        for field in options[:highlight]
          formatted = []
          hit.highlights(field).each do |hlight|
            formatted << hlight.format { |q| "<mark>#{q}</mark>" }
          end
          unless formatted.empty?
            highlighted[field] = "...#{formatted.join('...')}...".html_safe
          end
        end
        #@note May cause issues with mass assignment protections
        hit.result.attributes = highlighted
        results << hit.result
      end
      request.results.each_with_index{|r,i| r=results[i]}
      request.results
    end
  end

  # @return [<Sunspot::Search::Hit>]
  def hits
    build_request.hits
  end

  private

  # @return [Sunspot::Request]
  def build_request
    if @request.nil?
      @request = Article.search do
        # with(:section, section) unless section.blank?
        # with(:authors).all_of(author.to_i) unless authors.blank?
        fulltext self.query, highlight: true, query_phrase_slop: 1, minimum_match: 2
        # facet :section
        # facet :author_ids
        # order_by :published_at, :desc if query.blank?
        paginate page: self.page, per_page: 3
      end
    end
    @request
  end

end
