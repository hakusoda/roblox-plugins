--!strict
local root = script.Parent
local functions = root.functions

local store = require(root.store)
local MainWidget = require(root.widgets.MainWidget)
local create_toolbar = require(functions.create_toolbar)

local toolbar = create_toolbar(plugin)
local info = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Left,
	true,
	false,
	200,
	600,
	150,
	400
)

local widget: DockWidgetPluginGui = plugin:CreateDockWidgetPluginGui("hakumi_temporary_assets_widget", info)
widget.Name = "Temporary Assets"
widget.Title = "Temporary Assets"

local widget_button = toolbar:CreateButton("Temporary Assets", "🍔🍔🍔", "rbxassetid://11560877677") :: PluginToolbarButton
widget_button.ClickableWhenViewportHidden = true
widget_button.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

MainWidget(widget)

;(plugin :: Plugin).Unloading:Connect(function()
	store.cleanup()
	widget_button:Destroy()
end)