# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shinybooru/version'

Gem::Specification.new do |spec|
  spec.name          = "shinybooru"
  spec.version       = Shinybooru::VERSION
  spec.authors       = ["Calv Collins"]
  spec.email         = ["calvcoll@gmail.com"]

  spec.summary       = %q{API for Gelbooru}
  spec.description   = %q{Provides, hopefully, an easy to use interface for Gelbooru}
  spec.homepage      = "https://github.com/calvcoll/shinybooru"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "http-requestor", ["~> 1.0.4"]
end
