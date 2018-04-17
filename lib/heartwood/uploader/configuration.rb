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

      attr_accessor :aws_access_key_id, :aws_bucket, :aws_secret_access_key

    end
  end
end
