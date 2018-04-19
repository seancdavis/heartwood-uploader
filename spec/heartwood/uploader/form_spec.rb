require 'spec_helper'

RSpec.describe Heartwood::Uploader::Form do

  let(:form) { Heartwood::Uploader::Form.new }

  before(:each) do
    Heartwood::Uploader.configure do |config|
      config.aws_access_key_id = 'aws_access_key_id'
      config.aws_bucket = 'aws_bucket'
      config.aws_secret_access_key = 'aws_secret_access_key'
    end
  end

  after(:each) do
    Heartwood::Uploader.configure do |config|
      config.aws_access_key_id = nil
      config.aws_bucket = nil
      config.aws_secret_access_key = nil
    end
  end

  describe '#fields' do
    it 'returns key/value pairs for fields' do
      fields = form.fields
      expect(fields[:key]).to eq(form.key)
      expect(fields[:acl]).to eq(form.acl)
      expect(fields[:policy]).to eq(form.send(:policy_data_json))
      expect(fields[:signature]).to eq(form.send(:encoded_signature))
      expect(fields['Content-Type']).to eq(nil)
      expect(fields['AWSAccessKeyId']).to eq(form.aws_access_key_id)
    end
  end

  describe '#form_options' do
    it 'returns key/value pairs for form options' do
      opts = form.form_options
      expect(opts[:id]).to eq('heartwood-uploader')
      expect(opts[:method]).to eq('post')
      expect(opts[:authenticity_token]).to eq(false)
      expect(opts[:multipart]).to eq(false)
      expect(opts[:data][:uploader]).to eq(true)
    end
  end

  describe '#validate_options!' do
    it 'throws an error if aws keys are nil' do
      Heartwood::Uploader.configuration.aws_access_key_id = nil
      expect { Heartwood::Uploader::Form.new }.to raise_error(ArgumentError)

      Heartwood::Uploader.configuration.aws_access_key_id = 'aws_access_key_id'
      Heartwood::Uploader.configuration.aws_bucket = nil
      expect { Heartwood::Uploader::Form.new }.to raise_error(ArgumentError)

      Heartwood::Uploader.configuration.aws_access_key_id = 'aws_access_key_id'
      Heartwood::Uploader.configuration.aws_bucket = 'aws_bucket'
      Heartwood::Uploader.configuration.aws_secret_access_key = nil
      expect { Heartwood::Uploader::Form.new }.to raise_error(ArgumentError)
    end
  end

  describe '#init_options!' do
    it 'sets the url after the options have been set' do
      expect(form.url).to eq('https://aws_bucket.s3.amazonaws.com/')
    end
  end

  describe '#default_options, #initialize, #method_missing' do
    it 'has a set of default options, available as attributes' do
      expect(form.acl).to eq('private')
      expect(form.allow_multiple_files).to eq(false)
      expect(form.aws_access_key_id).to eq('aws_access_key_id')
      expect(form.aws_secret_access_key).to eq('aws_secret_access_key')
      expect(form.bucket).to eq('aws_bucket')
      expect(form.expiration < 10.hours.from_now).to eq(true)
      expect(form.form_id).to eq('heartwood-uploader')
      expect(form.form_method).to eq('post')
      expect(form.key).to eq('${filename}')
      expect(form.max_file_size).to eq(50.megabytes)
      expect(form.template_id.start_with?('hwtmpl-')).to eq(true)
      expect(form.template_container_id.start_with?('hwupl-')).to eq(true)
      expect(form.trigger_id).to eq(nil)
      expect(form.upload_field_id).to eq('heartwood-uploader-file')
      expect(form.url_field_class).to eq('heartwood-uploader-url')
      expect(form.url_field_name).to eq(nil)
    end
    it 'will override options on init' do
      form = Heartwood::Uploader::Form.new(
        acl: '[custom]_acl',
        allow_multiple_files: '[custom]_allow_multiple_files',
        aws_access_key_id: '[custom]_aws_access_key_id',
        aws_secret_access_key: '[custom]_aws_secret_access_key',
        bucket: '[custom]_bucket',
        expiration: '[custom]_expiration',
        form_id: '[custom]_form_id',
        form_method: '[custom]_form_method',
        key: '[custom]_key',
        max_file_size: '[custom]_max_file_size',
        template_id: '[custom]_template_id',
        template_container_id: '[custom]_template_container_id',
        trigger_id: '[custom]_trigger_id',
        upload_field_id: '[custom]_upload_field_id',
        url_field_class: '[custom]_url_field_class',
        url_field_name: '[custom]_url_field_name',
      )
      expect(form.acl).to eq('[custom]_acl')
      expect(form.allow_multiple_files).to eq('[custom]_allow_multiple_files')
      expect(form.aws_access_key_id).to eq('[custom]_aws_access_key_id')
      expect(form.aws_secret_access_key).to eq('[custom]_aws_secret_access_key')
      expect(form.bucket).to eq('[custom]_bucket')
      expect(form.expiration).to eq('[custom]_expiration')
      expect(form.form_id).to eq('[custom]_form_id')
      expect(form.form_method).to eq('[custom]_form_method')
      expect(form.key).to eq('[custom]_key')
      expect(form.max_file_size).to eq('[custom]_max_file_size')
      expect(form.template_id).to eq('[custom]_template_id')
      expect(form.template_container_id).to eq('[custom]_template_container_id')
      expect(form.trigger_id).to eq('[custom]_trigger_id')
      expect(form.upload_field_id).to eq('[custom]_upload_field_id')
      expect(form.url_field_class).to eq('[custom]_url_field_class')
      expect(form.url_field_name).to eq('[custom]_url_field_name')
    end
  end

end
