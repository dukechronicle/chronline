# A convenience wrapper and presenter for article searching with Solr
# To interact with Solr directly for article search use the `Article::search`
# class method as defined by the Sunspot API
# @todo Abstract retrieving highlighted contents through decorator methods
#   (e.g. `body_highlighted`)
class Article::Search
  include ActiveAttr::Model

  attribute :query
  attribute :author, type: Integer
  attribute :section, type: String
  attribute :date

  attribute :page, type: Integer, default: 1
  attribute :sort,  :default => :score
  attribute :order, :default => :desc

  attribute :per_page, type: Integer, default: 25

  # Returns results for an initialized search object with the title and body
  # optionally highlighted; highlights with the `<mark />` tag
  #
  # @example Making a search with highlighted fields
  #
  #   @article_search = Article::Search.new(params[:article_search])
  #   @articles = @article_search.articles highlight: false
  #
  # @note Highlighted output will replace the title and teaser of an article
  #
  # @param [Hash] options
  # @option options [Boolean] :highlight ('true') whether to highlight the
  #   search results
  # @return [Sunspot::Search::PaginatedCollection] An array of articles
  #   compatable with popular pagination gems
  def results options = { highlight: true }
    return nil if query.nil? || query.blank?
    if options[:highlight]
      prefix = "<mark>"
      suffix = "</mark>"
      formatted_results = []

      hits.each do |hit|
        result = hit.result
        result.title = highlight(result.title, self.query)

        unless hit.highlights(:body).empty?
          highlighted_teaser = '...'
          hit.highlights(:body).each do |h|
            highlighted_teaser << h.format { |word| "#{prefix}#{word}#{suffix}" }
            highlighted_teaser << '...'
          end
          result.teaser = highlighted_teaser.html_safe
        end
        formatted_results << result
      end
      return Sunspot::Search::PaginatedCollection.new(formatted_results, self.page.to_i, self.per_page, request.total)
    else
      return request.results
    end
  end

  def authors
    request.facet(:author_ids).rows.map do |facet|
      {value: ::Staff.find_by_id(facet.value).name, count: facet.count, lookup: facet.value}
    end
  end

  def sections
    return request.facet(:section).rows.map do |facet|
      {value: facet.value.titlecase, count: facet.count, lookup: facet.value}
    end
  end

  def years
    return request.facet(:created_at).rows.map do |facet|
      {value: facet.value, count: facet.count, lookup: facet.value}
    end
  end

  private

  # @return [<Sunspot::Search::Hit>]
  def hits
    request.hits
  end

  # @return [String]
  def highlight(text, phrases, options = {})
    if text.blank? || phrases.blank?
      text
    else
      highlighter ='<mark>\1</mark>'
      match = Array(phrases).map { |p| Regexp.escape(p) }.join('|')
      text.gsub(/(#{match})(?![^<]*?>)/i, highlighter)
    end.html_safe
  end

  # @return [Sunspot::Request]
  def request
    if @request.nil?
      @request = Article.search do

        with(:section, section) if section?
        with(:author_ids, author) if author?
        # with(:authors).all_of(author.to_i) unless authors.blank?
        fulltext self.query, highlight: true, query_phrase_slop: 1, minimum_match: 2

        paginate page: self.page, per_page: self.per_page

        facet :author_ids
        facet :section

        facet :created_at do
          (1990..Time.now.year).each do |y|
            row(y) do
              with :created_at, Time.new(y)..Time.new(y+1)
            end
          end
        end


      end
    end
    @request
  end


end
