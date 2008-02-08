require 'rake'
# require 'rake/testtask'
require 'rake/rdoctask'
require 'spec/version'
require 'spec/rake/spectask'

desc 'Default: run unit tests.'
task :default => :spec

desc 'Test the yui4rails plugin via spec.'
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--options', 'spec/spec.opts']
  unless ENV['NO_RCOV']
    t.rcov = true
    t.rcov_dir = '../doc/output/coverage'
    t.rcov_opts = ['--exclude', 'spec\/spec,bin\/spec,examples,\/var\/lib\/gems,\/Library\/Ruby,\.autotest']
  end
end

desc 'Generate documentation for the yui4rails plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Yui4rails'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Will install necessary public-accessible resources for YUI integration'
Rake::RDocTask.new(:initialize_yui) do |rdoc|
	# TODO convert to more rake way of doing this...
	RAILS_ROOT = File.join(File.dirname(__FILE__),'../../..')
	destination = File.join(RAILS_ROOT,'public/yui')
	unless File.exists?(destination)
	  source = File.join(File.dirname(__FILE__),'public/yui')
	  FileUtils.mkdir_p(destination)
	  FileUtils.cp_r(Dir.glob(source + '/**'),destination)
	end 
end