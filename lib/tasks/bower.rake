# Partially stolen from bower-rails project
# https://github.com/rharriso/bower-rails


namespace :bower do

  desc "install files from bower"
  task :install do
    perform_command do
      system 'bower install'
    end
  end

  desc "update bower packages"
  task :update do
    perform_command false do
      system 'bower update'
    end
  end

end

def perform_command(remove_components=true)
  Dir.chdir("#{Rails.root}/vendor/assets") do
    FileUtils.rm_rf("components") if remove_components
    yield
  end
end
