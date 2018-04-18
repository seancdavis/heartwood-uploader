module Heartwood
  module Uploader
    module Helper

      def heartwood_uploader(options = {})
        form = Form.new(options)
        content_tag(:div, id: 'heartwood-uploader-container') do
          heartwood_uploader_form(form) + heartwood_upload_template
        end
      end

      def heartwood_uploader_form(form)
        form_tag(form.url, form.form_options) do
          html = file_field_tag(:file, multiple: false, id: 'heartwood-uploader-file')
          form.fields.each { |name, value| html += hidden_field_tag(name, value) }
          html.html_safe
        end
      end

      def heartwood_upload_template
        %{
          <script id="heartwood-upload-template" type="text/x-tmpl">
            <div class="heartwood-upload-template">
              {%= o.name %}
              <div class="progress">
                <div class="progress-bar">
                  <span class="progress-value"></span>
                </div>
              </div>
              <p class="error text-danger"></p>
              <p class="success text-success"></p>
            </div>
          </script>
        }.html_safe
      end

    end
  end
end
