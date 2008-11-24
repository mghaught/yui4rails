require File.dirname(__FILE__) + '/../spec_helper'


describe Yui4Rails::Widgets::Chart do

  describe "#new" do
    
    before(:each) do
			@manager = mock("Manager", :add_script  => true, :add_components => true)
		  Yui4Rails::AssetManager.stub!(:manager).and_return(@manager)
    end

    describe "with an unknown chart type" do
      before(:each) do
        @chart_type = :foo
        @chart_id = "chart_id"
        @chart = Yui4Rails::Widgets::Chart.new(@chart_type, @chart_id, {})        
      end
      
      it "should set an error message that the chart type was invalid" do
        @chart.errors.should include("Chart type, #{@chart_type} is not supported")
      end
    end

    describe "with an unknown chart type" do
      before(:each) do
        @chart_type = :bar
        @chart_id = ""
        @chart = Yui4Rails::Widgets::Chart.new(@chart_type, @chart_id, {})        
      end
      
      it "should set an error message that the chart id was invalid" do
        @chart.errors.should include("Unable to build chart without container_id")
      end
    end
    
    describe "for a bar chart" do
      before(:each) do
        @chart_type = :bar
        @chart_id = "chart_id"
      end
      
      describe "when missing required elements" do

        before(:each) do
          @chart = Yui4Rails::Widgets::Chart.new(@chart_type, @chart_id, {})
        end
        
        it "should set an error message for missing data rows" do
          @chart.errors.should include("data_rows is a required data field")
        end
        
        it "should set an error message for missing series defs" do
          @chart.errors.should include("series_defs is a required data field")
        end

        it "should set an error message for missing col defs" do
          @chart.errors.should include("col_defs is a required data field")
        end

        it "should set an error message for missing y_field" do
          @chart.errors.should include("y_field is a required data field")
        end
      end
      
      describe "with valid params" do
        
        before(:each) do
          @data_rows = [
              {"row_name"  => "Row1", "field_1" => "row1_1", "field_2" => "row1_2"},
              {"row_name"  => "Row2", "field_1" => "row2_1", "field_2" => "row2_2"},
              {"row_name"  => "Row3", "field_1" => "row3_1", "field_2" => "row3_2"}
            ]
          @series_defs = [{:displayName => "Field1", :xField => "field_1"},{:displayName => "Field2", :xField => "field_2"}]
          @col_defs = [{:key => "row_name", :label => "ColName"},
              {:key => "field_1", :label => "Field1"},
              {:label => "Field2", :key => "field_2"}]
          @y_field = "field_1"          
        end
        
        def create_chart
          @chart = Yui4Rails::Widgets::Chart.new(@chart_type, @chart_id, 
            {:data_rows => @data_rows, :series_defs => @series_defs, :col_defs => @col_defs, :y_field => @y_field})
        end
        
        it "should have no errors" do
          create_chart.errors.should be_empty
        end
        
        it "should invoke the Yui4Rails::AssetManager.manager.add_components" do
    			@manager.should_receive(:add_components)
          create_chart
    		end
        
        it "should add the Yahoo Widget SWF" do
          @manager.should_receive(:add_script).with(%{YAHOO.widget.Chart.SWFURL = "/yui/charts/assets/charts.swf";})
    			create_chart
    		end
    		
    		it "should set the data_keys variable with Widgets.extract_keys return" do
    		  Yui4Rails::Widgets.should_receive(:extract_keys).with(@data_rows).and_return([1,2,3])
    		  create_chart
    		  @chart.instance_variable_get(:@data_keys).should == [1,2,3]
    		end
      end
    end

    describe "for a pie chart" do
      before(:each) do
        @chart_type = :pie
        @chart_id = "chart_id"
      end
      
      describe "when missing required elements" do

        before(:each) do
          @chart = Yui4Rails::Widgets::Chart.new(@chart_type, @chart_id, {})
        end

        it "should set an error message for missing fields" do
          @chart.errors.should include("fields is a required data field")
        end
        
        it "should set an error message for missing rows" do
          @chart.errors.should include("rows is a required data field")
        end

      end
    end
  end

  describe ".render" do

    describe "with a valid chart" do
      it "should output the proper div" do
        @chart = Yui4Rails::Widgets::Chart.new(:pie, "success", {})
        @chart.instance_variable_set(:@errors, [])        
        @chart.render.should match(/<div id=\"success\" class=\"yui-chart\"><\/div>/)
      end
    end
    
    describe "when there are errors" do
  
      it "should output a div containing our error messages in an html comment" do
        @chart = Yui4Rails::Widgets::Chart.new(:denied, "error", {})
        @chart.instance_variable_set(:@errors,["My errors"])        
        @chart.render.should match(/<-- My errors --><div.*><\/div>/)
      end
    end

  end
end