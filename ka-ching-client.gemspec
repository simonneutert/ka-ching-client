# frozen_string_literal: true

require_relative 'lib/ka_ching/version'

Gem::Specification.new do |spec|
  spec.name = 'ka-ching-client'
  spec.version = KaChing::VERSION
  spec.authors = ['Simon Neutert']
  spec.email = ['simonneutert@users.noreply.github.com']

  spec.summary = 'This gem is a client for the ka-ching API.'
  spec.description = 'This gem is a client for the ka-ching API.'
  spec.homepage = 'https://github.com/simonneutert/ka-ching-client'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/simonneutert/ka-ching-client'
  spec.metadata['changelog_uri'] = 'https://github.com/simonneutert/ka-ching-client/ChangeLog.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .github .bundle .vscode
                                                             .circleci appveyor])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '>= 2.7.10', '< 2.14.0'
  spec.add_dependency 'httpx', '>= 1.0.0', '< 1.6.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
