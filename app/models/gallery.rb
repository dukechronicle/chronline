class Gallery < ActiveRecord::Base
  self.primary_key = :gid

  attr_accessible :name, :gid, :description, :section, :photoshelter_images

  validates :name, presence: true
  validates :gid, presence: true, uniqueness: true

  def get_gallery_images
    PhotoshelterImage.find_all_by_gid(gid)
  end

  # replaces all sequences on non-alphanumeric characters with a dash
  # used to get the proper url for the photoshelter buy page
  def slug
    name.strip.gsub(/[^[:alnum:]]+/, "-")
  end

  def credit
    if get_gallery_images.size > 0
      get_gallery_images.first.credit
    end
  end

  def empty?
    get_gallery_images.empty?
  end

  def to_param
    gid
  end
end
