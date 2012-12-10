require 'taxonomy'


class TaxonomyInput < SimpleForm::Inputs::Base
  def input
    levels = Taxonomy.levels
    selects = 3.times.map do |i|
      options = [['--', '']] + levels[i].map do |t|
        [t.name, {class: t.parent.name}]
       end

      options_html = @builder.template.options_for_select(options)
      @builder.template.select_tag("taxonomy[#{i}]", options_html,
                                   input_html_options)
    end.join(' ')
    @builder.hidden_field(attribute_name, input_html_options) + selects.html_safe
  end
end
