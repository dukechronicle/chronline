CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: Settings.aws.access_key_id,
    aws_secret_access_key: Settings.aws.secret_access_key,
  }
  config.fog_directory  = Settings.aws.bucket
  config.fog_public = true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
end
