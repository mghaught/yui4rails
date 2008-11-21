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
      rows = options[:data_array] || statistics.rows
      return 'No data found.' if rows.empty?
      model = rows.first.class 

      data = rows.map(&:to_hash)

      table_def = model.table_def
      table_options = {}

      unless table_def.first.delete(:skip_footer)
        footer = "<tr class =\"totals_row\">#{statistics.footer_row_fields.map { |field| "<td><div class=\"yui-dt-liner\">#{field.to_s}</div></td>" }.join('')}</tr>"
        table_options[:footer_row] = footer
      end

      table_options[:row_formatter] = table_def.first.delete(:row_formatter) if table_def.first[:row_formatter]
      table_options[:head_script] = table_def.first.delete(:head_script) if table_def.first[:head_script]

      table_options[:col_defs] = table_def
      table_options[:data_rows] = data
      table_options[:table_div_id] = div_id
      table_options[:table_id] = 'yui_table'

      Yui4Rails::Widgets::DataTable.new(table_options).render
    end

  
  end
end
