class Site::PollsController < Site::BaseController
  def show
    @poll = Poll.includes(:choices).find(params[:id])
    render json: {
      poll: @poll,
      choices: @poll.choices,
      voted: session.has_key?("poll#{@poll.id}")
    }
  end

  def vote
    @choice = Poll::Choice.find(params[:choice])
    vote_for(@choice)
    render json: {
      poll: @choice.poll,
      choices: @choice.poll.choices,
      voted: session.has_key?("poll#{@choice.poll.id}")
    }
  end

  private

  def vote_for(choice)
    if not session["poll#{choice.poll.id}"]
      session["poll#{choice.poll.id}"] = choice.id
      choice.update_attributes(votes: choice.votes + 1)
    end
  end
end
