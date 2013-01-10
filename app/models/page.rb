require 'layout'


class Page < ActiveRecord::Base
  require_rel 'page/layouts'

  attr_accessible :path, :title, :layout_data, :layout_template

  validates :path, presence: true
  validates :title, presence: true, uniqueness: true, format: {with: /^\/[a-z0-9\_\.\-\/]*$/, message: 'Must be a URL path'}
  validates :template, presence: true

  def layout
    layout_class.new(layout_data)
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
