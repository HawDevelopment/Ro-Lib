--[[
    Chain class
    HawDevelopment
    26/06/2021
--]]

local t = require(script.Parent.t)

---@class Chain
local Chain = {}
Chain.__index = Chain

--- Creates a new Chain
---@param handles table<string | number, fun(any): boolean> | nil
---@param shouldWarn boolean
function Chain.new(chain, shouldWarn)
	assert(t.union(t.table, t.none)(chain))
	chain = chain or {}

	for index, val in pairs(chain) do
		if type(index) ~= "number" then
			error("Chain indexes can only be numbers!", 2)
		end

		if type(val) ~= "function" then
			error("Chain values can only be functions", 2)
		end
	end

	local self = setmetatable({}, Chain)

	self.__chain = chain

	if shouldWarn then
		self.__warn = shouldWarn
	else
		self.__warn = true
	end

	return self
end

--- Sets the current Chain
---@param handler fun(any): boolean
---@param index number | nil @Index of handler in chain, defaults to last index plus one
function Chain:add(handler, index)
	assert(t.callback(handler))
	assert(t.union(t.number, t.none)(index))
	index = index or #self.__chain + 1

	table.insert(self.__chain, index, handler)
	return self
end

--- Execures the current Chain
---@vararg any
---@return boolean
function Chain:execute(...)
	for i, handle in ipairs(self.__chain) do
		local ret, err = handle(...)

		if ret == false then
			if err and self.__warn then
				warn(err)
			else
				warn(("Error cought in chain on index %s"):format(i))
			end

			return ret
		end
	end

	return true
end

Chain.__index = function(self, index)
	if type(Chain[index]) == "function" then
		return function(...)
			return Chain[index](self, ...)
		end
	else
		return Chain[index]
	end
end
Chain.__call = function(self, ...)
	return self.fire(...)
end

return setmetatable(Chain, {
	__call = function(self, ...)
		return self.new(...)
	end,
})
