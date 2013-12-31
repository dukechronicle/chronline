module Rss::ApplicationHelper

  def title(section)
    if section.is_a? Blog
      "The Chronicle | #{section.name}"
    elsif section.root?
      "The Chronicle"
    else
      "The Chronicle | #{section.to_a.join(', ')}"
    end
  end

end
