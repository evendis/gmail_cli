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

  spec.add_runtime_dependency(%q<getoptions>, ["~> 0.3"])
  spec.add_runtime_dependency(%q<gmail_xoauth>, ["~> 0.4.1"])
  spec.add_runtime_dependency(%q<google-api-client>, ["~> 0.6.4"])

  spec.add_development_dependency(%q<bundler>, ["> 1.3"])
  spec.add_development_dependency(%q<rake>, ["~> 0.9.2.2"])
  spec.add_development_dependency(%q<rspec>, ["~> 2.13.0"])
  spec.add_development_dependency(%q<rdoc>, ["~> 3.11"])
  spec.add_development_dependency(%q<guard-rspec>, ["~> 3.0.2"])
  spec.add_development_dependency(%q<rb-fsevent>, ["~> 0.9.3"])

end
