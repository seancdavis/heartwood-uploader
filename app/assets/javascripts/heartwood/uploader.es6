//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl

window.Heartwood = window['Heartwood'] || {};

Heartwood.Uploader = class Uploader {

  static bumpIndex() {
    if (!this.idx) { this.idx = 0 }
    this.idx += 1;
    return this.currentIndex();
  }

  static currentIndex() {
    if (!this.idx) { this.idx = 0 }
    return this.idx;
  }

  constructor(el) {
    this.el = el;
    this.templateId = $(this.el).data('template-id');
    this.containerId = $(this.el).data('template-container');
    this.init();
  }

  init() {
    $(this.el).fileupload({
      add: (event, data) => { this.add(event, data) },
      progress: (event, data) => { this.progress(event, data) },
      done: (event, data) => { this.done(event, data) },
      fail: (event, data) => { this.fail(event, data) }
    });
    this.bindTrigger();
  }

  add(event, data) {
    data.idx = Heartwood.Uploader.bumpIndex();
    data.context = $(tmpl(this.templateId, data.files[0]));
    $(`#${this.containerId}`).append(data.context);
    data.form.find('#Content-Type').val(data.files[0].type);
    data.submit();
    $(this.el).trigger('heartwood.uploader.begin', data);
  }

  progress(event, data) {
    if (data.context) {
      let progress = parseInt(data.loaded / data.total * 100, 10)
      data.context.find('.progress-bar').css('width', `${progress}%`)
      data.context.find('.progress-value').html(`${progress}%`)
      $(this.el).trigger('heartwood.uploader.progress', data);
    }
  }

  done(event, data) {
    const path = $(this.el).find('#key').val().replace('${filename}', data.files[0].name);
    data.context.find('input[data-url-field]').val(data.url + path);
    data.context.find('.hwupl-success').text('File uploaded successfully.');
    data.context.find('.progress').remove();
    $(this.el).trigger('heartwood.uploader.hwupl-success', data);
  }

  fail(event, data) {
    data.context.find('.hwupl-error').text('There was an error with this upload.');
    data.context.find('.progress').remove();
    $(this.el).trigger('heartwood.uploader.hwupl-error', data);
  }

  bindTrigger() {
    if (!$(this.el).data('trigger')) { return false }
    const input = $(this.el).find('input[type=file]').first();
    input.hide();
    $(`#${$(this.el).data('trigger')}`).click(event => input.trigger('click'));
  }

}

$(document).ready(function() {
  for (form of $('form[data-uploader]')) {
    new Heartwood.Uploader(form);
  }
});
