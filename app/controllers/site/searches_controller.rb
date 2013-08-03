class Site::SearchesController < Site::BaseController

  def show
    if params[:search]
      params[:search][:page] = params[:page]
      @search = Search.new(params[:search])
      @results = @search.results
    else
      @search = Search.new(highlight: true)
      @results = []
    end
  end

end
