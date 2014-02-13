class Site::PollsController < Site::BaseController
  def vote
    @choice = Poll::Choice.find(params[:choice])
    vote_for(@choice)
    redirect_to :back
  end

  private

  def vote_for(choice)
    if not session["poll#{choice.poll.id}"]
      session["poll#{choice.poll.id}"] = choice.id
      choice.update_attributes(votes: choice.votes + 1)
    end
  end
end
