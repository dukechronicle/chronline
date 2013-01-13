SubdomainFu.configure do |config|
  config.tld_size = Settings.domain.count('.')
  config.preferred_mirror = 'www'
end
