require File.dirname(__FILE__) + '/../spec_helper'

describe AssetManager, ".new" do
	
	before(:each) do
	  @asset_manager = AssetManager.new
	end

  it "should create an empty scripts string" do
    @asset_manager.instance_variable_get(:@scripts).should == ""
  end

	it "should create an empty array for components" do
	  @asset_manager.instance_variable_get(:@components).should be_empty
	  @asset_manager.instance_variable_get(:@components).should be_an_instance_of(Array)
	end
		

end