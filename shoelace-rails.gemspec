# frozen_string_literal: true

require_relative "lib/shoelace/rails/version"

Gem::Specification.new do |spec|
  spec.name          = "shoelace-rails"
  spec.version       = Shoelace::Rails::VERSION
  spec.authors       = ["Yuki Nishijima"]
  spec.email         = ["yuki24@hey.com"]

  spec.summary       = "Rails view helpers Shoelace.style, the design system."
  spec.description   = "The shoelace-rails gem adds useful view helper methods for using Shoalace Web Components."
  spec.homepage      = "https://github.com/yuki24/shoelace-rails"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yuki24/shoelace-rails"
  spec.metadata["changelog_uri"]   = "https://github.com/yuki24/shoelace-rails/releases"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A?:test/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "actionview", ">= 5.2.0"
  spec.add_dependency "actionpack", ">= 5.2.0"

  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "minitest", ">= 5.14.4"
  spec.add_development_dependency "rails-dom-testing", ">= 2.2.0"
end
