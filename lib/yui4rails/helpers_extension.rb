module Yui4Rails
  module HelpersExtension

		def asset_manager
			@yui_asset_manager ||= Yui4Rails::AssetManager.new
		end

		def yui_carousel(carousel_id, collection, options = {}, &block)
			include_yui :carousel
			carousel = Yui4Rails::Widgets::Carousel.new(carousel_id, collection, options)
			carousel.render_head_script(asset_manager)
			
			concat(%{<div id="#{carousel_id}" class="carousel-component">}, block.binding)
			yield block
			concat("</div>", block.binding)			
		end

  end
end