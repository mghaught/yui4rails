require File.dirname(__FILE__) + '/../spec_helper'

module AppMock
	def stylesheet_link_tag(stylesheet)
		"ss=#{stylesheet}"
	end
	
	def javascript_include_tag(javascript)
		"js=#{javascript}"
	end
end

describe Yui4Rails::IncludeExtension, ".asset_manager" do
	
	it "should return AssetManager.manager's output" do
		@output = "Rabbit don't come easy"
		Yui4Rails::AssetManager.should_receive(:manager).and_return(@output)
		self.asset_manager.should == @output
	end
end

describe Yui4Rails::IncludeExtension, ".include_yui" do
	
	it "should invoke asset_manager.add_components with an array of its args" do
		@args = "some pig"
		@asset_manager = mock("AssetManager")
		@asset_manager.should_receive(:add_components).with([@args])
	  self.should_receive(:asset_manager).and_return(@asset_manager)
		self.include_yui(@args)
	end
end

describe Yui4Rails::IncludeExtension, ".yui_includes" do
	include AppMock
	
	before(:each) do
		@stylesheets = %w{ss1 ss2}
		@javascripts = %w{js1 js2}
		@scripts = %w{scr_go line scr_end}
		
	  @asset_manager = mock("AssetManager", :stylesheets => @stylesheets, :javascripts => @javascripts, :scripts => @scripts,
													:add_components => nil)
		self.stub!(:asset_manager).and_return(@asset_manager)	

		@args = "terrific"
	end
	
	it "should invoke asset_manager.add_components with an array of its args" do
		@asset_manager.should_receive(:add_components).with([@args])
		self.yui_includes(@args)
	end	
	
	it "should use the asset_manager's stylesheets method with the stylesheet_link_tag" do
		@asset_manager.should_receive(:stylesheets).and_return(@stylesheets)
		
		@output = self.yui_includes
		@output.should match(/ss=\/yui\/ss1/)
		@output.should match(/ss=\/yui\/ss2/)
	end	
	
	it "should use the asset_manager's javascripts method with the javascript_include_tag" do
		@asset_manager.should_receive(:javascripts).and_return(@javascripts)
		
		@output = self.yui_includes
		@output.should match(/js=\/yui\/js1/)
		@output.should match(/js=\/yui\/js2/)
	end
	
	it "should add the asset_manager's scripts content to the script tag" do
		@asset_manager.should_receive(:scripts).and_return("my script content")
		@output = self.yui_includes
		@output.should match(/my script content/)
	end
	
	it "should add the template's content_for_yui_script to the script tag" do
		self.should_receive(:instance_variable_get).with("@content_for_yui_script").and_return("my yui script")
		@output = self.yui_includes
		@output.should match(/my yui script/)		
	end
end


