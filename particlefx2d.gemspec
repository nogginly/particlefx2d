# frozen_string_literal: true

require_relative 'lib/particlefx2d/version'

Gem::Specification.new do |spec|
  spec.name = 'particlefx2d'
  spec.version = ParticleFX2D::VERSION
  spec.authors = ['nogginly']
  spec.email = ['nogginly@icloud.com']

  spec.summary = '2D particle effects API for use with any Ruby graphics API.'
  spec.homepage = 'https://github.com/nogginly/particlefx2d'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  # no deployment dependencies

  # development
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'yard'
end
