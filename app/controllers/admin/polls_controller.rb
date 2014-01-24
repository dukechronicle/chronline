class Admin::PollsController < Admin::BaseController
  def index
    @polls = Poll.page(params[:page]).order("created_at DESC")
  end

  def new
    @poll = Poll.new
  end

  def create
    @poll = update_poll(Poll.new)
    if @poll.save
      redirect_to edit_admin_poll_url(@poll, subdomain: :admin)
    else
      render 'new'
    end
  end

  def edit
    @poll = Poll.find(params[:id])
  end

  def update
    @poll = update_poll(Poll.find(params[:id]))
    if @poll.save
      redirect_to edit_admin_poll_url(@poll, subdomain: :admin)
    else
      render 'new'
    end
  end

  private
  def update_poll(poll)
    choice_titles = params[:poll].delete(:choice_ids).reject {|s| s.blank? }
    poll.assign_attributes(params[:poll])
    poll.choices = Poll::Choice.find_create_or_delete_poll_choices(poll, choice_titles)
    poll
  end
end
