--!strict
local AssetService = game:GetService("AssetService")
local StudioService = game:GetService("StudioService")

local root = script.Parent.Parent
local functions = root.functions

local store = require(root.store)
local Fusion = require(root.Fusion)
local filter_table = require(functions.filter_table)

local New, Value, OnEvent, Computed, Children, ForValues = Fusion.New, Fusion.Value, Fusion.OnEvent, Fusion.Computed, Fusion.Children, Fusion.ForValues

local apply_map = {
	image = "an Image",
	audio = "a Sound",
	video = "a VideoFrame"
}
return function(parent: Instance)
	return Fusion.Hydrate(parent) {
		[Children] = {
			New "TextButton" {
				Text = "Import Asset",
				Size = UDim2.fromOffset(0, 32),
				Position = UDim2.new(0.5, 0, 0, 32),
				FontFace = Font.fromName("GothamSSm", Enum.FontWeight.Medium),
				TextColor3 = Color3.new(1, 1, 1),
				AnchorPoint = Vector2.xAxis / 2,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = Color3.fromRGB(149, 134, 235),
				[OnEvent "Activated"] = function()
					local files = StudioService:PromptImportFiles({
						"png", "jpg", "jpeg", "tga", "bmp",
						"mp3", "ogg",
						"mp4", "mov"
					}) :: { File }
					for _,file in files do
						store.register_new_asset(file)
					end
				end,
				[Children] = {
					New "UICorner" {
						CornerRadius = UDim.new(0, 16)
					},
					New "UIPadding" {
						PaddingLeft = UDim.new(0, 24),
						PaddingRight = UDim.new(0, 24)
					}
				}
			},
			New "Frame" {
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.fromOffset(0, 95),
				BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			},
			New "ScrollingFrame" {
				Size = UDim2.new(1, 0, 1, -96),
				Position = UDim2.fromOffset(0, 96),
				CanvasSize = UDim2.fromScale(0, 0),
				Transparency = 1,
				ScrollBarThickness = 8,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150),
				VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
				[Children] = {
					New "UIListLayout" {
						
					},
					ForValues(store.assets, function(use, asset)
						local asset_kind = asset.kind
						local asset_size = asset.asset_size
						local content_string = asset.content_string
						
						local hovering = Value(false)
						return New "Frame" {
							Size = UDim2.fromScale(1, 0),
							BorderColor3 = Color3.fromRGB(30, 30, 30),
							AutomaticSize = Enum.AutomaticSize.Y,
							BorderSizePixel = 1,
							BackgroundColor3 = Color3.fromRGB(60, 60, 60),
							[OnEvent "MouseEnter"] = function()
								hovering:set(true)
							end,
							[OnEvent "MouseLeave"] = function()
								hovering:set(false)
							end,
							[Children] = {
								New "TextLabel" {
									Text = `Asset #{asset.import_index} — {asset.file_name}`,
									Position = UDim2.fromOffset(16, 16),
									FontFace = Font.fromName("GothamSSm", Enum.FontWeight.Medium),
									TextColor3 = Color3.new(1, 1, 1),
									AutomaticSize = Enum.AutomaticSize.XY,
									BackgroundTransparency = 1
								},
								New "TextLabel" {
									Text = `{asset.file_size} bytes`,
									TextSize = 12,
									Position = UDim2.fromOffset(16, 32),
									FontFace = Font.fromName("GothamSSm", Enum.FontWeight.Regular),
									TextColor3 = Color3.fromRGB(150, 150, 150),
									AutomaticSize = Enum.AutomaticSize.XY,
									BackgroundTransparency = 1
								},
								asset_kind == "image" and
									New "ImageLabel" {
										Size = UDim2.new(1, -32, asset_size.Y / asset_size.X, -32),
										Image = content_string,
										Position = UDim2.fromOffset(16, 56),
										SizeConstraint = Enum.SizeConstraint.RelativeXX,
										BackgroundColor3 = Color3.new(0, 0, 0),
										ImageTransparency = Computed(function(use)
											return use(hovering) and 0.5 or 0
										end),
										[Children] = {
											New "UICorner" {
												CornerRadius = UDim.new(0, 8)
											},
											Computed(function(use)
												if use(hovering) then
													local selected = filter_table(use(store.selected), function(key, instance)
														if asset_kind == "image" then
															return instance:IsA("ImageLabel") or instance:IsA("ImageButton") or instance:IsA("ImageHandleAdornment") or instance:IsA("Decal")
														end
														return false
													end)
													local selected_amount = #selected
													return {
														New "UIListLayout" {
															VerticalAlignment = Enum.VerticalAlignment.Center,
															HorizontalAlignment = Enum.HorizontalAlignment.Center
														},
														selected_amount > 0 and
															New "TextButton" {
																Text = selected_amount == 1 and `Apply to {selected[1].ClassName}` or `Apply to {selected_amount} Instance(s)`,
																Size = UDim2.fromOffset(0, 32),
																FontFace = Font.fromName("GothamSSm", Enum.FontWeight.Medium),
																TextColor3 = Color3.new(1, 1, 1),
																AutomaticSize = Enum.AutomaticSize.X,
																BackgroundTransparency = 1,
																[OnEvent "Activated"] = function()
																	for _,instance in selected do
																		if instance:IsA("ImageLabel") or instance:IsA("ImageButton") or instance:IsA("ImageHandleAdornment") then
																			instance.Image = content_string
																		elseif instance:IsA("Decal") then
																			instance.Texture = content_string
																		elseif instance:IsA("EditableImage") then
																			local image = AssetService:CreateEditableImageAsync(content_string)
																			local image_size = image.Size
																			instance.Size = image_size
																			
																			image:Copy(Vector2.zero, image_size)
																			image:Destroy()
																		end
																	end
																end,
																[Children] = {
																	New "UICorner" {
																		CornerRadius = UDim.new(0, 8)
																	},
																	New "UIStroke" {
																		Color = Color3.new(1, 1, 1),
																		ApplyStrokeMode = Enum.ApplyStrokeMode.Border
																	},
																	New "UIPadding" {
																		PaddingLeft = UDim.new(0, 16),
																		PaddingRight = UDim.new(0, 16)
																	}
																}
															}
														or 
															New "TextLabel" {
																Text = `Select {apply_map[asset_kind]} to apply to`,
																FontFace = Font.fromName("GothamSSm", Enum.FontWeight.Medium),
																TextColor3 = Color3.new(1, 1, 1),
																AutomaticSize = Enum.AutomaticSize.XY,
																TextTransparency = 0.5,
																BackgroundTransparency = 1
															}
													}
												end
												return nil :: any
											end, Fusion.cleanup) :: any
										}
									}
									or asset_kind == "audio" and nil
									or asset_kind == "video" and
										New "VideoFrame" {
											Size = UDim2.new(1, -32, asset_size.Y / asset_size.X, -32),
											Video = content_string,
											Volume = 0,
											Looped = true,
											Playing = true,
											Position = UDim2.fromOffset(16, 56),
											SizeConstraint = Enum.SizeConstraint.RelativeXX,
											BackgroundColor3 = Color3.new(0, 0, 0),
											[Children] = New "UICorner" {
												CornerRadius = UDim.new(0, 8)
											}
										}
									:: any
							}
						}
					end, Fusion.cleanup) :: any
				}
			}
		}
	}
end