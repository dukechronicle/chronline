
namespace :photoshelter do
  desc "Refresh Photoshelter galleries and images"
  task :refresh => [:scrape]

  desc "Scrape Photoshelter API"
  task :scrape => :environment do
    require 'gallery/image' 

    PhotoshelterAPI.instance.get_all_galleries.each do |gallery|
      if !Gallery.exists?(:gid => gallery['id']) then
        begin
          date = Date.strptime gallery['name'], '%Y/%m/%d'
        rescue ArgumentError
          date = nil
        end
        gallery_name = gallery['name'].gsub(/[0-9]+\/[0-9]+\/[0-9]+/, '').sub(/^[\s\-]+/, '').lstrip
        Gallery.create(gid: gallery['id'], name: gallery_name, description: gallery['description'], date: date)
        images = PhotoshelterAPI.instance.get_gallery_images gallery['id']
        if images then
          images.each do |image|
            info = PhotoshelterAPI.instance.get_image_info image['id']
            if !Gallery::Image.exists?(:pid => image['id'], :gid => gallery['id']) then
              Gallery::Image.create(:pid => image['id'], :gid => gallery['id'], :caption => info['caption'], :credit => info['credit'], :title => info['title'])
            end
          end
        end
      end
    end
  end

  desc "Empty Photoshelter data"
  task :empty => :environment do
    require 'gallery/image'
    Gallery.delete_all
    'Gallery::Image'.delete_all
  end


end
