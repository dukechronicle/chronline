require 'taxonomy'





class TaxonomyInput < SimpleForm::Inputs::Base
  def input
    levels = Taxonomy.levels

    @builder.fields_for(attribute_name, input_options, input_html_options) do |form|
      3.times.map do |i|
        input_options[:selected] = value(attribute_name)[i]
        # Custom naming of select fields required in order to form array
        input_html_options[:name] = "#{form.object_name}[]"
        form.select(i, level_options(i), input_options, input_html_options)
      end.join(' ').html_safe
    end
  end


  private

  def level_options(level)
    [['--', nil]] + Taxonomy.levels[level].map do |t|
      [t.name, {class: t.parent.name}]
     end
  end

  def value(attribute_name)
    tag = ActionView::Helpers::InstanceTag.new(
      @builder.object_name, attribute_name, @builder.template)
    tag.value(tag.object)
  end
end
