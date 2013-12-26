SubdomainFu.configure do |config|
  config.tld_size = ENV['DOMAIN'].count('.')
  config.preferred_mirror = 'www'
end
