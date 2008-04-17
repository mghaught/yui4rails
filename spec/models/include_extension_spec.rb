require File.dirname(__FILE__) + '/../spec_helper'

class AppMock
	include Yui4Rails::IncludeExtension
	
	attr_reader :yui_components
	
	def stylesheet_link_tag(stylesheet)
		stylesheet
	end
	
	def javascript_include_tag(javascript)
		javascript
	end
end

describe Yui4Rails::IncludeExtension, ".include_yui" do
	
	before(:each) do
	  @caller = AppMock.new
	end
	
  it "should return appropriate resources for :container" do
   	@caller.include_yui(:container)
   	@caller.yui_includes.should == "/yui/container/assets/container\n/yui/yahoo-dom-event/yahoo-dom-event\n/yui/animation/animation-min\n/yui/container/container-min"
  end

  it "should return appropriate resources for :datatable" do
   	@caller.include_yui(:datatable)
   	@caller.yui_includes.should == "/yui/datatable/assets/skins/sam/datatable\n/yui/utilities/utilities\n/yui/datasource/datasource-beta-min\n/yui/datatable/datatable-beta-min"
  end

  it "should return appropriate resources for :charts" do
   	@caller.include_yui(:charts)
   	@caller.yui_includes.should == "/yui/utilities/utilities\n/yui/datasource/datasource-beta-min\n/yui/json/json-min\n/yui/charts/charts-experimental-min\n<script type=\"text/javascript\" charset=\"utf-8\">\nYAHOO.widget.Chart.SWFURL = \"/yui/charts/assets/charts.swf\";\n</script>"
  end

  it "should return appropriate resources for :carousel" do
   	@caller.include_yui(:carousel)
   	@caller.yui_includes.should == "/yui/carousel/assets/carousel\n/yui/yahoo-dom-event/yahoo-dom-event\n/yui/animation/animation-min\n/yui/container/container-min\n/yui/carousel/carousel_min"
  end

end

describe Yui4Rails::IncludeExtension, ".include_yui" do
	
	before(:all) do
	  @caller = AppMock.new
	end
	
  it "should initialize @yui_components as an empty array" do
    @caller.include_yui
		@caller.yui_components.should an_instance_of(Array)
		@caller.yui_components.should be_empty
  end	

  it "should add one component to @yui_components" do
    @caller.include_yui(:charts)
		@caller.yui_components.should an_instance_of(Array)
		@caller.yui_components.should_not be_empty
		@caller.yui_components.should include(:charts)
  end

	it "should allow duplicate entries and still record at least one entry" do
	  @caller.include_yui(:charts)
	  @caller.include_yui(:charts, :datatable)
		@caller.yui_components.should an_instance_of(Array)
		@caller.yui_components.should_not be_empty
		@caller.yui_components.should include(:charts) 
		@caller.yui_components.should include(:datatable) 
	end
end
