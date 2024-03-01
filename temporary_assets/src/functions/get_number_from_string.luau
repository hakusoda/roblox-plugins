--!strict
return function(input: string): number?
	local match = string.match(input, "(%d+)")
	return tonumber(match)
end