module Yui4Rails
  module IncludeExtension
	  def add_datatable_includes
			@yui_stylesheets << "datatable/assets/skins/sam/datatable"
			@yui_javascript << "utilities/utilities"
			@yui_javascript << "datasource/datasource-beta-min"
			@yui_javascript << "datatable/datatable-beta-min"	
	  end

	  def add_charts_includes
			@yui_javascript << "utilities/utilities"
			@yui_javascript << "datasource/datasource-beta-min"
			@yui_javascript << "json/json-min"
			@yui_javascript << "charts/charts-experimental-min"	
			@yui_script << %{YAHOO.widget.Chart.SWFURL = "/yui/charts/assets/charts.swf";}
	  end
	
		def add_container_includes
			@yui_stylesheets << "container/assets/container"
			@yui_javascript << "yahoo-dom-event/yahoo-dom-event"
			@yui_javascript << "animation/animation-min"
			@yui_javascript << "container/container-min"	
		end
		
		def add_carousel_includes
			@yui_stylesheets << "carousel/assets/carousel"
			@yui_javascript << "yahoo-dom-event/yahoo-dom-event"
			@yui_javascript << "animation/animation-min"
			@yui_javascript << "container/container-min"
			@yui_javascript << "carousel/carousel_min"	
		end
			
		def include_yui(*args)
			@yui_components ||= []
			@yui_components += args
		end
		
		def yui_includes(*args)
			@yui_components ||= []
			@yui_components += args			
			
			@yui_stylesheets = []
			@yui_javascript = []
			@yui_script = []
			yui_includes = [""]
			
			@yui_stylesheets << "reset/reset-min" if @yui_components.include?(:reset)
			@yui_stylesheets << "fonts/fonts-min" if @yui_components.include?(:fonts)
			add_container_includes if @yui_components.include?(:container)
			add_datatable_includes if @yui_components.include?(:datatable)
			add_charts_includes if @yui_components.include?(:charts)
			add_carousel_includes if @yui_components.include?(:carousel)
			
		
			yui_includes << @yui_stylesheets.uniq.map{|ss| stylesheet_link_tag("/yui/#{ss}")}
			yui_includes << @yui_javascript.uniq.map{|js| javascript_include_tag("/yui/#{js}")}
			
			@yui_script << asset_manager.scripts
			appended_yui_script = instance_variable_get("@content_for_yui_script").to_s
			@yui_script << appended_yui_script if appended_yui_script
			unless @yui_script.empty?
				yui_includes << %{<script type="text/javascript" charset="utf-8">}
				yui_includes << @yui_script
				yui_includes << "</script>"
			end			
			yui_includes.flatten.join("\n")
		end
  end
end