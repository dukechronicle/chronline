class LayoutValidator < ActiveModel::Validator

  def validate(record)
    record.errors[:layout_data] += record.layout.validate
  end

end
