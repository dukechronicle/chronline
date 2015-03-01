module Site::PollHelper
  def voted_on_poll?(poll)
    not session["poll#{poll.id}"].nil?
  end

  def find_section_poll(taxonomy)
    hierarchy = taxonomy.parents
    Poll.where(section: hierarchy.map(&:to_s)).order("LENGTH(section) DESC").first
  end
end
