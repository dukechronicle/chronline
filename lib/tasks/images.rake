namespace :images do

  desc "Recrop style for all images. Uses largest image with same ratio as base."
  task :crop, [:style] => :environment do |t, args|
    if args.style =~ /(\w+)_(\d+)x/
      Image.find_each do |image|
        crop_sizes(image, $1, [$2])
      end
    else
      Image.find_each do |image|
        image.reprocess_style!(args.style)
      end
    end
  end

end

def crop_sizes(image, type, sizes)
  file = cropped_file(image, type)

  # HAX: Paperclip is only designed to process original image. Oh well...
  image.original.queued_for_write[:original] = file
  sizes.each do |size|
    style_name = "#{type}_#{size}x".to_sym
    style = image.original.styles[style_name]
    image.original.send(:post_process_style, style_name, style)
  end
  image.original.queued_for_write.delete(:original)

  image.save!
end

def cropped_file(image, type)
  width = Image::Styles[type]['width']
  file = URI.parse('https:' + image.original.url("#{type}_#{width}x"))
  if file.host
    file.scheme = 'https'
  else
    # Development environment
    file = File.open(Rails.root.join("public", file.path[1..-1]))
  end
  Paperclip.io_adapters.for(file)
end
