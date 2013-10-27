class Gallery < ActiveRecord::Base
  attr_accessible :name, :pid, :description, :section, :photoshelter_images

  validates :name, presence: true
  validates :pid, presence: true, uniqueness: true

  has_many :photoshelter_images

  def get_gallery_images
    images = Rails.cache.fetch(self.pid) do
      PhotoshelterAPI.instance.get_gallery_images(self.pid)
    end
    images.each_index do |index|
      images[index] = PhotoshelterImage.new(images[index])
    end
  end
end
