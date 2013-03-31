require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet_blacksmith/rake_tasks'

# to fix `Error converting value for param 'modulepath': Could not find value for $confdir`
Puppet[:confdir] = "~/.puppet"

task :default => [:spec, :lint]

