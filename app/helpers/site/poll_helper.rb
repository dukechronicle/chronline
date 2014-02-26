module Site::PollHelper
  def voted_on_poll?(poll)
    not session["poll#{poll.id}"].nil?
  end

  def poll_json(poll)
    poll.to_json(include: :choices, properties: {voted: ->(poll) { voted_on_poll?(poll) }})
  end
end
