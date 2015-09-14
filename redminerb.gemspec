# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redminerb/version'

Gem::Specification.new do |spec|
  spec.name          = 'redminerb'
  spec.version       = Redminerb::VERSION
  spec.authors       = ['Fernando Garcia Samblas']
  spec.email         = ['fernando.garcia@the-cocktail.com']
  spec.homepage      = 'http://github.com/nando/redminerb'

  spec.summary       = 'Redminerb is a command-line Redmine client.'
  spec.description   = <<-DESC
    Redminerb is a command-line tool to speak with a Redmine server using its REST API.
  DESC

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'TODO: Set to http://gems.the-cocktail.com :)'
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.bindir        = 'exe'
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'thor'
  spec.add_dependency 'faraday'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry'
end
