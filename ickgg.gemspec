# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ickgg/version'

Gem::Specification.new do |spec|
  spec.name          = "ickgg"
  spec.version       = Ickgg::VERSION
  spec.authors       = ["Evan Sue"]
  spec.email         = ["evan.su@i-click.com"]
  spec.summary       = %q{Create grape on goliath scaffold for 'Tracking'}
  spec.description   = %q{Quickly create Tracking project}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_runtime_dependency "thor",'~> 0.19'
  spec.add_runtime_dependency "activesupport", '~> 3.2'
  spec.add_runtime_dependency "rake", '~> 0'
  spec.add_runtime_dependency "pry", '~> 0'
  spec.add_runtime_dependency "awesome_print", '~> 0'
end
