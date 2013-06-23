module StructuredData

  def has_layout(layout_attr = :layout)
    @@layout_attr = layout_attr

    attr_reader "#{@@layout_attr}_data", "#{@@layout_attr}_schema"

    validates "#{@@layout_attr}_data", presence: true
    validates "#{@@layout_attr}_schema", presence: true

    define_method @@layout_attr do
      if self.instance_variable_get("@#{@@layout_attr}").nil?
        layout_class = self.send("#{@@layout_attr}_class")
        layout_data = self.send("#{@@layout_attr}_data")
        self.instance_variable_set(
          "@#{@@layout_attr}", layout_class.new(layout_data))
      end
      @layout
    end

    define_method "#{@@layout_attr}_data=" do |data|
      self.instance_variable_set("@#{@@layout_attr}_data", data)
      self.instance_variable_set("@#{@@layout_attr}", nil)
    end

    define_method "#{@@layout_attr}_schema=" do |schema|
      self.instance_variable_set("@#{@@layout_attr}_schema", schema)
      self.instance_variable_set("@#{@@layout_attr}", nil)
    end

    define_method "#{@@layout_attr}_class" do
      return OpenStruct
      class_name = layout_template.to_s.camelcase.to_sym
      begin
        layout_class = Page::Layouts.const_get(class_name)
        layout_class if layout_class < Layout
      rescue NameError
        nil
      end
    end
  end

end
