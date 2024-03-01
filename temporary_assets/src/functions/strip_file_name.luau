--!strict
return function(file_name: string): string
	local file_format = string.match(file_name, ".(%w+)$")
	return assert(file_format, "no file format?!? whaaaaat...")
end