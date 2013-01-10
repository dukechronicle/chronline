# == Schema Information
#
# Table name: pages
#
#  id              :integer          not null, primary key
#  layout_data     :text
#  layout_template :string(255)
#  path            :string(255)
#  title           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'layout'


class Page < ActiveRecord::Base
  require_rel 'page/layouts'

  attr_accessible :path, :title, :layout_data, :layout_template

  validates :title, presence: true
  validates :path, presence: true, uniqueness: true, format: {with: /^\/[a-z0-9\_\.\-\/]*$/, message: 'Must be a URL path'}
  validates :layout_template, presence: true
  validates :layout_data, presence: true

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
