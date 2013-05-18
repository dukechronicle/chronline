if Rails.env.production?
  options = {
    storage: :s3,
    s3_credentials: {
      :bucket => Settings.aws.bucket,
      :access_key_id => Settings.aws.access_key_id,
      :secret_access_key => Settings.aws.secret_access_key,
    },
    s3_protocol: '',
    s3_host_alias: Settings.content_cdn,
    s3_headers: {'Cache-Control' => 'public,max-age=315576000'},
    url: ':s3_alias_url',
    path: 'images/:style/:hash.:extension',
    hash_secret: 'super secret string',  # TODO: do something better
    hash_data: ':class/:attachment/:id/:style',
  }
else
  url = "attachments/#{Rails.env}/:class/:attachment/:id/:style.:extension"
  options = {
    url: "/#{url}",
    path: ":rails_root/public/#{url}"
  }
end

Paperclip::Attachment.default_options.merge!(options)
