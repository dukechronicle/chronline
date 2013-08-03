class Site::SearchesController < Site::BaseController

  def show
    if params[:search]
      params[:search][:page] = params[:page]
      params[:search][:highlight] = true
      @search = Search.new(params[:search])
      @results = @search.results
    else
      @search = Search.new
      @results = []
    end
  end

end
