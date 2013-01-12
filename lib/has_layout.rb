module HasLayout

  def has_layout
    include InstanceMethods

    attr_accessible :layout_data, :layout_template

    validates :layout_template, presence: true
    validates :layout_data, presence: true
  end

  module InstanceMethods

    def layout
      @layout = layout_class.new(layout_data) if @layout.nil?
      @layout
    end

    def layout_data=(data)
      super
      @layout = nil
    end

    def layout_template=(template)
      super
      @layout = nil
    end

    def layout_class
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
