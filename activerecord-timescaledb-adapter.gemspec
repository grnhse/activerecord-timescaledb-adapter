# frozen_string_literal: true

require_relative "lib/active_record/connection_adapters/timescaledb/version"

Gem::Specification.new do |spec|
  spec.name = "activerecord-timescaledb-adapter"
  spec.version = ActiveRecord::ConnectionAdapters::TimescaleDB::VERSION
  spec.authors = ["Evan Duncan"]
  spec.email = ["evan.duncan@greenhouse.io"]

  spec.summary = "A TimescaleDB adapter"
  spec.description = "The activerecord-timescaledb-adapter provides access to features of the Timescale Postgres extension from ActiveRecord."
  spec.homepage = "https://github.com/grnhse/activerecord-timescaledb-adapter"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"
  spec.platform = Gem::Platform::RUBY

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/grnhse/activerecord-timescaledb-adapter"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.add_dependency "activerecord", "~> 6.0.0"
  spec.add_dependency "activesupport", "~> 6.0.0"
  spec.add_dependency "pg", "~> 1.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "standard", "~> 1.3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "activerecord-nulldb-adapter"
end
