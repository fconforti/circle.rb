# frozen_string_literal: true

require_relative "lib/circle/version"

Gem::Specification.new do |spec|
  spec.name = "circle-sdk"
  spec.version = Circle::VERSION
  spec.authors = ["Filippo"]
  spec.summary = "Ruby client for Circle Web3 Services API"
  spec.description = "A Ruby SDK for Circle's Web3 Services platform, providing access to " \
                     "developer-controlled wallets, user-controlled wallets, smart contract " \
                     "platform, and more."
  spec.homepage = "https://github.com/filippo/circle-sdk-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.files = Dir["lib/**/*", "LICENSE.txt"]
  spec.require_paths = ["lib"]

  spec.add_dependency "base64"
  spec.add_dependency "faraday", ">= 2.0", "< 3.0"

  spec.metadata["rubygems_mfa_required"] = "true"
end
