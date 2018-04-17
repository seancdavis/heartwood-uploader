module Heartwood
  module Uploader
    module Helper

      def heartwood_uploader(options = {})
        # Heartwood::Uploader::Form.html(options)
        form = Form.new(options)

        form_tag(form.url, form.form_options) do
          form.fields.map { |name, value| hidden_field_tag(name, value) }.join.html_safe
        end
      end

    end
  end
end
