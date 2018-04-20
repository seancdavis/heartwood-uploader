require 'rails'
require 'active_support/core_ext/numeric/bytes'

require 'aws-sdk-s3'
require 'jquery-fileupload-rails'

require 'heartwood/uploader/version'
require 'heartwood/uploader/engine'
require 'heartwood/uploader/railtie'
require 'heartwood/uploader/configuration'

require 'heartwood/uploader/form'
require 'heartwood/uploader/helper'
require 'heartwood/uploader/uploadable'

module Heartwood
  module Uploader
  end
end
