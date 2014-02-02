class Site::PollsController < Site::BaseController
  def show
    @poll = Poll.find(params[:id])
    @choices = @poll.choices.order('votes DESC, title ASC')
  end

  def vote
    @poll = Poll.find(params[:id])
    @choice = Poll::Choice.find(params[:choice])
    @choice.update_attributes(votes: @choice.votes + 1)
    redirect_to site_poll_path(@poll)
  end
end

