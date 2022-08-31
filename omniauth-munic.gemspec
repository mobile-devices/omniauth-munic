# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-munic/version'

Gem::Specification.new do |spec|
    spec.add_dependency "omniauth",   ">= 1.9", "< 3.0"
    spec.add_dependency "omniauth-oauth2", "~> 1.7"

    spec.name          = "omniauth-munic"
    spec.version       = OmniAuth::Munic::VERSION
    spec.authors       = ["maxime dufay"]
    spec.email         = ["maxime.dufay@mobile-devices.fr"]

    spec.description   = "The Munic OAuth2 strategy for OmniAuth 1.x."
    spec.summary       = spec.description
    spec.homepage      = "http://gitlab.mobile-intra.com/maxime-dufay/omniauth-munic"
    spec.license       = "MIT"

    spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
    spec.bindir        = "exe"
    spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
    spec.require_paths = ["lib"]

    spec.add_development_dependency "bundler", "~> 2.1"
    spec.add_development_dependency "rake", "~> 13.0"
end
