##
# Custom Paperclip processor used to crop uploaded image. Object attributes
# +crop_x+, +crop_y+, +crop_w+, +crop_h+, and +crop_style+ are used to set crop
# dimensions.
#
# See http://railscasts.com/episodes/182-cropping-images
#
# Dependencies:: Uses Image.styles

module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      trans = super
      if crop_command
        # Crop before resizing
        index = trans.index('-crop')
        trans.slice!(index, 3) if index
        ["-crop", %["#{crop_command}"], "+repage"] + trans
      else
        trans
      end
    end

    private
    def crop_command
      target = @attachment.instance
      if target.crop_style == crop_style
        "#{target.crop_w}x#{target.crop_h}+#{target.crop_x}+#{target.crop_y}"
      end
    end

    def crop_style
      style = Image.styles
        .select { |style, geom| geom === target_geometry.to_s }
        .keys
        .first
      if style =~ /(\w+)_\d+x/
        $1
      end
    end
  end
end
