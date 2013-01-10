require 'layout'


class Page < ActiveRecord::Base
  require_rel 'page/layouts'

  attr_accessible :path, :title, :layout_data, :layout_template

  validates :path, presence: true
  validates :title, presence: true, uniqueness: true, format: {with: /^\/[a-z0-9\_\.\-\/]*$/, message: 'Must be a URL path'}
  validates :template, presence: true

  def layout
    Page::Layouts::SingleBlock.new(layout_data)
  end

end
