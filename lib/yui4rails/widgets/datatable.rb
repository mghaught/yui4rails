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
      # Initialize new DataTable object
      # accepts either a list of arguments for backward compatability
      # or a hash of options.
      #
      # If you pass a list of arguments:
      # * <tt>:table_div_id</tt>: DOM element ID for div surrounding table
      # * <tt>:col_defs</tt>: Hash of column definitions
      # * <tt>:data_rows</tt>: Hash of data rows
      # * <tt>:footer_row</tt>: footer div id.  -See ActiveWarehouse for the yui_adapter than uses this
      # * <tt>:options</tt>: additional hash of options, including :table_id, the
      # DOM element ID for the HTML table
      # 
      # If you pass a hash of options:
      # Same as list of options except in an options Hash.  Also accepts a <tt>:data_keys</tt> 
      # hash, which, if not supplied is generated automatically from the <tt>:col_defs</tt> hash
      #
      # === HTML Table Example:
      #
      # <tt>col_defs = [{:label=>"First", :key=>"firstname", :sortable=>true}, </tt>
      # <tt> {:label=>"Last", :key=>"lastname", :sortable=>true}, </tt>
      # <tt> {:label=>"Age", :key=>"age", :formatter=>"number", :sortable=>true, :sortOptions=></tt>
      # <tt> {:defaultDir=>"YAHOO.widget.DataTable.CLASS_DESC"}}, </tt>
      # <tt> {:label=>"Description", :key=>"description", :sortable=>false}, </tt> 
      # <tt> {:label=>"Balance", :key=>"balance", :formatter=>"currency", :sortable=>true}] </tt>
      #
      # <tt> data_keys = [{:key=>"firstname"}, </tt>
      # <tt>   {:key=>"lastname"}, </tt>
      # <tt>   {:key=>"age", :parser=>"YAHOO.util.DataSource.parseNumber"}, </tt>
      # <tt>   {:key=>"description"}, </tt>
      # <tt>   {:key=>"balance", :parser=>"this.parseNumberFromCurrency"}]</tt>
      # 
      # <tt> @data_table = Yui4Rails::Widgets::DataTable.new(:table_div_id => "markup",</tt>
      # <tt>  :col_defs => @col_defs,  :data_keys => @data_keys, :table_id => 'yui_table')</tt>
      # In the view:
      # <tt> <%= @data_table.render(:source => :html) %></tt>
      def initialize(*args)
        case args[0]
        when Hash
          options = args[0]
          @table_div_id = options[:table_div_id]
          @table_id     = options[:table_id]    
          @col_defs     = options[:col_defs]    
          @data_rows    = options[:data_rows]   
          @footer_row   = options[:footer_row]  
          @data_keys    = options[:data_keys]   
          if @data_rows and !@data_keys
            @data_keys = Widgets.extract_keys(data_rows)
          end
        when String
          @table_div_id = args[0]
          @col_defs = args[1] 
          @data_rows = args[2] 
          @data_keys = Widgets.extract_keys(@data_rows)
          @footer_row = args[3] || '' 
        end
      end

      # Add pagination to YUI datatable.
      # ex: @data_table.paginate(5)
      # * <tt>:rows</tt>: number of rows per page
      def paginate(rows = 50)
        @pagination_text = "paginator: new YAHOO.widget.Paginator({rowsPerPage: #{rows}})"
      end

      # Add initial sort direction.  
      # This does not correctly with HTML-based tables, and not implemented yet for json
      # (yeah, so it doesn't work)
      # <tt>:key</tt>: column key to sort by
      # <tt>:dir</tt>: initial sort direction (default is asc) 
      def initial_sort(key, dir='asc')
        @initial_sort_text = "sortedBy: {key:\"#{key}\",dir:\"#{dir}\"}"
      end

    
      # Renders the datatable
      # * <tt>:options[:source]</tt>: the datasource for the datatable
      # e.g., <tt>:json</tt>(default) or <tt>:html</tt>
      def render(options={})
        source = options[:source] || :json
        meth = "render_from_#{source.to_s}"
        self.send(meth)
      end

	    def render_from_html
	      <<-PAGE
        <script type="text/javascript">
        #{get_configs}
          YAHOO.util.Event.addListener(window, "load", function() {
            YAHOO.example.EnhanceFromMarkup = new function() {
              var myColumnDefs = #{col_defs_to_json};
              this.parseNumberFromCurrency = function(sString) {
                //remove commas
                sString = sString.replace(/,/, '');
                // Remove dollar sign and make it a float
                return parseFloat(sString.substring(1));
              };
              this.myDataSource = new YAHOO.util.DataSource(YAHOO.util.Dom.get("#{@table_id}"));
              this.myDataSource.responseType = YAHOO.util.DataSource.TYPE_HTMLTABLE;
              this.myDataSource.responseSchema = {
                fields: #{data_keys_to_json}
              };
              this.myDataTable = new YAHOO.widget.DataTable("#{@table_div_id}", myColumnDefs, 
              this.myDataSource, myConfigs);

            };
          });
          </script>
          PAGE
        end

	    def render_from_json
	      <<-PAGE
	      <div id="#{@table_div_id}" class="yui-skin-sam"></div>
	      <script type="text/javascript">
	      YAHOO.util.Event.addListener(window, "load", function() {
	        var myData = #{@data_rows.to_json};
	        var myColumnDefs = #{@col_defs.to_json};
	        myDataSource = new YAHOO.util.DataSource(myData);
	        myDataSource.responseType = YAHOO.util.DataSource.TYPE_JSARRAY;
	        myDataSource.responseSchema = {
	          fields: #{@data_keys.to_json}
	        };
	        this.myDataTable = new YAHOO.widget.DataTable("#{@table_div_id}", myColumnDefs, myDataSource);
					var tbody_id = myDataTable._sId + "-bodytable";
					$(tbody_id).createTFoot().innerHTML = '#{@footer_row}';

	      });
	      </script>
	      PAGE
	    end

      private
      # Constructs the myConfigs JavaScript variable if pagination or intial sort is used
      def get_configs
        my_configs = []
        my_configs << @pagination_text if @pagination_text
        my_configs << @initial_sort_text if @initial_sort_text
        return '' if my_configs.size == 0
        return "var myConfigs = {\n" + my_configs.join(",\n") + " };\n"
      end

      def col_defs_to_json
        #Remove quotes from YAHOO object/constant names
        #There is probably a better way to do this.
        @col_defs.to_json.gsub(/\"YAHOO/, 'YAHOO').
          gsub(/CLASS_DESC\"/, 'CLASS_DESC').
          gsub(/CLASS_ASC\"/, 'CLASS_ASC')
      end

      def data_keys_to_json
        #remove quotes from YAHOO object/constant names
        #There is probably a better way to do this.
         @data_keys.to_json.gsub(/\"YAHOO/, 'YAHOO').
          gsub(/parseNumber\"/, 'parseNumber').
          gsub(/FromCurrency\"/, 'FromCurrency').
          gsub(/\"this\./, 'this.')
      end
	  end
	end
end
