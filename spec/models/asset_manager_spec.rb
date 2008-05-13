require File.dirname(__FILE__) + '/../spec_helper'

describe Yui4Rails::AssetManager, ".new" do
	
	before(:each) do
	  @asset_manager = Yui4Rails::AssetManager.new
	end

  it "should create an empty scripts string" do
    @asset_manager.instance_variable_get(:@scripts).should == ""
  end

	it "should create an empty array for components" do
	  @asset_manager.instance_variable_get(:@components).should be_empty
	  @asset_manager.instance_variable_get(:@components).should be_an_instance_of(Array)
	end

end

describe Yui4Rails::AssetManager, ".reset" do
  it "should nil the @@manager" do
		Yui4Rails::AssetManager.class_eval("@@manager = 123")
		Yui4Rails::AssetManager.class_eval("@@manager").should == 123
		Yui4Rails::AssetManager.reset
		Yui4Rails::AssetManager.class_eval("@@manager").should be_nil
  end
end


describe Yui4Rails::AssetManager, ".manager" do
  it "should call .new if manager is nil" do
		Yui4Rails::AssetManager.should_receive(:new)
		Yui4Rails::AssetManager.class_eval("@@manager = nil")
		Yui4Rails::AssetManager.class_eval("@@manager").should be_nil
		Yui4Rails::AssetManager.manager
  end

	it "should set @@manager" do
		@manager = Yui4Rails::AssetManager.manager
		Yui4Rails::AssetManager.class_eval("@@manager").should == @manager
  end

	it "should return an instance of AssetManager" do
	  Yui4Rails::AssetManager.manager.should be_an_instance_of(Yui4Rails::AssetManager)
	end
end

describe Yui4Rails::AssetManager, ".add_script" do
  it "should add a string arg to the @scripts string" do
		@manager = Yui4Rails::AssetManager.new
		@manager.scripts.should == ""
		@manager.add_script("my script")
		@manager.scripts.should == "my script"
  end
end

describe Yui4Rails::AssetManager, ".add_components" do
  it "should add a string arg to the @scripts string" do
		@manager = Yui4Rails::AssetManager.new
		@manager.scripts.should == ""
		@manager.add_script("my script")
		@manager.scripts.should == "my script"
  end
end

describe Yui4Rails::AssetManager, ".stylesheets" do
	
	before(:each) do
	  @manager = Yui4Rails::AssetManager.new
		@stylesheets = ["some","stuff"]
	end
	
  it "should call process_components if @stylesheets is nil" do
		@manager.instance_variable_get(:@stylesheets).should be_nil
		@manager.should_receive(:process_components)
		@manager.stylesheets
  end

 	it "should not call process_components if @stylesheets exists" do
		@manager.instance_variable_set(:@stylesheets, @stylesheets) 
		@manager.should_not_receive(:process_components)
		@manager.stylesheets
  end

	it "should return @stylesheets" do
		@manager.instance_variable_set(:@stylesheets, @stylesheets)
		@manager.stylesheets.should == @stylesheets
	end
end


describe Yui4Rails::AssetManager, ".javascripts" do
	
	before(:each) do
	  @manager = Yui4Rails::AssetManager.new
		@javascripts = ["some","stuff"]
	end
	
  it "should call process_components if @javascripts is nil" do
		@manager.instance_variable_get(:@javascripts).should be_nil
		@manager.should_receive(:process_components)
		@manager.javascripts
  end

 	it "should not call process_components if @javascripts exists" do
		@manager.instance_variable_set(:@javascripts, @javascripts) 
		@manager.should_not_receive(:process_components)
		@manager.javascripts
  end

	it "should return @javascripts" do
		@manager.instance_variable_set(:@javascripts, @javascripts)
		@manager.javascripts.should == @javascripts
	end
end


describe Yui4Rails::AssetManager, ".process_components" do
	
	before(:each) do
	  @manager = Yui4Rails::AssetManager.new
		@manager.instance_variable_get(:@stylesheets).should be_nil
		@manager.instance_variable_get(:@javascripts).should be_nil
	end
	
	it "should not duplicate resources" do
		@manager.instance_variable_set(:@components, [:reset, :reset, :reset])
		@manager.send(:process_components)
		@stylesheets = @manager.instance_variable_get(:@stylesheets)
		@stylesheets.should == ["reset/reset-min"]
	end
	
  it "should add stylesheet resources for :reset" do
		@manager.instance_variable_set(:@components, [:reset])
		@manager.send(:process_components)
		@manager.instance_variable_get(:@stylesheets).should include("reset/reset-min")
  end

  it "should add stylesheet resources for :fonts" do
		@manager.instance_variable_set(:@components, [:fonts])
		@manager.send(:process_components)
		@manager.instance_variable_get(:@stylesheets).should include("fonts/fonts-min")
  end

	it "should use add_container_includes for :container" do
		@manager.instance_variable_set(:@components, [:container])
		@manager.should_receive(:add_container_includes)
		@manager.send(:process_components)
  end

	it "should use add_container_includes for :datatable" do
		@manager.instance_variable_set(:@components, [:datatable])
		@manager.should_receive(:add_datatable_includes)
		@manager.send(:process_components)
  end

	it "should use add_container_includes for :charts" do
		@manager.instance_variable_set(:@components, [:charts])
		@manager.should_receive(:add_charts_includes)
		@manager.send(:process_components)
  end

	it "should use add_container_includes for :carousel" do
		@manager.instance_variable_set(:@components, [:carousel])
		@manager.should_receive(:add_carousel_includes)
		@manager.send(:process_components)
  end
end

