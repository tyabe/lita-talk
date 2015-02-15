Gem::Specification.new do |spec|
  spec.name          = "lita-talk"
  spec.version       = "0.0.1"
  spec.authors       = ["Takeshi Yabe"]
  spec.email         = ["tyabe@nilidea.com"]
  spec.description   = "A Lita handler that to talk with lita."
  spec.summary       = "A Lita handler that to talk with lita."
  spec.homepage      = "https://github.com/tyabe/lita-talk"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.2"
  spec.add_runtime_dependency "docomoru", ">= 0.0.3"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
