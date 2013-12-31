class PhotoshelterImage < ActiveRecord::Base
  BASE_IMAGE_URL = "http://cdn.c.photoshelter.com/img-get"
  attr_accessible :title, :credit, :caption, :pid, :uploaded_at, :section, :gid

  validates :gid, presence: true
  validates :pid, presence: true

  def url(width = nil)
    width ? ("#{BASE_IMAGE_URL}/#{pid}/s/#{width}") : ("#{BASE_IMAGE_URL}/#{pid}")
  end

  # url of the photoshelter buy page
  def photoshelter_url
    "http://dukechronicle.photoshelter.com/gallery-image/#{get_gallery.slug}/#{get_gallery.gid}/#{pid}"
  end

  # gets the gallery by gallery id 
  def get_gallery
    Gallery.find_by_gid(gid)
  end
end
