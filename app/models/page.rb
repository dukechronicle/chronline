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

class Page < ActiveRecord::Base
  extend StructuredData

  has_layout :layout

  attr_accessible :path, :title, :description, :image_id
  belongs_to :image

  validates :title, presence: true
  validates :path, presence: true, uniqueness: true,
    format: {with: /^\/[a-z0-9\_\.\-\/]*$/, message: 'Must be a URL path'}
end

# Load template definitions
Dir[Rails.root.join('app', 'models', 'page', 'definitions', '*.rb')].each do |f|
  require_dependency f
end
