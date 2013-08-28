class Article::EmbeddedMedia::IconTag < ActionView::Base
  # HAX: there must be a better way to generate HTML
  include ActionView::Helpers

  attr_reader :icon

  def initialize(icon)
    @icon = icon
  end

  def ids
    []
  end

  def to_html(class_objects)
    content_tag(:i, nil, class: "icon-#{@icon}")
  end
end
