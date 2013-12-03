class Gallery < ActiveRecord::Base
  attr_accessible :name, :gid, :description, :section, :photoshelter_images

  validates :name, presence: true
  validates :gid, presence: true, uniqueness: true

  def get_gallery_images
    PhotoshelterImage.find_all_by_gid(gid)
  end

  def get_slug
    name.strip.gsub(/[^[:alnum:]]+/, "-")
  end
end
