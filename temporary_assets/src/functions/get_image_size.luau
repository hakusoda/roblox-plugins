--!strict
local AssetService = game:GetService("AssetService")
return function(content_string: string): Vector2
	local image = AssetService:CreateEditableImageAsync(content_string)
	local image_size = image.Size
	image:Destroy()
	
	return image_size
end