class Page
  module Layouts
    require_rel 'layouts'

    def self.all
      constants.reduce({}) do |layouts, name|
        layout = const_get(name)
        layouts[name] = layout if layout < Layout
        layouts
      end
    end

  end
end
