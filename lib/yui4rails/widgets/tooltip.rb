module Yui4Rails
	module Widgets
	  class Tooltip
	    def initialize(tooltip_id, options = {})	
				@tooltip_id = tooltip_id
				@options = defaults.merge(options)
				@options[:context] = tooltip_id
				
				Yui4Rails::AssetManager.manager.add_components :tooltip
	    end
	
			def render
				%{new YAHOO.widget.Tooltip("#{@tooltip_id}_tt", {#{@options.keys.map{|key| optional_value(key)}.join(", ")}});}
			end
	
			private
			def defaults
				{
					:showDelay => 200,
					:width => "320px"
				}
			end
			
			def optional_value(option, option_key = nil)
				option_key ||= option
				if @options.has_key?(option) && !@options[option].nil? 
					%\#{option_key}: #{@options[option].is_a?(String) ? "\"#{@options[option]}\"" : @options[option] }\
				else
					""
				end	
			end
	  end
	end
end