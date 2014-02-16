class Gallery::Image < ActiveRecord::Base
  self.primary_key = :pid

  BASE_IMAGE_URL = "http://cdn.c.photoshelter.com/img-get"
  attr_accessible :title, :credit, :caption, :pid, :uploaded_at, :section, :gid, :gallery

  self.table_name = :gallery_images  # FIX: Rename this class Gallery::Image

  belongs_to :gallery, foreign_key: :gid
  validates :gid, presence: true
  validates :pid, presence: true

  def url(width = nil)
    width ? "#{BASE_IMAGE_URL}/#{pid}/s/#{width}" : "#{BASE_IMAGE_URL}/#{pid}"
  end

  # url of the photoshelter buy page
  def photoshelter_url
    "http://dukechronicle.photoshelter.com/gallery-image/#{gallery.photoshelter_slug}/#{gallery.gid}/#{pid}"
  end

end

