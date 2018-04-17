require 'spec_helper'

RSpec.describe Heartwood::Uploader   do

  let(:acl) { Faker::Lorem.sentence }
  let(:aws_access_key_id) { Faker::Lorem.sentence }
  let(:aws_bucket) { Faker::Lorem.sentence }
  let(:aws_secret_access_key) { Faker::Lorem.sentence }
  let(:expiration) { Faker::Lorem.sentence }
  let(:max_file_size) { Faker::Lorem.sentence }
  let(:multipart) { Faker::Lorem.sentence }
  let(:prefix) { Faker::Lorem.sentence }
  let(:form_id) { Faker::Lorem.sentence }

  describe '#configuration' do
    it 'allows setting and getting each option' do
      Heartwood::Uploader.configuration.acl = acl
      Heartwood::Uploader.configuration.aws_access_key_id = aws_access_key_id
      Heartwood::Uploader.configuration.aws_bucket = aws_bucket
      Heartwood::Uploader.configuration.aws_secret_access_key = aws_secret_access_key
      Heartwood::Uploader.configuration.expiration = expiration
      Heartwood::Uploader.configuration.max_file_size = max_file_size
      Heartwood::Uploader.configuration.multipart = multipart
      Heartwood::Uploader.configuration.prefix = prefix
      Heartwood::Uploader.configuration.form_id = form_id

      expect(Heartwood::Uploader.configuration.acl).to eq(acl)
      expect(Heartwood::Uploader.configuration.aws_access_key_id).to eq(aws_access_key_id)
      expect(Heartwood::Uploader.configuration.aws_bucket).to eq(aws_bucket)
      expect(Heartwood::Uploader.configuration.aws_secret_access_key).to eq(aws_secret_access_key)
      expect(Heartwood::Uploader.configuration.expiration).to eq(expiration)
      expect(Heartwood::Uploader.configuration.max_file_size).to eq(max_file_size)
      expect(Heartwood::Uploader.configuration.multipart).to eq(multipart)
      expect(Heartwood::Uploader.configuration.prefix).to eq(prefix)
      expect(Heartwood::Uploader.configuration.form_id).to eq(form_id)
    end

    it 'sets some defaults' do
      Heartwood::Uploader.configuration.acl = nil
      Heartwood::Uploader.configuration.aws_access_key_id = nil
      Heartwood::Uploader.configuration.aws_bucket = nil
      Heartwood::Uploader.configuration.aws_secret_access_key = nil
      Heartwood::Uploader.configuration.expiration = nil
      Heartwood::Uploader.configuration.max_file_size = nil
      Heartwood::Uploader.configuration.multipart = nil
      Heartwood::Uploader.configuration.prefix = nil
      Heartwood::Uploader.configuration.form_id = nil

      expect(Heartwood::Uploader.configuration.acl).to eq('private')
      expect(Heartwood::Uploader.configuration.aws_access_key_id).to eq(nil)
      expect(Heartwood::Uploader.configuration.aws_bucket).to eq(nil)
      expect(Heartwood::Uploader.configuration.aws_secret_access_key).to eq(nil)
      expect(Heartwood::Uploader.configuration.expiration.class).to eq(Time)
      expect(Heartwood::Uploader.configuration.max_file_size).to eq(50.megabytes)
      expect(Heartwood::Uploader.configuration.multipart).to eq(false)
      expect(Heartwood::Uploader.configuration.prefix).to eq(nil)
      expect(Heartwood::Uploader.configuration.form_id).to eq('heartwood-uploader')
    end
  end

  describe '#configure' do
    it 'will take a block to set options' do
      Heartwood::Uploader.configure do |config|
        config.acl = acl
        config.aws_access_key_id = aws_access_key_id
        config.aws_bucket = aws_bucket
        config.aws_secret_access_key = aws_secret_access_key
        config.expiration = expiration
        config.max_file_size = max_file_size
        config.multipart = multipart
        config.prefix = prefix
        config.form_id = form_id
      end

      expect(Heartwood::Uploader.configuration.acl).to eq(acl)
      expect(Heartwood::Uploader.configuration.aws_access_key_id).to eq(aws_access_key_id)
      expect(Heartwood::Uploader.configuration.aws_bucket).to eq(aws_bucket)
      expect(Heartwood::Uploader.configuration.aws_secret_access_key).to eq(aws_secret_access_key)
      expect(Heartwood::Uploader.configuration.expiration).to eq(expiration)
      expect(Heartwood::Uploader.configuration.max_file_size).to eq(max_file_size)
      expect(Heartwood::Uploader.configuration.multipart).to eq(multipart)
      expect(Heartwood::Uploader.configuration.prefix).to eq(prefix)
      expect(Heartwood::Uploader.configuration.form_id).to eq(form_id)
    end
  end

end
