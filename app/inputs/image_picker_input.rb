require 'erb'


class ImagePickerInput < SimpleForm::Inputs::Base
  include InputValueHelper

  def input
    field = @builder.hidden_field(attribute_name, input_html_options)
    url = value(@reflection.name).original.url(:thumb_rect)
    field + image_picker(url).html_safe
  end

  private

  def image_picker(url)
    <<EOF
<button class="btn image-attach">
  <i class="icon-picture icon-black"></i>
  Attach
</button>
<div class="btn-group image-change">
  <button class="btn btn-warning image-attach">
    <i class="icon-picture icon-white"></i>
    Change
  </button>
  <button class="btn btn-danger image-attach">
    <i class="icon-remove icon-white"></i>
    Remove
  </button>
</div>
<i class="icon-eye-open icon-black image-display" data-url="#{url}"></i>
EOF
  end
end
