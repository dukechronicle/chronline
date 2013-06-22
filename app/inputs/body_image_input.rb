class BodyImageInput < SimpleForm::Inputs::Base
  include InputValueHelper

  def input
    @builder.text_area(attribute_name, input_html_options) + body_image_input().html_safe
  end

  private

  def body_image_input()
    <<EOF
<br />
<button class="btn image-insert">
  <i class="icon-picture icon-black"></i>
  Insert
</button>
EOF
  end
end
