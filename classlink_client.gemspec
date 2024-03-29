# frozen_string_literal: true

require_relative "lib/classlink_client/version"

Gem::Specification.new do |spec|
  spec.name          = "classlink_client"
  spec.version       = ClasslinkClient::VERSION
  spec.authors       = ["Mike Campbell"]
  spec.email         = ["mike.campbell@cpoms.co.uk"]

  spec.summary       = "Client library for ClassLink's OneRoster API"
  spec.homepage      = "https://github.com/cpoms/classlink_client"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/cpoms/classlink_client"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 5.0.0"
  spec.add_dependency "rack", ">= 2.0.0"
end
