module Yui4Rails
  module HelpersExtension

		def carousel(carousel_id, collection, options = {})
			Yui4Rails::Widgets::Carousel.new(carousel_id, collection, options).render
		end
  end
end