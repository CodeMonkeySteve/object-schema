require 'bundler'
Bundler.setup

require 'rake'
require 'rake/packagetask'
require 'rspec/core/rake_task'

Rake::PackageTask.new do |pkg|
  pkg.need_zip = pkg.need_tar = false
end

RSpec::Core::RakeTask.new(:spec)

task :default => [:spec, :packe]
