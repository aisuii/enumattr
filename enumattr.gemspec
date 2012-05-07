# -*- encoding: utf-8 -*-
require File.expand_path('../lib/enumattr/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["aisuii"]
  gem.email         = ["aisuiiaisuii@gmail.com"]
  gem.description   = %q{simple enum}
  gem.summary       = %q{manage constants by enum like object}
  gem.homepage      = "https://github.com/aisuii/enumattr"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "enumattr"
  gem.require_paths = ["lib"]
  gem.version       = Enumattr::VERSION

  gem.add_development_dependency('rspec')
end
