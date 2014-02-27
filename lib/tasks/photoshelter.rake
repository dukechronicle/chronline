
namespace :photoshelter do
  desc "Refresh Photoshelter galleries and images"
  task :refresh => [:scrape]

  desc "Scrape Photoshelter API"
  task :scrape => :environment do
    Gallery.scrape
  end

  desc "Empty Photoshelter data"
  task :empty => :environment do
    require 'gallery/image'
    Gallery.delete_all
  end


end
