# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gmail_cli/version'

Gem::Specification.new do |spec|
  spec.name          = "gmail_cli"
  spec.version       = GmailCli::VERSION
  spec.authors       = ["Paul Gallagher"]
  spec.email         = ["gallagher.paul@gmail.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency(%q<bundler>, ["> 1.3"])
  spec.add_development_dependency(%q<rake>, ["~> 0.9.2.2"])
  spec.add_development_dependency(%q<rspec>, ["~> 2.13.0"])
  spec.add_development_dependency(%q<rdoc>, ["~> 3.11"])
  spec.add_development_dependency(%q<guard-rspec>, ["~> 3.0.2"])
  spec.add_development_dependency(%q<rb-fsevent>, ["~> 0.9.3"])

end
