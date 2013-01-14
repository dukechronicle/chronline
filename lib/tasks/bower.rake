namespace :bower do
  desc "Install Bower packages"
  task :install do
    in_vendor_assets remove_components: true do
      bower 'install'
    end
  end

  desc "Update Bower packages"
  task :update do
    in_vendor_assets do
      bower 'update'
    end
  end

  desc "Resolve assets paths in bower packages"
  task :resolve do
    Dir.chdir("#{Rails.root}/vendor/assets/components") do
      Dir['**/*.css'].each do |filename|
        File.open(filename) do |file|
          contents = file.read
          matches = contents.scan()
          if not matches.empty?
            puts filename
            p contents.scan(/url\((('|")?.*\.(png|gif|jpg|jpeg)('|")?)\)/)
          end
        end
      end
    end
  end
end

def in_vendor_assets(options={})
  Dir.chdir("#{Rails.root}/vendor/assets") do
    puts "Working in #{Dir.pwd}..."
    if options[:remove_components]
      puts "Removing components..."
      FileUtils.rm_rf('components')
    end
    yield
  end
end

def embedded_images(str)
  image_url_regex = /url\((('|")?.*\.(png|gif|jpg|jpeg)('|")?)\)/
end

def bower(arguments)
  bower = find_command('bower') or
    raise "Bower not found! You can install Bower using Node and npm:
    `npm install bower -g`
For more info see http://twitter.github.com/bower/"
  system("#{bower} #{arguments}")
end
