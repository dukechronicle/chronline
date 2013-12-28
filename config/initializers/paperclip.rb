if Rails.env.production?
  options = {
    storage: :s3,
    s3_credentials: {
      :bucket => ENV['AWS_S3_BUCKET'],
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
    },
    s3_protocol: '',
    s3_host_alias: ENV['CONTENT_CDN'],
    s3_headers: { 'Cache-Control' => 'public,max-age=315576000' },
    url: ':s3_alias_url',
    path: 'images/:style/:hash.:extension',
    hash_secret: 'super secret string',
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
