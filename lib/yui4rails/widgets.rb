require 'yui4rails/widgets/datatable'
require 'yui4rails/widgets/charts'
require 'yui4rails/widgets/carousel'
require 'yui4rails/widgets/tooltip'

ActionView::Base.send(:include, Yui4Rails::Widgets)