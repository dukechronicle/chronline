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

  File.open(Rails.root.join("config", "image_styles.yml")) do |file|
    Image::Styles = YAML::load(file)
  end

  def self.styles
    sizes = []
    Image::Styles.map do |type, info|
      sizes << [type, info['width'], info['height']]
      info['sizes'].each do |width|
        height = (width * info['height'] / info['width'].to_f).round
        sizes << [type, width, height]
      end
    end
    styles = sizes.map do |type, width, height|
      ["#{type}_#{width}x".to_sym, "#{width}x#{height}#"]
    end
    styles.to_h
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

  self.per_page = 30

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
