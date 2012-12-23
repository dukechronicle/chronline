class StringInput < SimpleForm::Inputs::StringInput
  include InputValueHelper

  def input
    if input_options[:value_method]
      target = value(@reflection.name)
      if target
        input_html_options[:value] = target.send(input_options[:value_method])
      end
    end
    super
  end
end
