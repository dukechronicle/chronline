class PhotoshelterImage
  attr_accessor :title, :author, :caption, :pid, :uploaded_at, :section, :images

  def initialize(params)
    @pid = params["id"]
  end
end
