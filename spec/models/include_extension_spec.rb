require File.dirname(__FILE__) + '/../spec_helper'

class AppMock
	include Yui4Rails::IncludeExtension
	
	def stylesheet_link_tag(stylesheet)
		stylesheet
	end
	
	def javascript_include_tag(javascript)
		javascript
	end
end

describe Yui4Rails::IncludeExtension, ".include_yui" do
	
	before(:all) do
	  @caller = AppMock.new
	end
	
  it "should return appropriate resources for :container" do
   	@caller.include_yui(:container).should == "/yui/container/assets/container\n/yui/yahoo-dom-event/yahoo-dom-event\n/yui/animation/animation-min\n/yui/container/container-min"
  end

  it "should return appropriate resources for :datatable" do
   	@caller.include_yui(:datatable).should == "/yui/datatable/assets/skins/sam/datatable\n/yui/utilities/utilities\n/yui/datasource/datasource-beta-min\n/yui/datatable/datatable-beta-min"
  end

  it "should return appropriate resources for :charts" do
   	@caller.include_yui(:charts).should == "/yui/utilities/utilities\n/yui/datasource/datasource-beta-min\n/yui/json/json-min\n/yui/charts/charts-experimental-min\n<SCRIPT>\nYAHOO.widget.Chart.SWFURL = \"/yui/charts/assets/charts.swf\";\n</SCRIPT>"
  end

end
