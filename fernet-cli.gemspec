# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fernet/cli/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tom Maher"]
  gem.email         = ["tmaher@pw0n.me"]
  gem.description   = "CLI for Fernet"
  gem.summary       = "Work with Fernet-encrypted files in the command line"
  gem.homepage      = "https://github.com/tmaher/fernet-cli"
  
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "fernet-cli"
  gem.require_paths = ["lib"]
  gem.version       = Fernet::CLI::VERSION

  gem.add_runtime_dependency "fernet", ">= 2.0"
  gem.add_development_dependency "rspec"
end
