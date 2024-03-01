--!strict
export type Asset = {
	kind: AssetKind,
	file_name: string,
	file_size: number,
	asset_size: Vector2,
	import_index: number,
	content_string: string
}
export type AssetKind = "image" | "audio" | "video"

return 0