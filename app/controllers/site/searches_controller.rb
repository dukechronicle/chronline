class Site::SearchesController < Site::BaseController

  def show
    if params[:search]
      @search = Article::Search.new(params[:search])
      @search.page = params[:page] if params.has_key?(:page)
      @results = @search.results
    else
      @search = Search.new
      @results = []
    end
  end

end
