module Rss::ApplicationHelper

  def title(taxonomy)
    if taxonomy.root?
      "The Chronicle"
    else
      "The Chronicle | #{taxonomy.to_a.join(', ')}"
    end
  end

end
