# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paknife/version'

Gem::Specification.new do |spec|
  spec.name          = "paknife"
  spec.version       = Paknife::VERSION
  spec.authors       = ["Masato Ikeda"]
  spec.email         = ["masato.ikeda@gmail.com"]
  spec.summary       = %q{Run knife-solo in parallel}
  spec.description   = %q{Run knife-solo in parallel}
  spec.homepage      = "https://github.com/a2ikm/paknife"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "parallel", "~> 1.3"
  spec.add_dependency "term-ansicolor", "~> 1.3"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
