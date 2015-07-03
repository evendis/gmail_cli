require "bundler/gem_tasks"
require 'rspec'
require 'rspec/core/rake_task'
require 'gmail_cli/tasks'

desc "Run all test examples"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ["-c", "-f progress"]
  t.pattern = 'spec/**/*_spec.rb'
end

task :default => :spec

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r gmail_cli.rb"
end
