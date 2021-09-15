# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rism-website-indexer/version"
Gem::Specification.new do |spec|
  spec.name          = "rism-website-indexer"
  spec.summary       = "Markdown indexer"
  spec.description   = "Process content for indexing"
  spec.version       = Jekyll::RismWebsiteIndexer::VERSION
  spec.authors       = ["Laurent Pugin"]
  spec.email         = ["laurent.pugin@rism.digital"]
  spec.homepage      = "https://github.com/rism-digital/rism-website-indexer"
  spec.licenses      = ["MIT"]
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r!^(test|spec|features)/!) }
  spec.require_paths = ["lib"]
  spec.add_dependency "jekyll", "~> 4.1"
  #spec.add_development_dependency "rake", "~> 11.0"
  #spec.add_development_dependency "rspec", "~> 4.5"
  #spec.add_development_dependency "rubocop", "~> 0.41"
end