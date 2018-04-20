Heartwood::Uploader
==========

Heartwood's uploader gem provides a simple DSL for uploading assets directly to Amazon S3.

Installation
----------

Add this line to your application's Gemfile:

```ruby
gem 'heartwood-uploader'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heartwood-uploader

Usage
----------

Heartwood's Uploader uses a combination of a helper method and some JavaScript to build a form that will upload on the fly, with a progress bar. There are four main components to be familiar with:

1. Configuration
2. Helper Method (i.e. the upload form)
3. JavaScript Events
4. Model Concern

Let's take a look at each of these.

### 01: AWS S3 Configuration

Only S3 is supported at the moment, and your credentials can be configured prior to instantiating the helper method. Place the following in `config/initializers/heartwood.rb` (or any other config initializer):

```ruby
Heartwood::Uploader.configure do |config|
  config.aws_access_key_id = 'your_aws_access_key'
  config.aws_bucket = 'aws_bucket'
  config.aws_secret_access_key = 'aws_secret_access_key'
end
```

Change the values here to match your credentials. And remember to **never commit secret keys to git.** I prefer the [dotenv gem](https://github.com/bkeepers/dotenv) for storing sensitive values (which can be used in combination with Rails' secrets).

#### S3 Bucket Configuration

For the uploader to work properly, we need proper access via CORS configuration on your bucket. **You should lock this down to the applicable domain(s)**. In development, that may look like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
<CORSRule>
    <AllowedOrigin>http://locahost:3000</AllowedOrigin>
    <AllowedMethod>POST</AllowedMethod>
    <AllowedHeader>*</AllowedHeader>
</CORSRule>
</CORSConfiguration>
```

Change the `AllowedOrigin` to the appropriate domain. (Hint: I tend to use separate buckets for development and production so I can more tightly control the CORS configuration. It also makes asset management cleaner.)

### 02: Helper Method

First, make sure you are are loading the JavaScript file. This is using ES6, so for the time being add the following to your `Gemfile`:

```ruby
gem 'babel-transpiler'
gem 'sprockets', '4.0.0.beta7'
```

Then you can load the script in `app/assets/javascripts/application.js`:

```js
//= require jquery
//= require heartwood/uploader
```

