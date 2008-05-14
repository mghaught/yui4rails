namespace :yui4rails do
	desc "Will install or update necessary public-accessible resources for YUI integration"
	task :update => :environment do
		plugin_root = File.join(File.dirname(__FILE__),'..')
	  is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
	  Dir[plugin_root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
	    path = file.sub(plugin_root, '')
	    directory = File.dirname(path)
	    puts "Copying #{path}..."
	    mkdir_p RAILS_ROOT + directory
	    cp file, RAILS_ROOT + path
	  end
	end
end
