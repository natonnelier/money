
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ruby_money/version"

Gem::Specification.new do |spec|
  spec.name          = "ruby_money"
  spec.version       = Money::VERSION
  spec.authors       = ["Nicolas Tonnelier"]
  spec.email         = ["na.tonnelier@gmail.com"]

  spec.summary       = %q{Simple handling of money and currencies.}
  spec.description   = %q{Make operations and exchange between existent currencies using Money objects.}
  spec.homepage      = "http://rubygems.org/gems/natonnelier/money"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
