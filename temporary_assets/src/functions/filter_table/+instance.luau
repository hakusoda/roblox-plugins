--!strict
return function<K, V>(input: { [K]: V }, condition: (K, V) -> boolean): { [K]: V }
	local result = {}
	for key, value in input do
		if condition(key, value) then
			result[key] = value
		end
	end
	
	return result
end