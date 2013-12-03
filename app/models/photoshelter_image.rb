class PhotoshelterImage < ActiveRecord::Base
  attr_accessible :title, :credit, :caption, :pid, :uploaded_at, :section, :gid

  validates :gid, presence: true
  validates :pid, presence: true

  def get_image_url
    "http://cdn.c.photoshelter.com/img-get/#{pid}/"
  end

  def get_photoshelter_url
    "http://dukechronicle.photoshelter.com/gallery-image/#{get_gallery.get_slug}/#{get_gallery.gid}/#{pid}"
  end

  def get_gallery
    Gallery.where(gid: gid).first
  end
end
