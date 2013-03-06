class Blog
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :id, :name


  def initialize(attributes={})
    attributes.each do |attr, value|
      send("#{attr}=", value)
    end
  end

  # Required to comply with ActiveModel interface
  def persisted?
    true
  end

  def self.find(id)
    if Settings.blogs[id]
      attributes = Hash[Settings.blogs[id]]
      attributes['id'] = id
      self.new(attributes)
    end
  end

end
