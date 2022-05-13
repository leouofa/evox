
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "evox/version"

Gem::Specification.new do |spec|
  spec.name          = "evox"
  spec.version       = Evox::VERSION
  spec.authors       = ["Leonid Medovyy"]
  spec.email         = ["leonid@storypro.io"]

  spec.summary       = "A rugged songbook generator"
  spec.homepage      = "https://github.com/realstorypro/evox"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = "evox"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "byebug"
  spec.add_dependency "commander"
  spec.add_dependency "prawn"
end
