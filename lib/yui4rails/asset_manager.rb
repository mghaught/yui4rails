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
			@components.uniq!

			@yui_stylesheets << "reset/reset-min" if @components.include?(:reset)
			@yui_stylesheets << "fonts/fonts-min" if @components.include?(:fonts)

			@components.each{ |c| add_component(c) }
			
			add_datatable_includes if @components.include?(:datatable)
			add_charts_includes if @components.include?(:charts)
			add_carousel_includes if @components.include?(:carousel)

			@stylesheets = @yui_stylesheets.flatten.uniq
			@javascripts = @yui_javascript.flatten.uniq
		end
		
		
	  def add_datatable_includes
			@yui_stylesheets << "datatable/assets/skins/sam/datatable"
			@yui_javascript << "utilities/utilities"
			@yui_javascript << "datasource/datasource-min"
			@yui_javascript << "datatable/datatable-min"	
	  end

	  def add_charts_includes
			@yui_javascript << "utilities/utilities"
			@yui_javascript << "yahoo-dom-event/yahoo-dom-event"
			@yui_javascript << "json/json-min"
      @yui_javascript << "element/element-beta-min.js"
			@yui_javascript << "datasource/datasource-min"
			@yui_javascript << "charts/charts-experimental-min"	
			add_script %{YAHOO.widget.Chart.SWFURL = "/yui/charts/assets/charts.swf";}
	  end
		
		def add_carousel_includes
			@yui_stylesheets << "carousel/assets/carousel"
			@yui_javascript << "yahoo-dom-event/yahoo-dom-event"
			@yui_javascript << "animation/animation-min"
			@yui_javascript << "container/container-min"
			@yui_javascript << "carousel/carousel_min"	
		end		
		
		def add_component(component)
			return false unless COMPONENTS.has_key?(component)
			
			@yui_stylesheets << COMPONENTS[component][:css] if COMPONENTS[component].has_key?(:css)
			@yui_javascript << COMPONENTS[component][:js] if COMPONENTS[component].has_key?(:js)
			true
		end
		
		COMPONENTS = {
			:panel => {
				:css => ["container/assets/skins/sam/container"],
				:js => ["yahoo-dom-event/yahoo-dom-event", "animation/animation-min", "container/container-min"]
			},
			:tooltip => {
				:css => ["container/assets/container"],
				:js => ["yahoo-dom-event/yahoo-dom-event", "animation/animation-min", "container/container-min"]
			}
		}
	end
end
