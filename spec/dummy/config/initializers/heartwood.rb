Heartwood::Uploader.configure do |config|
  config.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
  config.aws_bucket = ENV['AWS_BUCKET']
  config.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
end
