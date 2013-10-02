class Gallery < ActiveRecord::Base
  attr_accessible :name, :pid, :description, :section, :photoshelter_images

  validates :name, presence: true
  validates :pid, presence: true, uniqueness: true

  has_many :photoshelter_images
end
