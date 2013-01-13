module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      if crop_command
        trans = super
        index = trans.index('-crop')
        trans.slice!(index, 3) if index
        ["-crop", %["#{crop_command}"], "+repage"] + trans
      else
        super
      end
    end

    def crop_command
      target = @attachment.instance
      style = target.crop_style.underscore.to_sym if target.crop_style
      if style and Image.styles[style] == target_geometry.to_s
        "#{target.crop_w.to_i}x#{target.crop_h.to_i}+#{target.crop_x.to_i}+#{target.crop_y.to_i}"
      end
    end
  end
end
