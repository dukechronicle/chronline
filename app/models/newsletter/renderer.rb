class Newsletter
  class Renderer < ActionView::Base
    include Rails.application.routes.url_helpers

    def initialize
      super(ActionView::LookupContext.new([Rails.root.join(*%w(app views newsletter))]))
    end

    def advertisement(href, image_src)
      link_to href do
        image_tag image_src, alt: 'Advertisement', size: '160x600'
      end
    end

    def header_image(image_path, alt)
      image_src = path_to_image(image_path)
      image_tag image_src, alt: alt, id: 'headerImage', style: 'max-width:600px;'
    end
  end
end
