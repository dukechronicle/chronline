module Site::PollHelper
  def voted_on_poll?(poll)
    not session["poll#{poll.id}"].nil?
  end
end
