options = {
  storage: :s3,
  s3_credentials: {
    :bucket => Settings.aws.bucket,
    :access_key_id => Settings.aws.access_key_id,
    :secret_access_key => Settings.aws.secret_access_key,
  },
  s3_host_alias: Settings.content_cdn,
  url: ':s3_alias_url',
  path: 'images/:style/:hash.:extension',
  hash_secret: 'super secret string',
}

Paperclip::Attachment.default_options.merge!(options)
