--!strict
local TOOLBAR_NAME = "HAKUMI"
local TOOLBAR_CONTAINER_NAME = "hakumi_plugin_toolbar"
local TOOLBAR_CONTAINER_PARENT = game:GetService("KeyboardService")
return function(plugin: Plugin): PluginToolbar
	local toolbar_container = TOOLBAR_CONTAINER_PARENT:FindFirstChild(TOOLBAR_CONTAINER_NAME) :: Folder
	if not toolbar_container then
		toolbar_container = Instance.new("Folder")
		;(toolbar_container :: any).Name = TOOLBAR_CONTAINER_NAME
		;(toolbar_container :: any).Archivable = false
	end
	
	local toolbar = toolbar_container:FindFirstChild(TOOLBAR_NAME) :: PluginToolbar
	if not toolbar then
		toolbar = plugin:CreateToolbar(TOOLBAR_NAME)
		;(toolbar :: any).Name = TOOLBAR_NAME
		;(toolbar :: any).Parent = toolbar_container
	end
	
	toolbar_container.Parent = TOOLBAR_CONTAINER_PARENT
	
	return toolbar
end