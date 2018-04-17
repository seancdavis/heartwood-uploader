module Heartwood
  module Uploader
    class Form

      attr_accessor :options

      def initialize(options = {})
        @options = options.deep_symbolize_keys.reverse_merge(default_options)
        init_options!
      end

      def fields
        {}
      end

      def form_options
        {}
      end

      def method_missing(method_name, *args, &block)
        super unless options.keys.include?(method_name.to_sym)
        options[method_name.to_sym]
      end

      def respond_to?(method_name, include_all = false)
        super || options.keys.include?(method_name.to_sym)
      end

      private

      def init_options!
        @options.merge!(
          url: "https://#{bucket}.s3.amazonaws.com/"
        )
      end

      def default_options
        {
          bucket: Heartwood::Uploader.configuration.aws_bucket
        }
      end

    end
  end
end
