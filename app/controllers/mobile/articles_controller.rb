class Mobile::ArticlesController < Mobile::BaseController
  def show
    @article = Article.find(params[:id])
    if request.path != mobile_article_path(@article)
      return redirect_to [:mobile, @article], status: :moved_permanently
    end
  end

  def index
  end

  def search
  end
end
