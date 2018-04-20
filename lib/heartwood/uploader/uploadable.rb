module Heartwood
  module Uploader
    module Uploadable

      def self.included(base)
        base.extend(ClassMethods)
        super
      end

      module ClassMethods

        def uploadable(attr)
          define_method(attr) do
            S3File.new(self, attr)
          end
          define_method("#{attr}?") do
            S3File.new(self, attr).url.present?
          end
        end

      end

      class S3File

        attr_accessor :attr, :obj

        def initialize(obj, attr)
          self.obj = obj
          self.attr = attr
        end

        def url
          uri.to_s
        end

        def key(leading_slash = true)
          leading_slash ? URI.decode(uri.path) : URI.decode(uri.path).sub(%r{^\/}, '')
        end

        def filename
          File.basename(url)
        end

        def presigned_url
          presigner.presigned_url(:get_object, bucket: bucket, key: key(false))
        end

        def reset!
          obj.send("#{attr}_url=", nil)
        end

        def destroy!
          return false if obj.send("#{attr}_url").blank?
          s3_object.delete if s3_object.exists?
          reset!
        end

        private

          def uri
            uri = URI.encode(obj.send("#{attr}_url") || '')
            URI.parse(uri)
          end

          def presigner
            @presigner ||= Aws::S3::Presigner.new
          end

          def bucket
            Heartwood::Uploader.configuration.aws_bucket
          end

          def s3_object
            Aws::S3::Object.new(bucket: bucket, key: key(false))
          end

      end

    end
  end
end
