module ApplicationHelper

  def display_date(model, format="%B %-d, %Y")
    model.created_at.strftime(format)
  end

end
