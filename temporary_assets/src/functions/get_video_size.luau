--!strict
local LogService = game:GetService("LogService")
local VideoService = game:GetService("VideoService")
return function(content_string: string): Vector2
	local video_frame = Instance.new("VideoFrame")
	video_frame.Archivable = false
	video_frame.Parent = VideoService
	
	local event = Instance.new("BindableEvent")
	local connection = video_frame:GetPropertyChangedSignal("Resolution"):Once(function()
		event:Fire()
	end)
	local connection2: RBXScriptConnection
	connection2 = LogService.MessageOut:Connect(function(message, message_type)
		if message_type == Enum.MessageType.MessageError and string.find(string.lower(message), "video") then
			video_frame.Video = ""
			video_frame:Destroy()
			
			connection:Disconnect()
			connection2:Disconnect()
			video_frame, connection, connection2 = nil
			
			event:Fire(0)
		end
	end)
	
	video_frame.Video = content_string
	if event.Event:Wait() then
		error("video resolution too large")
	end
	connection2:Disconnect()
	connection, connection2 = nil
	
	local video_size = video_frame.Resolution
	video_frame:Destroy()
	
	return video_size
end