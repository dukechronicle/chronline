# Guardfile
# More info at https://github.com/guard/guard#readme

# TODO replace Configz with more robust configuration scheme and replace
# `has_key?` with something definite
config_file = File.join(Dir.pwd, 'config', 'settings', 'test.local.yml')
Configz = File.exists?(config_file) ? YAML.load_file(config_file) : {}

require 'growl' if RbConfig::CONFIG['host_os'].include?('darwin') && Configz['growl']

if Configz.has_key? 'spork'
  # See "Available Options" at https://github.com/guard/guard-spork
  spork_options = {
    cucumber_env: { 'RAILS_ENV' => 'test' },
    rspec_env: { 'RAILS_ENV' => 'test' },
    testunit: false,
    cucumber: true,
    rspec: true,
    test_unit: false,
    minitest: false
  }
  Configz['spork'].each do |k,v|
    spork_options[k.to_sym] = v
  end

  guard 'spork', spork_options do
    watch('config/application.rb')
    watch('config/environment.rb')
    watch('config/environments/test.rb')
    watch(%r{^config/initializers/.+\.rb$})
    watch('Gemfile')
    watch('Gemfile.lock')
    watch('spec/spec_helper.rb') { :rspec }
    watch('test/test_helper.rb') { :test_unit }
    watch(%r{features/support/}) { :cucumber }
  end
end
rspec_formatter = ''
rspec_formatter = "--format " << Configz['rspec']['formatter'] if defined?(Configz['rspec']['formatter'])

guard 'rspec', cli: "--drb --color #{rspec_formatter}", :all_on_start => false, :all_after_pass => false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }

  # Capybara features specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/features/#{m[1]}_spec.rb" }
end
cucumber_formatter = ''
cucumber_formatter = "--format " << Configz['rspec']['formatter'] if defined?(Configz['rspec']['formatter'])

guard 'cucumber', cli: "--drb --color #{cucumber_formatter}", :all_on_start => false, :all_after_pass => false do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})          { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
end

