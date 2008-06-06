require File.dirname(__FILE__) + '/../spec_helper'


describe Yui4Rails::Widgets::Carousel do
	
	before(:each) do
	  @carousel_id = "my_carousel"
		@collection = [1,2,3,4]
	end
	
	describe ".render_head_script" do
		before(:each) do
		  @carousel = Yui4Rails::Widgets::Carousel.new(@carousel_id, @collection)
		end

		it "should register the code as an anonymous function on the page load event" do
			@carousel.render_head_script.should match(/YAHOO\.util\.Event\.addListener\(window, "load", function\(\)/)
		end

	  it "should render a YAHOO.extension.Carousel with our carousel_id" do
	    @carousel.render_head_script.should match(/new YAHOO\.extension\.Carousel\("#{@carousel_id}",/)
	  end

		it "should set the collection size into the size option" do
			@carousel.render_head_script.should match(/size: #{@collection.size},/)
		end

		it "should include default options" do
			@carousel.render_head_script.should match(/numVisible: 3,/)
		end	

		it "should allow defaults to be overridden" do
			@carousel = Yui4Rails::Widgets::Carousel.new(@carousel_id, @collection, {:numVisible => 6})
			@carousel.render_head_script.should match(/numVisible: 6,/)
		end

		it "should allow new options" do
			@carousel = Yui4Rails::Widgets::Carousel.new(@carousel_id, @collection, {:autoPlay => 6000})
			@carousel.render_head_script.should match(/autoPlay: 6000,/)
		end
		
		it "should invoke the Yui4Rails::AssetManager.manager.add_script" do
			@manager = mock("Manager")
			@manager.should_receive(:add_script)
		  Yui4Rails::AssetManager.should_receive(:manager).and_return(@manager)
			@carousel.render_head_script
		end
	end
	
	describe ".new" do
		
		before(:each) do
			Yui4Rails::AssetManager.reset
		  @manager = Yui4Rails::AssetManager.manager
		end
	  it "should populate the AssetManager's script with the carousel's head script" do
			@manager.scripts.should == ""
	    @carousel = Yui4Rails::Widgets::Carousel.new(@carousel_id, @collection)
			@manager.scripts.should match(/new YAHOO\.extension\.Carousel\("#{@carousel_id}",/)
	  end
	end

end
