require 'taxonomy'


class TaxonomyInput < SimpleForm::Inputs::Base
  def input
    levels = Taxonomy.levels

    3.times.map do |i|
      fields_for = @builder.fields_for(attribute_name, input_options,
                                       input_html_options) do |taxonomy_form|
        options = [['--', '']] + levels[i].map do |t|
          [t.name, {class: t.parent.name}]
         end
        taxonomy_form.select(i, options, input_options, input_html_options)
      end
    end.join(' ')
  end
end
