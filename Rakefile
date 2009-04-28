require 'rake'
require 'rake/gempackagetask'
require 'rake/testtask'
require 'rake/clean'
 
gem_spec_file = 'rack_locale.gemspec'
gem_spec = eval(File.read(gem_spec_file))

task :default => :test
 
Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end
 
Rake::GemPackageTask.new(gem_spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
  rm_f FileList['pkg/**/*.*']
end if gem_spec
 
desc "Builds and installs the gem."
task :install => :repackage do
  `sudo gem install pkg/#{gem_spec.name}-#{gem_spec.version}.gem`
end