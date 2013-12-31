class Post
  class EmbeddedMedia
    class ImageTag < self::Tag
      # HAX: there must be a better way to generate HTML
      include ActionView::Helpers
      include ImageHelper
      include Rails.application.routes.url_helpers

      def initialize(embedded_media, image_id, style = :rectangle_314x)
        @image = embedded_media.find(Image, image_id, include: :photographer)
        @style = style
      end

      def to_html(float: :right)
        classes = "embedded-image embedded-#{float}"
        content_tag(:span, nil, class: classes) do
          photo_credit = photo_credit(@image, link: true)
          concat content_tag(:img, nil, **image_attributes)
          concat content_tag(:span, photo_credit, class: 'photo-credit')
        end
      end

      def to_s
        "{{Image:#{@image.id}}}"
      end

      private
      def image_attributes
        options = {
          alt: @image.caption,
          title: @image.caption,
          src: @image.original.url(@style),
        }
        if @image.original.styles[@style.to_sym].geometry =~ /(\d+)x(\d+)/
          options[:width] = $1
          options[:height] = $2
        end
        options
      end
    end
  end
end
