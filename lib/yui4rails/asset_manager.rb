module Yui4Rails
	class AssetManager
		
		attr_accessor :scripts

		def initialize
			@scripts = ""
		end

		def add_script(script)
			@scripts << script
		end

	end
end