module Yui4Rails
	module Widgets
	
	  class Formatter; end
	  class NumberFormatter < Formatter
	    def self.to_s
				"number"
	    end
	  end
	  class CurrencyFormatter < Formatter
	    def self.to_s
	      "currency"
	    end
	  end
  
	  def self.extract_keys(data_rows)
	    keys = []
	    return keys if data_rows.empty?
    
	    data_rows.first.each do |k, v|
	      keys << { :key => k.to_s }
	    end
	    keys
	  end
  
	  class DataTable
	    def initialize(table_id, column_definitions, data_rows, footer_row = "")	
	      @table_id = table_id
	      @column_definitions = column_definitions
	      @data_rows = data_rows
	      @data_keys = Widgets.extract_keys(data_rows)
	      @footer_row = footer_row
	    end
    
	    def render
	      <<-PAGE
	      <div id="#{@table_id}" class="yui-skin-sam"></div>
	      <script type="text/javascript">
	      YAHOO.util.Event.addListener(window, "load", function() {
	        var myData = #{@data_rows.to_json};
	        var myColumnDefs = #{@column_definitions.to_json};
	        var myDataSource = new YAHOO.util.DataSource(myData);
	        myDataSource.responseType = YAHOO.util.DataSource.TYPE_JSARRAY;
	        myDataSource.responseSchema = {
	          fields: #{@data_keys.to_json}
	        };
	        var myDataTable = new YAHOO.widget.DataTable("#{@table_id}", myColumnDefs, myDataSource);
					var tbody_id = myDataTable._sId + "-bodytable";
					$(tbody_id).createTFoot().innerHTML = '#{@footer_row}';
	      });
	      </script>
	      PAGE
	    end
	  end
	end
end