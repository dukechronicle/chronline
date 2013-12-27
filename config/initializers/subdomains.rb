SubdomainFu.configure do |config|
  config.tld_size =
    Chronline::Application.config.action_dispatch.tld_length =
    ENV['DOMAIN'].count('.')
  config.preferred_mirror = 'www'
end
