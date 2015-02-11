# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smugsyncv2/version'

Gem::Specification.new do |spec|
  spec.name          = 'smugsyncv2'
  spec.version       = Smugsyncv2::VERSION
  spec.authors       = ['Andrew Thompson']
  spec.email         = ['netengr2009@gmail.com']
  spec.summary       = %q{API Client for the SmugMug v2 api}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'oauth', '~> 0.4.7'
  spec.add_dependency 'faraday', '~> 0.9.1'
  spec.add_dependency 'faraday_middleware', '~> 0.9.1'
  spec.add_dependency 'simple_oauth', '~> 0.3.1'
  spec.add_dependency 'deepopenstruct', '~> 0.1.2'
  spec.add_dependency 'thor', '~> 0.19.1'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
