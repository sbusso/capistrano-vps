# -*- encoding: utf-8 -*-
require File.expand_path('../lib/capistrano-vps/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Stephane Busso"]
  gem.email         = "stephane.busso@gmail.com"
  gem.date          = %q{2012-04-03}
  gem.description   = %q{keeping vps recipes for ruby application}
  gem.summary       = %q{bootstrap from railscast #335}
  gem.homepage      = "http://activelabs.fr"

  gem.files         = `git ls-files`.split($\)
  # gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  # gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "capistrano-vps"
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency 'capistrano'
  gem.add_runtime_dependency 'capistrano-ext'
  gem.version       = CapistranoVps::VERSION
end
