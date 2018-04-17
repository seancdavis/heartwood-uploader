module Heartwood
  module Uploader
    class << self
      attr_writer :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end

    class Configuration
      attr_accessor :acl, # Access control list https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl (default: 'public-read')
                    :aws_access_key_id,
                    :aws_bucket,
                    :aws_secret_access_key,
                    :expiration, # Time after upload to clean up incomplete multipart uploads
                    :max_file_size, # Maximum allowed file size (default: 50MB)
                    :multipart, # Allow multiple file uploads (default: false)
                    :prefix, # Prefix (path) to store the file (default: nil)
                    :form_id # HTML #id selector for form element (default: 'fileupload')

      def acl
        @acl ||= 'public-read'
      end

      def expiration
        @expiration ||= 10.hours.from_now
      end

      def form_id
        @form_id ||= 'heartwood-uploader'
      end

      def max_file_size
        @max_file_size ||= 50.megabytes
      end

      def multipart
        @multipart ||= false
      end

    end
  end
end
