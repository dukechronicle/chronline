class PhotoshelterImage
  attr_accessible :title, :author, :caption, :pid, :uploaded_at, :section, :images

  validates :name, presence: true
  validates :pid, presence: true, uniqueness: true

  def get_image_url
    "http://cdn.c.photoshelter.com/img-get/#{@pid}/"
  end
end
