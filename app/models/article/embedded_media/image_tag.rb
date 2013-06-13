class Article::EmbeddedMedia::ImageTag < ActionView::Base
  # HAX: there must be a better way to generate HTML
  include ActionView::Helpers
  include ImageHelper
  include Rails.application.routes.url_helpers

  attr_reader :ids

  def initialize(id_csv)
    ids = id_csv.split(',') # order matters, so know id => class
    class_order = [:Image]
    # need to error check to determine if has same number of arguments, what do
    # if not?
    @ids = []
    if class_order.length == ids.length
      class_order.zip(ids) do |klass, id|
        @ids.push({id: id.to_i, class: klass})
      end
    end
  end

  def to_html(class_objects)
    id = @ids[0]
    img = class_objects[id[:class]][id[:id]]
    content_tag(:span, nil, class: 'embedded-image') do
      photo_credit = photo_credit(img, link: true)
      concat content_tag(:img, nil, src: img.original.url(:thumb_rect))
      concat content_tag(:span, photo_credit, class: 'photo-credit')
    end
  end

end
