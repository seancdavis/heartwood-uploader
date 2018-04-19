module Heartwood
  module Uploader
    module Helper

      def heartwood_uploader(options = {})
        form = Form.new(options)
        content_tag(:div, id: form.container_id) do
          heartwood_uploader_form(form) + heartwood_upload_template
        end
      end

      def heartwood_uploader_form(form)
        form_tag(form.url, form.form_options) do
          html = file_field_tag(:file, multiple: form.allow_multiple_files, id: form.field_id)
          form.fields.each { |name, value| html += hidden_field_tag(name, value) }
          html.html_safe
        end
      end

      def heartwood_upload_template
        %{
          <script id="heartwood-uploader-template" type="text/x-tmpl">
            <div class="heartwood-uploader-template">
              {%= o.name %}
              <input type="text" class="heartwood-uploader-file" id="hw-{%= Heartwood.Uploader.currentIndex() %}" name"">
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
