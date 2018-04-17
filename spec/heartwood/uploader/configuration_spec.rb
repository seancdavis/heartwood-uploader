require 'spec_helper'

RSpec.describe Heartwood::Uploader   do

  let(:aws_access_key_id) { Faker::Lorem.sentence }
  let(:aws_bucket) { Faker::Lorem.sentence }
  let(:aws_secret_access_key) { Faker::Lorem.sentence }

  describe '#configuration' do
    it 'allows setting and getting each option' do
      Heartwood::Uploader.configuration.aws_access_key_id = aws_access_key_id
      Heartwood::Uploader.configuration.aws_bucket = aws_bucket
      Heartwood::Uploader.configuration.aws_secret_access_key = aws_secret_access_key

      expect(Heartwood::Uploader.configuration.aws_access_key_id).to eq(aws_access_key_id)
      expect(Heartwood::Uploader.configuration.aws_bucket).to eq(aws_bucket)
      expect(Heartwood::Uploader.configuration.aws_secret_access_key).to eq(aws_secret_access_key)
    end
  end

  describe '#configure' do
    it 'will take a block to set options' do
      Heartwood::Uploader.configure do |config|
        config.aws_access_key_id = aws_access_key_id
        config.aws_bucket = aws_bucket
        config.aws_secret_access_key = aws_secret_access_key
      end

      expect(Heartwood::Uploader.configuration.aws_access_key_id).to eq(aws_access_key_id)
      expect(Heartwood::Uploader.configuration.aws_bucket).to eq(aws_bucket)
      expect(Heartwood::Uploader.configuration.aws_secret_access_key).to eq(aws_secret_access_key)
    end
  end

end
