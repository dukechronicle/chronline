namespace :photoshelter do

  desc "Refresh Photoshelter galleries and images"
  task :refresh => [:scrape]

  desc "Scrape Photoshelter API"
  task :scrape => :environment do
    PhotoshelterAPI.instance.get_all_galleries.each do |gallery|
      if !Gallery.exists?(:gid => gallery['id']) then
        Gallery.create(gid: gallery['id'], name: gallery['name'], description: gallery['description'])
        images = PhotoshelterAPI.instance.get_gallery_images gallery['id'] 
        if images then
          images.each do |image|
            PhotoshelterImage.create(:pid => image['id'], :gid => gallery['id'])
          end
        end
      end
    end
  end

end