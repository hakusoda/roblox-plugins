--!strict
local types = require(script.Parent.Parent.types)

local map = {
	png = "image",
	jpg = "image",
	jpeg = "image", -- how dare... a four letter... how out of place...
	tga = "image",
	bmp = "image",
	
	mp3 = "audio",
	ogg = "audio",
	
	mp4 = "video",
	mov = "video"
}
return function(file_format: string): types.AssetKind?
	return map[string.lower(file_format)]
end