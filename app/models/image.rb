# == Schema Information
#
# Table name: images
#
#  id                    :integer          not null, primary key
#  caption               :string(255)
#  location              :string(255)
#  credit                :string(255)
#  original_file_name    :string(255)
#  original_content_type :string(255)
#  original_file_size    :integer
#  original_updated_at   :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  photographer_id       :integer
#

require_dependency 'staff'

class Image < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  File.open(File.join("app", "models", "image", "styles.yml")) do |file|
    Image::Styles = YAML::load(file)
  end

  def self.styles
    Image::Styles.map do |type, info|
      [type.underscore.to_sym, "#{info['width']}x#{info['height']}#"]
    end.to_h
  end

  attr_accessible :attribution, :caption, :date, :location, :original, :credit
  attr_accessor :crop_style, :crop_x, :crop_y, :crop_w, :crop_h
  has_attached_file :original, styles: self.styles, processors: [:cropper]

  default_value_for(:date) { Date.today }

  validates :original, attachment_presence: true
  validates :date, presence: true

  has_many :articles
  has_many :pages
  has_many :staff, foreign_key: :headshot_id
  belongs_to :photographer, class_name: "Staff"


  def to_jq_upload
    [{
      name: original_file_name,
      size: original_file_size,
      url: edit_admin_image_path(self),
      thumbnail_url: original.url(:thumb_rect),
      delete_url: admin_image_path(self),
      delete_type: 'DELETE',
     }]
  end

  ###
  # Helper methods for rendering JSON
  ###

  def thumbnail_url
    original.url(:thumb_rect)
  end

end
