class Site::PollsController < Site::BaseController
  def show
    @poll = Poll.find(params[:id])
    if session_poll_vote(@poll)
      @choices = @poll.choices.order('votes DESC, title ASC')
    else
      @choices = @poll.choices.order('title ASC')
    end
    @voted = not(session_poll_vote(@poll).nil?)
  end

  def vote
    @choice = Poll::Choice.find(params[:choice])
    vote_for(@choice)
    redirect_to site_poll_path(@choice.poll)
  end

  private
  def session_poll_vote(poll)
    session["poll#{poll.id}"]
  end

  def set_session_poll_vote(choice)
    session["poll#{choice.poll.id}"] = choice.id
  end

  def vote_for(choice)
    if not session_poll_vote(choice.poll)
      set_session_poll_vote(choice)
      choice.update_attributes(votes: choice.votes + 1)
    end
  end
end
