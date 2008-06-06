require File.dirname(__FILE__) + '/../spec_helper'


describe Yui4Rails::Widgets::Tooltip do
	
	before(:each) do
		Yui4Rails::AssetManager.reset
	  @tooltip_id = "my_tooltip"
		@text = "Informative tip text"
	end
	
	describe ".render" do
		before(:each) do
		  @tooltip = Yui4Rails::Widgets::Tooltip.new(@tooltip_id, :text => @text)
		end

		it "should construct a YUI tooltip object" do
			@tooltip.render.should match(/new YAHOO\.widget\.Tooltip\("#{@tooltip_id}_tt",/)
		end
	end
	
	describe ".new" do
		
		before(:each) do
		  @manager = Yui4Rails::AssetManager.manager
		end
	  it "should populate the AssetManager's script with the tooltip's head script" do
			@manager.should_receive(:add_components).with(:container)
	    @tooltip = Yui4Rails::Widgets::Tooltip.new(@tooltip_id)
	  end
	end

end
