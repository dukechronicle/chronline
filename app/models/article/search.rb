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
  attribute :start_date
  attribute :end_date

  attribute :page, type: Integer, default: 1
  attribute :sort,  default: :score
  attribute :order, default: :desc

  attribute :per_page, type: Integer, default: 25
  attribute :highlight, default: true
  attribute :include

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
  # @return [Sunspot::Search::PaginatedCollection] An array of articles
  #   compatable with popular pagination gems
  def results
    return nil if query.blank?
    highlight_results if highlight
    request.results
  end

  def authors
    author_facets = request.facet(:author_ids).rows
    author_names = {}
    Staff.where(id: author_facets.map(&:value)).each do |author|
      author_names[author.id] = author.name
    end
    author_facets.map do |facet|
      {value: author_names[facet.value], count: facet.count, lookup: facet.value}
    end
  end

  def sections
    request.facet(:section).rows.map do |facet|
      {value: facet.value.titlecase, count: facet.count, lookup: facet.value}
    end
  end


  private

  def highlight_results
    request.results.zip(request.hits) do |result, hit|
      unless hit.highlights(:title).empty?
        result.title = highlighted(hit, :title).first.html_safe
      end

      unless hit.highlights(:body).empty?
        result.teaser =
          ("...%s..." % highlighted(hit, :body).join("...")).html_safe
      end
    end
  end

  def highlighted(hit, field)
    hit.highlights(field).map do |highlight|
      # Strip out HTML tags from matched fragments
      highlight.instance_variable_get(:@highlight).gsub!(/<[^>]*>/, '')
      highlight.format {|word| "<mark>#{word}</mark>"}
    end
  end

  # @return [Sunspot::Request]
  def request
    if @request.nil?
      @request = Article.search(include: self.include) do
        with(:section, section.titlecase) if section?
        with(:author_ids, author) if author?
        with(:published_at).greater_than(start_date) if start_date?

        fulltext self.query do
          highlight :title, fragment_size: 0
          highlight :body, max_snippets: 3, merge_contiguous_fragments: true
          minimum_match 2
        end

        paginate page: self.page, per_page: self.per_page

        order_by(self.sort, self.order)

        facet :author_ids
        facet :section
      end
    end
    @request
  end


end
