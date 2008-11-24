module Yui4Rails
  module Widgets
    class Chart
      
      attr_reader :errors
      
      CHARTS = {
        :pie => {
          :req => [:fields, :rows]
        },
        :bar => {
          :req => [:data_rows, :series_defs, :col_defs, :y_field]
        }
      }

      def initialize(chart_type, container_id, data, options = {})
        @errors = []
        @chart_type = chart_type
        @container_id = container_id
        @data = data
        @options = options

        if valid_params
          send("process_#{chart_type}_data".to_sym)

          unless errors?
            Yui4Rails::AssetManager.manager.add_components :charts
            Yui4Rails::AssetManager.manager.add_script %{YAHOO.widget.Chart.SWFURL = "/yui/charts/assets/charts.swf";}
            render_head_script 
          end
        end
      end
      
      def render
        div = ""
        div << "<-- #{errors.to_sentence} -->" if errors?
        div << "<div id=\"#{@container_id}\" class=\"yui-chart\"></div>"
      end
    
    
      protected
      
      def valid_params
        @errors << "Chart type, #{@chart_type} is not supported" unless CHARTS.has_key?(@chart_type)
        @errors << "Unable to build chart without container_id" if @container_id.nil? || @container_id == ""
        unless errors?
          (CHARTS[@chart_type][:req] - @data.keys).each do |field|
            @errors << "#{field} is a required data field"
          end
        end
      end
      
      def process_bar_data
        @data_rows = @data.delete(:data_rows)          
        @data_keys = Widgets.extract_keys(@data_rows)         
        @series_defs = @data.delete(:series_defs)          
        @col_defs = @data.delete(:col_defs)      
        @y_field = @data.delete(:y_field)    
      end      
      
      def process_pie_data
        @fields = @data.delete(:fields)
        @rows = @data.delete(:rows)
        # @fields = "[\"#{@fields.join('", "')}\"]"
        @data_keys = Widgets.extract_keys(@rows)
      
        @category_identifier = (@options.delete(:category_identifier) || 'category').to_s
        @data_identifier = (@options.delete(:data_identifier) || 'data').to_s
      end
      
      def render_head_script
        Yui4Rails::AssetManager.manager.add_script <<-PAGE
	      YAHOO.util.Event.addListener(window, "load", function() {
          
#{send("#{@chart_type}_head_script".to_sym)}

	      	var chart = new YAHOO.widget.#{chart_class_name}("#{@container_id}", chartData, chartOptions);
	      });
        PAGE
      end
      
      def bar_head_script
        <<-HS_INCLUDE
	        var myData = #{@data_rows.to_json};
	        var myColumnDefs = #{@col_defs.to_json};
      		
	        var chartData = new YAHOO.util.DataSource(myData);
	        chartData.responseType = YAHOO.util.DataSource.TYPE_JSARRAY;
	        chartData.responseSchema = {
	          fields: #{@data_keys.to_json}
	        };

	      	var seriesDef = #{@series_defs.to_json};                
	      	var countAxis = new YAHOO.widget.NumericAxis();
	      	var chartOptions = { series: seriesDef, yField: "#{@y_field}", xAxis: countAxis };
        HS_INCLUDE
      end
      
      def pie_head_script
        <<-HS_INCLUDE
          chartJSON = #{@rows.to_json}
          var chartData = new YAHOO.util.DataSource(chartJSON);
          chartData.responseType = YAHOO.util.DataSource.TYPE_JSARRAY;
          chartData.responseSchema = { fields: #{@fields.to_json} };

          chartOptions = {
            categoryField: "#{@category_identifier}",
            dataField: "#{@data_identifier}",
            style:
            {
              padding: 20,
              legend: {
                display: "right",
                padding: 10,
                spacing: 5,
                font: { family: "Arial", size: 13 }
              }
            },
            //only needed for flash player express install
            expressInstall: "/yui/charts/assets/expressinstall.swf"
          }
        HS_INCLUDE
      end      
      
      def chart_class_name
        "#{@chart_type.to_s.titleize}Chart"
      end
      
      def errors?
        errors.size > 0
      end

    end
  end
end
