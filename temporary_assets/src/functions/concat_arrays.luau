--!strict
-- not benchmarked
return function<T>(...: { [number]: T }?): { [number]: T }
	local iterable = {...}
	local total_length = 0
	for _,array in iterable do
		if array then
			total_length += #array
		end
	end
	
	if total_length == 0 then
		return {}
	end
	
	local result = table.create(total_length)
	local current_position = 1
	for _,array in iterable do
		if array then
			local array_length = #array
			table.move(array, 1, array_length, current_position, result)
			
			current_position += array_length
		end
	end
	
	return result :: any
end