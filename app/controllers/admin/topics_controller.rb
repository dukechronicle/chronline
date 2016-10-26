class Admin::TopicsController < Admin::BaseController
  helper_method :approve_toggle, :report_toggle, :archive_toggle

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      redirect_to admin_topics_path
    else
      render 'new'
    end
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(topic_params)
      redirect_to admin_topics_path
    else
      render 'edit'
    end
  end

  def show
    @topic = Topic.find(params[:id])

    if params[:option] == '2'
      @responses = @topic.responses.where('reported = ?', true).order('created_at DESC').paginate(page: params[:page], per_page: 10)
    elsif params[:option] == '3'
      @responses = @topic.responses.where('approved = ?', true).order('created_at DESC').paginate(page: params[:page], per_page: 10)
    else
      @responses = @topic.responses.order('created_at DESC').paginate(page: params[:page], per_page: 10)
    end
  end

  def index
    @active_topics = Topic.where('archived = ?', false)
    @archived_topics = Topic.where('archived = ?', true)
  end

  def archive
    @topic = Topic.find(params[:id])
    @topic.archived = !@topic.archived
    @topic.save!
    redirect_to admin_topics_path
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to admin_topics_path
  end

  private
  def approve_toggle(approved)
    if approved
      'Remove Approval'
    else
      'Approve'
    end
  end

  def report_toggle(reported)
    if reported
      'Remove Reported'
    else
      'Report'
    end
  end

  def archive_toggle(archived)
    if archived
      'UnArchive'
    else
      'Archive'
    end
  end

  def topic_params
    params.require(:topic).permit(:title, :description)
  end
end
