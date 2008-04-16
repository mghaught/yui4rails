module Yui4Rails
	module Widgets
	  class Chart
	    def initialize(chart_id, column_definitions, data_rows)	
	      @chart_id = chart_id
	      @column_definitions = column_definitions
	      @data_rows = data_rows
	      @data_keys = Widgets.extract_keys(data_rows)
	    end
    
			# TODO - This widget still has hardcoded values and is not ready for public consumption
	    def render
	      <<-PAGE
	      <style type="text/css">
	      #page #legend { 
	        list-style: none; 
	        background: #ffffff; 
	        width: 18%;
	        float: right;
	        margin: 0;
	        padding: 0;
	      } 
	      #legend li { 
	        height: 1.2em; 
	        padding-left: 15px; 
	        margin-bottom: 4px; 
	      }
	      .categoryName { 
	        display: block; 
	        padding-left: 4px; 
	        background: #ffffff; 
	      }
	      .blue { 
	        background: #00b8bf; 
	      } 
	      .aqua { 
	        background: #8dd5e7; 
	      } 
	      .yellow { 
	        background: #edff9f; 
	      }
	      .orange { 
	        background: #ffa928; 
	      }
	      #chart_container {
	        width: 740px;
	      } 
	      #yui_chart {
	        width: 80%;
	        height: #{@data_rows.size * 100}px;
	        float: left;
	      }
	      .clear {
	        clear: both;
	      }
	      </style>
	      <div id="chart_container">
	        <div id="#{@chart_id}" class="yui-skin-sam"></div>
	        <ul id="legend"> 
	          <li class="blue"><span class="categoryName">Coupon Count</span></li> 
	          <li class="aqua"><span class="categoryName">Coupon Value</span></li> 
	          <li class="yellow"><span class="categoryName">Redeemed Mean</span></li> 
	          <li class="orange"><span class="categoryName">Redeemed StdDev</span></li> 
	        </ul>
	      </div>
	      <div class="clear"/>
	      <script type="text/javascript">
	      YAHOO.util.Event.addListener(window, "load", function() {
	        var myData = #{@data_rows.reverse.to_json};
	        var myColumnDefs = #{@column_definitions.to_json};
	        var myDataSource = new YAHOO.util.DataSource(myData);
	        myDataSource.responseType = YAHOO.util.DataSource.TYPE_JSARRAY;
	        myDataSource.responseSchema = {
	          fields: #{@data_keys.to_json}
	        };

	      	var seriesDef = [ { xField: "redeemed_coupon_count", displayName: "Coupon Count" },
	      	                  { xField: "redeemed_coupon_value", displayName: "Coupon Value" },
	      		                { xField: "redeemed_redemption_mean_(hours)", displayName: "Redeemed Mean" },
	      		                { xField: "redeemed_redemption_stddev_(hours)", displayName: "Redeemed Standard Deviation" }
	      	                ];

	      	var countAxis = new YAHOO.widget.NumericAxis();

	      	var mychart = new YAHOO.widget.BarChart( "#{@chart_id}", myDataSource, { series: seriesDef, yField: "row_dimension_label", xAxis: countAxis });
	      });
	      </script>
	      PAGE
	    end
	  end
	end
end