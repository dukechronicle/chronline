class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  include InputValueHelper

  def input
    if input_options[:native]
      input_html_options[:type] = input_type
      if input_type == :date && value(attribute_name)
        input_html_options[:value] = value(attribute_name).to_date.to_s
      end
      @builder.text_field(attribute_name, input_html_options)
    else
      super
    end
  end
end
