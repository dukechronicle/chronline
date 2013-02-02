# config/initializers/carrierwave.rb
CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => Settings.aws.access_key_id,
    :aws_secret_access_key  => Settings.aws.secret_access_key,
  }
  config.fog_directory  = Settings.aws.bucket
end
