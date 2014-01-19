class Admin::PollsController < Admin::BaseController
  def index
    @polls = Poll.page(params[:page]).order("created_at DESC")
  end

  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new(params[:poll])
    if @poll.save
      redirect_to admin_poll_url(@poll, subdomain: :admin)
    else
      render 'new'
    end
  end
end
