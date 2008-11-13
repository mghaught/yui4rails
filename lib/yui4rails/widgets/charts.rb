module Yui4Rails
  module Widgets
    class Chart
      def initialize(chart_type, chart_id, rows, options)
        @chart_type = chart_type
        @chart_id = chart_id
        @fields = rows.map{ |row| row.keys.map(&:to_s) }.flatten.uniq
        @fields = "[\"#{@fields.join('", "')}\"]"
        @rows = rows.to_json
        @data_keys = Widgets.extract_keys(rows)
        @category_identifier = (options.delete(:category_identifier) || 'category').to_s
        @data_identifier = (options.delete(:data_identifier) || 'data').to_s
        Yui4Rails::AssetManager.manager.add_components :charts
        render_head_script
      end

      def render_head_script
        Yui4Rails::AssetManager.manager.add_script <<-PAGE
          YAHOO.widget.Chart.SWFURL = "/yui/charts/assets/charts.swf";
          chartJSON = #{@rows}
          var chartData = new YAHOO.util.DataSource(chartJSON);
          chartData.responseType = YAHOO.util.DataSource.TYPE_JSARRAY;
          chartData.responseSchema = { fields: #{@fields} };

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
        PAGE

      end

      def render_chart
        div = "<div id=\"#{@chart_id}\" class =\"yui-chart\"></div>"
        script = "<script type=\"text/javascript\">var chart = new YAHOO.widget.#{@chart_type.to_s.titleize}Chart( \"#{@chart_id}\", chartData, chartOptions);</script>"
        "#{div}#{script}"
      end
    end
  end
end
