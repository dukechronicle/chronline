class PhotoshelterImage
  attr_accessible :title, :author, :caption, :pid, :uploaded_at, :section, :images

  validates :name, presence: true
  validates :pid, presence: true, uniqueness: true
end
