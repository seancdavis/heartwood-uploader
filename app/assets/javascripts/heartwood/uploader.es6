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
    this.init();
  }

  init() {
    $(this.el).fileupload({
      add: (event, data) => { this.add(event, data) },
      progress: (event, data) => { this.progress(event, data) },
      done: (event, data) => { this.done(event, data) },
      fail: (event, data) => { this.fail(event, data) }
    })
  }

  add(event, data) {
    data.idx = Heartwood.Uploader.bumpIndex();
    data.context = $(tmpl('heartwood-uploader-template', data.files[0]));
    $('#heartwood-uploader-container').append(data.context);
    data.form.find('#Content-Type').val(data.files[0].type);
    data.submit();
  }

  progress(event, data) {
    if (data.context) {
      let progress = parseInt(data.loaded / data.total * 100, 10)
      data.context.find('.progress-bar').css('width', `${progress}%`)
      data.context.find('.progress-value').html(`${progress}%`)
    }
  }

  done(event, data) {
    const path = $(this.el).find('#key').val().replace('${filename}', data.files[0].name);
    data.context.find('.heartwood-uploader-file').val(data.url + path);
    data.context.find('.success').text('File uploaded successfully.');
    data.context.find('.progress').remove();
  }

  fail(event, data) {
    data.context.find('.error').text('There was an error with this upload.');
    data.context.find('.progress').remove();
  }

}

$(document).ready(function() {
  for (form of $('form[data-uploader]')) {
    new Heartwood.Uploader(form);
  }
});
