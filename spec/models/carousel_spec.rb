require File.dirname(__FILE__) + '/../spec_helper'


describe Yui4Rails::Widgets::Carousel do
	
	before(:each) do
		@carousel_id = "my_carousel"
		@collection = [1,2,3,4]
	  @carousel = Yui4Rails::Widgets::Carousel.new(@carousel_id, @collection)
	end
	
	it "should register the code as an anonymous function on the page load event" do
		@carousel.render.should match(/YAHOO\.util\.Event\.addListener\(window, "load", function\(\)/)
	end
	
  it "should render a YAHOO.extension.Carousel with our carousel_id" do
    @carousel.render.should match(/new YAHOO\.extension\.Carousel\("#{@carousel_id}",/)
  end

	it "should set the collection size into the size option" do
		@carousel.render.should match(/size: #{@collection.size},/)
	end
	
	it "should include default options" do
		@carousel.render.should match(/numVisible: 3,/)
	end	

	it "should allow defaults to be overridden" do
		@carousel = Yui4Rails::Widgets::Carousel.new(@carousel_id, @collection, {:numVisible => 6})
		@carousel.render.should match(/numVisible: 6,/)
	end

	it "should allow new options" do
		@carousel = Yui4Rails::Widgets::Carousel.new(@carousel_id, @collection, {:autoPlay => 6000})
		@carousel.render.should match(/autoPlay: 6000,/)
	end
end
