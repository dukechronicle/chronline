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
    return nil if query.nil? or query.blank?
    return request.results unless options[:highlight]
    prefix = "<mark>"
    suffix = "</mark>"

    formatted_results = []
    request.each_hit_with_result do |hit, result|
      unless hit.highlights(:title).empty?
        result.title = hit.highlights(:title).first.format{ |word|
          "#{prefix}#{word}#{suffix}"}.html_safe
      end

      unless hit.highlights(:body).empty?
        highlighted_teaser = '...'
        hit.highlights(:body).each do |h|
          highlighted_teaser << h.format { |word| "#{prefix}#{word}#{suffix}" }
          Rails.logger.debug(h.to_yaml)
          highlighted_teaser << '...'
        end
        result.teaser = highlighted_teaser.html_safe
      end
      formatted_results << result
    end
    return Sunspot::Search::PaginatedCollection.new(formatted_results, self.page.to_i, self.per_page, request.total)
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

  # @return [Sunspot::Request]
  def request
    if @request.nil?
      @request = Article.search do
        with(:section, section.titlecase) if section?
        with(:author_ids, author) if author?

        fulltext self.query do
          highlight :title, fragment_size: 0
          highlight :body,  :max_snippets => 3, merge_contiguous_fragments: true
          minimum_match 2
        end

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
