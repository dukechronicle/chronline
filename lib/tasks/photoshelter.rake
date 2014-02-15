namespace :photoshelter do

  desc "Refresh Photoshelter galleries and images"
  task :refresh => [:scrape]

  desc "Scrape Photoshelter API"
  task :scrape => :environment do
    PhotoshelterAPI.instance.get_all_galleries.each do |gallery|
      if !Gallery.exists?(:gid => gallery['id']) then
        begin
          date = Date.strptime gallery['name'], '%Y/%m/%d'
        rescue
          date = nil
        end
        gallery_name = gallery['name'].gsub(/[0-9]+\/[0-9]+\/[0-9]+/, '').sub(/^[\s\-]+/, '').lstrip
        Gallery.create(gid: gallery['id'], name: gallery_name, description: gallery['description'], date: date)
        images = PhotoshelterAPI.instance.photoshelter_images gallery['id']
        if images then
          images.each do |image|
            info = PhotoshelterAPI.instance.get_image_info image['id']
            if !PhotoshelterImage.exists?(:pid => image['id'], :gid => gallery['id']) then
              PhotoshelterImage.create(:pid => image['id'], :gid => gallery['id'], :caption => info['caption'], :credit => info['credit'], :title => info['title'])
            end
          end
        end
      end
    end
  end

  desc "Empty Photoshelter data"
  task :empty => :environment do
    Gallery.delete_all
    PhotoshelterImage.delete_all
  end


end
