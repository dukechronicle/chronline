class Article::EmbeddedMedia::EmbeddedImageTag

  def initialize(id_csv)
    ids = id_csv.split(',') # order matters, so know id => class
    class_order = [:Image]
    # need to error check to determine if has same number of arguments, what do
    # if not?
    @ids = []
    if class_order.length == ids.length
      for i in 0...class_order.length
        @ids.push({id: ids[i].to_i, class: class_order[i]})
      end
    end
  end

  def ids()
    return @ids
  end

  def to_html(class_objects)
    id = @ids[0]
    img = class_objects[id[:class]][id[:id]]
    %Q(<span class="embedded-image">
        <img src="#{img.original.url(:thumb_rect)}" />
      </span>
    )
  end

  def populate(retrieved_models)
  end
end
