class PhotoshelterImage < ActiveRecord::Base
  attr_accessible :title, :credit, :caption, :pid, :uploaded_at, :section, :gid

  validates :gid, presence: true
  validates :pid, presence: true

  def get_image_url
    "http://cdn.c.photoshelter.com/img-get/#{pid}/"
  end
end
