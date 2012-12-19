module InputValueHelper
  protected

  def value(attribute_name)
    tag = ActionView::Helpers::InstanceTag.new(
      @builder.object_name, attribute_name, @builder.template)
    tag.value(tag.object)
  end
end
