module Yui4Rails
	class AssetManager
		def self.add_script(script)
			@scripts ||= ""
			@scripts << script
		end
		
		def self.scripts
			@scripts
		end
		
	end
end