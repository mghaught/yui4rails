module Yui4Rails
	class AssetManager
		
		attr_accessor :scripts
		
		def self.reset
			@@manager = nil
		end
		
		def self.manager
			@@manager ||= new
		end
		
		def initialize
			@scripts = ""
			@components = []
		end

		def add_script(script)
			@scripts << script
		end

		def add_components(*components)
			@components << components			
		end

		def stylesheets
			process_components unless @stylesheets
			@stylesheets
		end

		def javascripts
			process_components unless @javascripts
			@javascripts
		end

		
		private
		
		def process_components			
			@yui_stylesheets = []
			@yui_javascript = []
			
			@components.flatten!

			@yui_stylesheets << "reset/reset-min" if @components.include?(:reset)
			@yui_stylesheets << "fonts/fonts-min" if @components.include?(:fonts)
			add_container_includes if @components.include?(:container)
			add_datatable_includes if @components.include?(:datatable)
			add_charts_includes if @components.include?(:charts)
			add_carousel_includes if @components.include?(:carousel)

			@stylesheets = @yui_stylesheets.uniq
			@javascripts = @yui_javascript.uniq
		end
		
		
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
			add_script %{YAHOO.widget.Chart.SWFURL = "/yui/charts/assets/charts.swf";}
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
	end
end