class Beta::PollsController < Beta::BaseController
  def show
    @poll = Poll.includes(:choices).find(params[:id])
    render json: @poll.to_json(include: :choices, properties: {
      voted: ->(poll) { session.has_key?("poll#{poll.id}") }
    })
  end

  def vote
    if request.xhr?
      @choice = Poll::Choice.find(params[:choice])
      vote_for(@choice)
      render json: @choice.poll.to_json(include: :choices, properties: {
        voted: ->(poll) { session.has_key?("poll#{poll.id}") }
      })
    end
  end

  private

  def vote_for(choice)
    if not session["poll#{choice.poll.id}"]
      session["poll#{choice.poll.id}"] = choice.id
      choice.update_attributes(votes: choice.votes + 1)
    end
  end
end
