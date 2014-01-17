module StructuredData

  def has_layout(layout_attr = :layout)
    attr_accessible "#{layout_attr}_data", "#{layout_attr}_schema"

    validates "#{layout_attr}_data", presence: true
    validates "#{layout_attr}_schema", presence: true
    validates_with StructuredData::Validator, attr: layout_attr

    define_method layout_attr do
      if self.instance_variable_get("@#{layout_attr}").nil?
        data = self.send("#{layout_attr}_data")
        schema = StructuredData::Schema[self.send("#{layout_attr}_schema")]
        self.instance_variable_set(
          "@#{layout_attr}", StructuredData::Layout.new(schema, data))
      end
      self.instance_variable_get("@#{layout_attr}")
    end

    define_method "#{layout_attr}_data=" do |data|
      super(data)
      self.instance_variable_set("@#{layout_attr}", nil)
    end

    define_method "#{layout_attr}_schema=" do |schema|
      super(schema)
      self.instance_variable_set("@#{layout_attr}", nil)
    end
  end

end
