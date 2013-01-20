class Article::Search
  include ActiveAttr::Model
  attribute :query
  attribute :year
  attribute :author
  attribute :sort
  attribute :order

  # TODO is this an appropriate default?
  @query = ''

  attr_accessible :query

  validates :query, :length => {:minimum => 2}, format: {with: /\A[\w]+\z/}

  # Executes a query against the database
  # @return
  def results
    execute if valid? and request.nil?
    @request.results
  end

  private

  def execute
    self.sort = 'relevance' unless['relevance', 'data'].include? self.sort
    self.order = 'desc' unless ['asc', 'desc'].include? self.order
    @request = Article.search do
      fulltext self.query
    end
  end

end
