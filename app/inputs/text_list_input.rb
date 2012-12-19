class TextListInput < SimpleForm::Inputs::Base
  include InputValueHelper

  def input
    @builder.fields_for(attribute_name, input_options, input_html_options) do |form|
      # Custom naming of select fields required in order to form array
      input_html_options[:name] = "#{form.object_name}[]"

      values = value(@reflection.plural_name).map(&input_options[:value_method])
      inputs = values.each_with_index.map do |value, i|
        text_input(form, value, i, input_html_options)
      end
      inputs << text_input(form, nil, values.length, input_html_options)

      input_html = inputs.map do |input|
        "<div class=\"addible-field\">#{input}</div>"
      end.join

      type = attribute_name.to_s.singularize.gsub(/_id$/, '')
      html = "#{input_html}<button class=\"btn add-field\">Add #{type}</button>"
      html.html_safe
    end
  end


  private

  def text_input(form, value, i, options)
    options = options.clone
    options[:value] = value || ''
    input = form.text_field(i, options)
  end
end
