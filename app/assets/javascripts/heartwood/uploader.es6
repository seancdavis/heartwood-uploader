//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl

window.Heartwood = window['Heartwood'] || {};

Heartwood.Uploader = class Uploader {

  constructor(el) {
    this.el = el;
    this.init();
  }

  init() {
    $(this.el).fileupload({
      add: this.add,
      progress: this.progress,
      done: this.done,
      fail: this.fail
    })
  }

  add(event, data) {
    data.context = $(tmpl('heartwood-upload-template', data.files[0]));
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
    data.context.find('.success').text('File uploaded successfully.');
    data.context.find('.progress').remove();
    // TODO: This is where configuration needs to happen on what to do next ...
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
