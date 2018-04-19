module Heartwood
  module Uploader
    module Helper

      def heartwood_uploader(options = {})
        form = Form.new(options)
        _hwupl_form(form) + _hwupl_tmpl_container(form) + _hwupl_tmpl_script(form)
      end

      def _hwupl_form(form)
        form_tag(form.url, form.form_options) do
          html = file_field_tag(:file, multiple: form.allow_multiple_files, id: form.field_id)
          form.fields.each { |name, value| html += hidden_field_tag(name, value) }
          html.html_safe
        end
      end

      def _hwupl_tmpl_container(form)
        content_tag(:div, nil, id: form.template_container_id)
      end

      def _hwupl_tmpl_script(_form)
        %{
          <script id="heartwood-uploader-template" type="text/x-tmpl">
            <div class="heartwood-uploader-template">
              {%= o.name %}
              <input type="hidden" class="heartwood-uploader-file" id="hw-{%= Heartwood.Uploader.currentIndex() %}" name"">
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
