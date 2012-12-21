class StringInput < SimpleForm::Inputs::StringInput
  include InputValueHelper

  def input
    if input_options[:value_method]
      input_html_options[:value] = value(@reflection.name)
        .send(input_options[:value_method])
    end
    super
  end
end
