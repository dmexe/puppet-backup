source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_GEM_VERSION') ? "~> #{ENV['PUPPET_GEM_VERSION']}" : '~> 3.2.0'

gem 'rake'
gem 'puppet', puppetversion
gem 'puppet-lint'
gem 'puppetlabs_spec_helper'
gem 'rspec-system-puppet'

group :development do
  gem 'puppet-blacksmith'
end
