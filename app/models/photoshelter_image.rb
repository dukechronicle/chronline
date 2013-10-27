class PhotoshelterImage
  attr_accessor :title, :author, :caption, :pid, :uploaded_at, :section, :images

  def initialize(params)
    @pid = params["id"]
  end

  def get_image_url
    "http://cdn.c.photoshelter.com/img-get/#{@pid}/"
  end
end
