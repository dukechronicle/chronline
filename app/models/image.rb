class Image < ActiveRecord::Base
  attr_accessible :caption, :location
  mount_uploader :original, ImageUploader

  
end
