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
require 'has_layout'


class Page < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  extend HasLayout

  attr_accessible :path, :title, :description, :image_id
  belongs_to :image

  has_layout

  validates :title, presence: true
  validates :path, presence: true, uniqueness: true, format: {with: /^\/[a-z0-9%\_\.\-\/]*$/, message: 'Must be a URL path'}
  validates_with LayoutValidator
end
