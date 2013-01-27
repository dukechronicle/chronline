class Article::Search
  include ActiveAttr::Model
  attribute :query
  attribute :year
  attribute :authors
  attribute :sort
  attribute :order
  attribute :page
  attribute :section

  # TODO is this an appropriate default?
  @query = ''

  attr_accessible :query

  validates :query, :length => {:minimum => 2}, format: {with: /\A[\w]+\z/}

  # Executes a query against the database
  # @return
  def results
    Article.search do
      with(:section, section) unless section.blank?
      with(:authors).all_of(author.to_i) unless authors.blank?

      fulltext self.query, highlight: true, query_phrase_slop: 1, minimum_match: 2
      facet :section

      facet :author_ids

      if query.blank?
        order_by :published_at, :desc
      end
      paginate page: page, per_page: 10
    end.results
  end


  private

  def execute
    self.sort = 'relevance' unless['relevance', 'data'].include? self.sort
    self.order = 'desc' unless ['asc', 'desc'].include? self.order
  end

end
