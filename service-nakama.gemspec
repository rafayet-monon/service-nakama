# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'service_nakama/version'

Gem::Specification.new do |spec|
  spec.name                        = 'service-nakama'
  spec.version                     = ServiceNakama::VERSION.dup
  spec.authors                     = ['rafayet']
  spec.licenses                    = ['MIT']
  spec.email                       = ['rafayet.monon@gmail.com']
  spec.summary                     = 'Some helping hand for your Service Object'
  spec.description                 = 'Nakama is a japanese word that means Friend.
                                      This gem just adds some helping hand for your
                                      Service Object'
  spec.homepage                    = 'https://github.com/rafayet-monon/service-nakama'
  spec.required_ruby_version       = Gem::Requirement.new('>= 2.3.0')
  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri']   = spec.homepage
  spec.require_paths               = ['lib']
  spec.files                       = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
end
