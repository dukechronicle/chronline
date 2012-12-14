class TextListInput < SimpleForm::Inputs::Base
  def input
    @builder.fields_for(attribute_name, input_options, input_html_options) do |form|
      # Custom naming of select fields required in order to form array
      input_html_options[:name] = "#{form.object_name}[]"
      input = form.text_field(0, input_html_options)
      type = attribute_name.to_s.singularize.gsub(/_id$/, '')
      html = "<div class=\"addible-field\">#{input}</div>" +
        "<button class=\"btn add-field\">Add #{type}</button>"
      html.html_safe
    end
  end
end
