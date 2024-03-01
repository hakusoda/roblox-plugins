--!strict
local Selection = game:GetService("Selection")

local root = script.Parent
local functions = root.functions

local types = require(root.types)
local Fusion = require(root.Fusion)
local concat_arrays = require(functions.concat_arrays)
local get_image_size = require(functions.get_image_size)
local get_video_size = require(functions.get_video_size)
local strip_file_name = require(functions.strip_file_name)
local get_number_from_string = require(functions.get_number_from_string)
local get_asset_kind_from_file_format = require(functions.get_asset_kind_from_file_format)

local peek, Value, Computed = Fusion.peek, Fusion.Value, Fusion.Computed

local assets = Value({} :: { types.Asset })
local selected = Value(Selection:Get())
local selected_changed = Selection.SelectionChanged:Connect(function()
	selected:set(Selection:Get())
end)

return {
	assets = assets,
	selected = selected,
	register_new_asset = function(file: File)
		local file_name = file.Name
		local file_format = strip_file_name(file_name)
		local asset_kind: types.AssetKind = assert(get_asset_kind_from_file_format(file_format))
		local content_string: string = file:GetTemporaryId()
		
		local new_asset: types.Asset = {
			kind = asset_kind,
			file_name = file_name,
			file_size = file.Size,
			asset_size = asset_kind == "image" and
				get_image_size(content_string)
				or asset_kind == "video" and
				get_video_size(content_string)
				or Vector2.zero,
			import_index = assert(get_number_from_string(content_string)),
			content_string = content_string
		}
		assets:set(concat_arrays(peek(assets), { new_asset }))
	end,
	cleanup = function()
		selected_changed:Disconnect()
		selected_changed = nil
	end
}