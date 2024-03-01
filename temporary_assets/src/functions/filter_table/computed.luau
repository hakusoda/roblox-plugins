--!strict
local Fusion = require(script.Parent.Parent.Parent.Fusion)
local filter_table = require(script.Parent)

type Use = <T>(target: Fusion.CanBeState<T>) -> T

local Computed = Fusion.Computed
return function<K, V>(input: Fusion.StateObject<{ [K]: V }>, condition: (Use, K, V) -> boolean): Fusion.StateObject<{ [K]: V }>
	return Computed(function(use)
		return filter_table(use(input), function(key, value)
			return condition(use, key, value)
		end)
	end)
end