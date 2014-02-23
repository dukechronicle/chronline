require 'rake'
Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
Chronline::Application.load_tasks 
class PhotoshelterWorker
  @queue = :photoshelter
  def self.perform
    Rake::Task['photoshelter:scrape'].reenable
    Rake::Task['photoshelter:scrape'].invoke
  end
end
