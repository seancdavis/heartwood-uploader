
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "heartwood/uploader/version"

Gem::Specification.new do |spec|
  spec.name          = "heartwood-uploader"
  spec.version       = Heartwood::Uploader::VERSION
  spec.authors       = ["Sean C Davis"]
  spec.email         = ["scdavis41@gmail.com"]

  spec.summary       = %q{Direct uploader for AWS S3}
  spec.description   = %q{Upload file(s) directly to Amazon S3, with progress bar support.}
  spec.homepage      = "https://github.com/seancdavis/heartwood-uploader"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'faker', '<= 2.0.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.7', '>= 4.7.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'aws-sdk-s3', '~> 1.9'
  spec.add_dependency 'jquery-fileupload-rails', '~> 0.4'
  spec.add_dependency 'rails', '~> 5.1'
end
