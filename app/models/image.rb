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
  include ActiveModel::ForbiddenAttributesProtection

  Attributions = [
    '? / The Chronicle',
    '? / Chronicle File Photo',
    'Photo Illustration by ?',
    'Chronicle Graphic by ?',
  ]

  File.open(Rails.root.join("config", "image_styles.yml")) do |file|
    Image::Styles = YAML::load(file)
  end

  def self.styles
    sizes = []
    Image::Styles.each do |type, info|
      sizes << [type, info['width'], info['height']]
      info['sizes'].each do |width|
        height = (width * info['height'] / info['width'].to_f).round
        sizes << [type, width, height]
      end
    end
    styles = sizes.map do |type, width, height|
      ["#{type}_#{width}x".to_sym, "#{width}x#{height}#"]
    end
    Hash[styles]
  end

  attr_accessible :attribution, :caption, :date, :location, :original, :credit,
    :photographer_id
  # Used in crop! method
  attr_reader :crop_style, :crop_x, :crop_y, :crop_w, :crop_h
  has_attached_file :original, styles: self.styles,
    processors: [:cropper, :paperclip_optimizer]
  process_in_background :original

  default_value_for(:date) { Date.today }
  default_value_for :attribution, Attributions[0]

  validates :original, attachment_presence: true
  validates :date, presence: true

  has_many :articles
  has_many :blog_posts, class_name: "Blog::Post"
  has_many :posts

  has_many :pages
  has_many :staff, foreign_key: :headshot_id
  belongs_to :photographer, class_name: "Staff"

  self.per_page = 30

  def crop!(style, x, y, w, h)
    @crop_style, @crop_x, @crop_y, @crop_w, @crop_h = style, x, y, w, h
    reprocess_style!(style)
  end

  def reprocess_style!(style)
    info = Image::Styles[style]
    styles = ([info['width']] + info['sizes']).map do |width|
      "#{style}_#{width}x"
    end
    original.reprocess_without_delay!(*styles)
  end

  ###
  # Helper methods for rendering JSON
  ###

  def thumbnail_url
    original.url(:rectangle_183x)
  end
end

# Necessary to avoid autoload namespacing conflict
require_dependency 'gallery/image' 