Note that this gem requires jQuery because it relies on [jQuery File Upload](https://github.com/blueimp/jQuery-File-Upload). You can use the [`jquery-rails`](https://github.com/rails/jquery-rails) gem for easy loading.

Then, if your AWS credentials are set, all you need to do is add the helper method and it will _just work:_

```erb
<%= heartwood_uploader %>
```

This will render a file upload button and after you select a file, it will show a progress bar and success or failure of the upload.

If successful, the URL of the uploaded file will be placed in a hidden field within the upload template. Its class is `.heartwood-uploader-file` and its ID is random.

(Note: The markup is built to work with Bootstrap 4.)

**GOTCHA! This does not currently play well with Turbolinks.**

#### Options

You can pass in a hash of options to the helper method to customize your uploader. (Every "required" option has a default value, so there are no required arguments in essence. However, AWS credentials must be set, as shown above.)

| Option | Default | Description |
| ------ | ------- | ----------- |
| `acl` | `'private'` | Canned S3 Access Control List. [See more here.](https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl) |
| `allow_multiple_files` | `false` | Allow multiple files to be uploaded at once. In this case a template (including input field) will be rendered for each. |
| `aws_access_key_id` | `Heartwood::Uploader.configuration.aws_access_key_id` | Override default (or set) AWS access key ID. |
| `aws_secret_access_key` | `Heartwood::Uploader.configuration.aws_secret_access_key` | Override default (or set) AWS secret access key. |
| `bucket` | `Heartwood::Uploader.configuration.aws_bucket` | Override default (or set) AWS S3 bucket. |
| `expiration` | `10.hours.from_now` | When to clean up unfinished multipart upload (only applies if `allow_multiple_files` is `true`). |
| `form_id` | `'heartwood-uploader'` | ID for the upload form. It is recommended you manually set this when you have more than one uploader on a page. |
| `form_method` | `'post'` | The request method. There is typically no need to change this. |
| `key` | `'${filename}'` | Path to the uploaded file in the S3 bucket. Note that you must include `${filename}` or all your files will have the same name. |
| `max_file_size` | `50.megabytes` | Maximium allowed upload size. |
| `template_id` | `"hwtmpl-#{SecureRandom.hex(6)}"` | ID for the JavaScript template that generates the progress bar and URL field. |
| `template_container_id` | `"hwupl-#{SecureRandom.hex(6)}"` | ID for the container in which to drop the upload template. This is handy if you want the field to be part of a form. |
| `trigger_id` | `nil` | ID for a custom button or link that will trigger the browser's file chooser. If set, this will also hide the default file chooser. |
| `upload_field_id` | `'heartwood-uploader-file'` | ID of the input file field (the field that gets uploaded to S3). |
| `url_field_class` | `'heartwood-uploader-url'` | Class for the input field in the template containing the URL of the successful upload. |
| `url_field_name` | `nil` | Name for the input field in the template containing the URL of the successful upload. Usually, this is used in conjunction with `template_container_id` to place the field in a custom form. |

### 03: JavaScript Events

There are four custom events fired on the jQuery object representing the form. Each event sends the Event object as the first argument and the upload data object for the second.

| Event | Description |
| ------ | ----------- |
| `heartwood.uploader.begin` | Begin an upload |
| `heartwood.uploader.progress` | Progress is made on the upload |
| `heartwood.uploader.success` | Upload was successful |
| `heartwood.uploader.fail` | Upload was not successful |

Here's an example:

```html
<%= heartwood_uploader form_id: 'my-uploader' %>

<script>
$(document).ready(function() {
  $('#my-uploader').on('heartwood.uploader.begin', (event, data) => console.log('begin'));
  $('#my-uploader').on('heartwood.uploader.progress', (event, data) => console.log('progress'));
  $('#my-uploader').on('heartwood.uploader.success', (event, data) => console.log('success'));
  $('#my-uploader').on('heartwood.uploader.fail', (event, data) => console.log('fail'));
});
</script>
```

### 04: Model Concern

The model concern can really come in handy for working with Rails models. To use the concern, include it in your model:

```ruby
class User < ActiveRecord::Base
  include Heartwood::Uploader::Uploadable
end
```

And then you can use the `uploadable` method to set the uploadable config for your class. **Note: Uploadable assumes you have an attribute ending in `_url` to represent the uploadable attribute.** For example, if you set `uploadable :image`, then you should have an `image_url` attribute on your model (and it should be a string).

```ruby
class User < ActiveRecord::Base
  include Heartwood::Uploader::Uploadable

  uploadable :avatar # assumes there is an "avatar_url" column
end
```

At that point there are several methods you can take advantage of through the uploadable object.

```ruby
user = User.new
# => #<User: ...>

user.avatar_url = 'https://some.url/somepath/tomyfile.png'
# => 'https://some.url/somepath/tomyfile.png'

user.avatar
# => #<Heartwood::Uploader::Uploadable::S3File: ...>

user.avatar.url
# => 'https://some.url/somepath/tomyfile.png'

user.avatar.key
# => '/somepath/tomyfile.png'

user.avatar.key(false) # argument is whether or not to include leading slash
# => 'somepath/tomyfile.png'

user.avatar.filename
# => 'tomyfile.png'

user.avatar.presigned_url # Necessary if using "private" as the ACL
# => really long url ...

user.avatar.reset!
# => Reset the "avatar_url" to nil (does not save to database)

user.avatar.destroy!
# => Deletes the file from S3 and then runs `reset!`
```

Development
----------

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Contributing
----------

Bug reports and pull requests are welcome on GitHub at https://github.com/seancdavis/heartwood-uploader. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

License
----------

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

Code of Conduct
----------

Everyone interacting in the Heartwood::Uploader project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/seancdavis/heartwood-uploader/blob/master/CODE_OF_CONDUCT.md).
