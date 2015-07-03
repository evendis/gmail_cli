# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gmail_cli/version'

Gem::Specification.new do |spec|
  spec.name          = "gmail_cli"
  spec.version       = GmailCli::VERSION
  spec.authors       = ["Paul Gallagher"]
  spec.email         = ["gallagher.paul@gmail.com"]
  spec.description   = %q{A simple toolbox for build utilities that talk to Gmail with OAuth2}
  spec.summary       = %q{GmailCli packages the key tools and adds a sprinkling of goodness to make it just that much easier to write primarily command-line utilities for Gmail/GoogleApps}
  spec.homepage      = "https://github.com/evendis/gmail_cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'getoptions', "~> 0.3"
  spec.add_runtime_dependency 'gmail_xoauth', "~> 0.4.1"
  spec.add_runtime_dependency 'google-api-client', "~> 0.7"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard-rspec"

end
