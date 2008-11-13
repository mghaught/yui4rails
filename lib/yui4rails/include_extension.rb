module Yui4Rails
  module IncludeExtension
			
		def asset_manager
			Yui4Rails::AssetManager.manager
		end
					
		def include_yui(*args)
			asset_manager.add_components(args)	
		end
		
		def yui_includes(*args)
			asset_manager.add_components(args)		
			
			yui_includes = [""]
			yui_includes << asset_manager.stylesheets.map{|ss| stylesheet_link_tag("/yui/#{ss}")}
			yui_includes << asset_manager.javascripts.map{|js| javascript_include_tag("/yui/#{js}")}
			
			yui_script = []
			yui_script << asset_manager.scripts
			content_for_script = instance_variable_get("@content_for_yui_script").to_s
			yui_script << content_for_script if content_for_script
			unless yui_script.empty?
				yui_includes << %{<script type="text/javascript" charset="utf-8">}
				yui_includes << yui_script
				yui_includes << "</script>"
			end
			yui_includes.flatten.join("\n")	
		end
  end
end
