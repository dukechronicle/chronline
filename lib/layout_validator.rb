class LayoutValidator < ActiveModel::Validator

  def validate(record)
    record.errors[:layout_data] += record.layout.validate
    begin
      record.layout.generate_model
    rescue
      record.errors[:layout_data] << "Something went wrong. Try again."
    end
  end

end
