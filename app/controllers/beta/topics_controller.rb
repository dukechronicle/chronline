class Beta::TopicsController < Beta::BaseController

  def show
    @topic = Topic.find(params[:id])
  end

  def index
    @active_topics = Topic.where('archived = ?', false)
    @archived_topics = Topic.where('archived = ?', true)
  end

end
