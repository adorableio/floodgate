# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'floodgate/version'

Gem::Specification.new do |spec|
  spec.name          = 'floodgate'
  spec.version       = Floodgate::VERSION
  spec.authors       = ['Mark McEahern', 'Jim Remsik']
  spec.email         = ['mark@adorable.io', 'jim@adorable.io']
  spec.description   = %q{floodgate helps you control access to your app}
  spec.summary       = %q{floodgate helps you control access to your app}
  spec.homepage      = 'http://github.com/adorableio/floodgate'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14'
end
