class Mobile::SearchesController < Mobile::BaseController

  def show
    if params[:search]
      params[:search][:page] = params[:page]
      @search = Search.new(params[:search])
      @results = @search.results
    else
      @search = Search.new
      @results = []
    end
  end

end
