require 'yui4rails/asset_manager'
require 'yui4rails/include_extension'
require 'yui4rails/helpers_extension'
require 'yui4rails/widgets'

ActionView::Base.send(:include, Yui4Rails::IncludeExtension)
ActionView::Base.send(:include, Yui4Rails::HelpersExtension)
ActionController::Base.send(:prepend_before_filter) do
	Yui4Rails::AssetManager.reset
end