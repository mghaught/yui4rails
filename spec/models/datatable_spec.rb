require File.dirname(__FILE__) + '/../spec_helper'

# TODO - considering change from hacked to real...
class Array
	def to_json
		self.to_s
	end
end

describe "Yui4Rails::Widgets::NumberFormatter" do
  it "should return number from to_s" do
		Yui4Rails::Widgets::NumberFormatter.to_s.should == "number"
  end
end

describe "Yui4Rails::Widgets::CurrencyFormatter" do
  it "should return currency from to_s" do
		Yui4Rails::Widgets::CurrencyFormatter.to_s.should == "currency"
  end
end

describe Yui4Rails::Widgets::DataTable, "with no footer row" do
	
	before(:each) do
		@table_id = "my-table-id"
		@column_definitions = [{:key => 'col1', :label => "Col 1 Label"},{:key => 'col2', :label => "Col 2 Label"}]
		@data_rows = [{:row_dimension_key => 'row1_key', :cell1_key => "cell1_value"}]
	  @datatable = Yui4Rails::Widgets::DataTable.new(@table_id, @column_definitions, @data_rows)
	end
	
  it "should render the specified table_id" do
    @datatable.render.should match(/<div id="#{@table_id}"/)
  end
end
