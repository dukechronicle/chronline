require 'rake'
Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
Chronline::Application.load_tasks # providing your application name is 'sample'
class PhotoshelterWorker
  @queue = :photoshelter
  def self.perform
    Rake::Task['photoshelter:scrape'].reenable
    Rake::Task['photoshelter:scrape'].invoke
  end
end
