module Yui4Rails
  module HelpersExtension

		def yui_carousel(carousel_id, collection, options = {}, &block)
			Yui4Rails::Widgets::Carousel.new(carousel_id, collection, options)
			
			concat(%{<div id="#{carousel_id}" class="carousel-component">}, proc.binding)
			yield proc
			concat("</div>", proc.binding)			
		end

  end
end