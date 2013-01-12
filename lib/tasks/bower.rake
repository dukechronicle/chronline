namespace :bower do
  desc "Install Bower packages"
  task :install do
    in_vendor_assets do
      bower 'install'
    end
  end

  desc "Update Bower packages"
  task :update do
    in_vendor_assets remove_components: false do
      bower 'update'
    end
  end

end

def in_vendor_assets(options={})
  options[:remove_components] ||= true
  Dir.chdir("#{Rails.root}/vendor/assets") do
    puts "Working in #{Dir.pwd}..."
    if options[:remove_components]
      puts "Removing components..."
      FileUtils.rm_rf('components')
    end
    yield
  end
end

def bower(arguments)
  bower = find_command('bower') or
    raise "Bower not found! You can install Bower using Node and npm:
    `npm install bower -g`
For more info see http://twitter.github.com/bower/"
  system("#{bower} #{arguments}")
end
