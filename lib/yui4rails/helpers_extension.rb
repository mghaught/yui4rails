module Yui4Rails
  module HelpersExtension

    def yui_carousel(carousel_id, collection, options = {}, &block)
      carousel = Yui4Rails::Widgets::Carousel.new(carousel_id, collection, options)
      
      concat(%{<div id="#{carousel_id}" class="carousel-component">}, block.binding)
      yield block
      concat("</div>", block.binding)      
    end
  
    def yui_chart(chart_type, chart_id, rows, options = {})
      Yui4Rails::Widgets::Chart.new(chart_type, chart_id, rows, options).render_chart
    end

    def yui_datatable(statistics, div_id, options = {})
      return 'No data found.' if statistics.rows.empty?
      model = statistics.rows.first.class 

      data = statistics.rows.map(&:to_hash)
      footer = "<tr class =\"totals_row\">#{statistics.footer_row_fields.map { |field| "<td><div class=\"yui-dt-liner\">#{field.to_s}</div></td>" }.join('')}</tr>"
      Yui4Rails::Widgets::DataTable.new(:col_defs => model.table_def,
                                        :data_rows => data,
                                        :footer_row => footer,
                                        :table_div_id => div_id,
                                       :table_id => 'yui_table').render
    end

  
  end
end
