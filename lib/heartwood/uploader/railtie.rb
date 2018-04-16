module Heartwood
  module Uploader
    class Railtie < Rails::Railtie

      initializer 'heartwood-uploader.view_helpers' do
        ActiveSupport.on_load(:action_view) { include Heartwood::Uploader::Helper }
      end

    end
  end
end
