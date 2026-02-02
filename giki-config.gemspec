require_relative 'lib/giki_config/version'

Gem::Specification.new do |spec|
  spec.name          = 'giki-config'
  spec.version       = GikiConfig::VERSION
  spec.authors       = ['Jeremy Walker']
  spec.email         = ['jez.walker@gmail.com']

  spec.summary       = 'Retrieves stored config for Giki'
  spec.homepage      = 'https://giki.earth'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.2.1')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/gikiUK/config'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = %w[
    setup_giki_config
    setup_giki_local_aws
  ]
  spec.require_paths = ["lib"]

  spec.add_dependency 'aws-sdk-dynamodb', '~> 1.0'
  spec.add_dependency 'aws-sdk-secretsmanager', '~> 1.0'
  spec.add_dependency 'mandate'
  spec.add_dependency 'ostruct'
  spec.add_dependency 'rexml'
  spec.add_dependency 'zeitwerk'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'rake', '~> 12.3'

  # Optional AWS service dependencies
  spec.add_development_dependency 'aws-sdk-s3'
  spec.add_development_dependency 'aws-sdk-sesv2'
end
