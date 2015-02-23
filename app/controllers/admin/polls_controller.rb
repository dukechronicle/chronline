class Admin::PollsController < Admin::BaseController
  def index
    @archived_polls = Poll.unscoped.where(archived: true)
      .page(params[:archived_page])
    @unarchived_polls = Poll.unscoped.where(archived: false)
      .page(params[:unarchived_page])
  end

  def new
    @poll = Poll.new
  end

  def create
    @poll = update_poll(Poll.new)
    if @poll.save
      flash[:success] = "Poll was created."
      redirect_to edit_admin_poll_url(@poll, subdomain: :admin)
    else
      render 'new'
    end
  end

  def edit
    @poll = Poll.unscoped.find(params[:id])
  end

  def update
    @poll = update_poll(Poll.unscoped.find(params[:id]))
    if @poll.save
      flash[:success] = "Poll was updated."
      redirect_to edit_admin_poll_url(@poll, subdomain: :admin)
    else
      render 'new'
    end
  end

  private
  def update_poll(poll)
    poll_params = params.require(:poll).permit(
      :archived, :description, :title, choice_ids: [], section: []
    )
    poll_params[:section].reject!(&:empty?)
    choice_titles = poll_params.delete(:choice_ids).reject(&:blank?)
    poll.assign_attributes(poll_params)
    poll.choices = Poll::Choice.find_create_or_delete_poll_choices(poll, choice_titles)
    poll
  end
end
