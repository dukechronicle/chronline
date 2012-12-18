Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_credentials] = {
  :bucket => Settings.aws.bucket,
  :access_key_id => Settings.aws.access_key_id,
  :secret_access_key => Settings.aws.secret_access_key,
}
