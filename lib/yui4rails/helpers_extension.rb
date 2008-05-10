module Yui4Rails
  module HelpersExtension

		def yui_carousel(carousel_id, collection, options = {}, &block)
			asset_manager.add_components :carousel
			carousel = Yui4Rails::Widgets::Carousel.new(carousel_id, collection, options)
			
			concat(%{<div id="#{carousel_id}" class="carousel-component">}, block.binding)
			yield block
			concat("</div>", block.binding)			
		end

  end
end