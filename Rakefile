require 'rake'
require 'rake/rdoctask'
require 'spec/version'
require 'spec/rake/spectask'

desc 'Default: run plugin specs'
task :default => :spec

desc 'Test the yui4rails plugin via rspec.'
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--options', 'spec/spec.opts']
end

desc 'Generate documentation for the yui4rails plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Yui4rails'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

