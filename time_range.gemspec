# frozen_string_literal: true

require_relative "lib/time_range/version"

Gem::Specification.new do |spec|
  spec.name = "time_range"
  spec.version = TimeRange::VERSION
  spec.authors = ["Michael G. Schwern"]
  spec.email = ["schwern@pobox.com"]

  spec.summary = "Range over Times stepping by time intervals."
  spec.description = "Easy iterating over various periods of time."
  spec.homepage = "https://github.com/schwern/ruby-time_range"
  spec.required_ruby_version = ">= 2.7"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/schwern/ruby-time_range"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.metadata['rubygems_mfa_required'] = 'true'
end
