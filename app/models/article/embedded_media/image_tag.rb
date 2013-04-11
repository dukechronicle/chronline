class Article::EmbeddedMedia::ImageTag

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
    %Q(<span class="embedded-image">
        <img src="#{img.original.url(:thumb_rect)}" />
      </span>
    )
  end

end
