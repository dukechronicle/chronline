class PhotoshelterWorker
  @queue = :photoshelter
  def self.perform
    Gallery.scrape
  end
end
