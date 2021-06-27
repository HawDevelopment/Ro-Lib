--[[
    Strategy class
    HawDevelopment
    23/06/2021
--]]
local t = require(script.Parent.t)

---@class Strategy
local Strategy = {}
Strategy.__index = Strategy

--- Creates a new Strategy
---@param handles table<string | number, fun(any): any>
---@param start number | nil
function Strategy.new(handles, start)
	assert(t.table(handles))

	local self = setmetatable({}, Strategy)

	self.__handles = handles
	if start then
		self.__strategy = handles[start]
	else
		_, self.__strategy = next(handles)
	end

	return self
end

--- Adds a new handler to the strategy
---@param handler fun(any): any
---@param name string
function Strategy:add(handler, name)
	assert(t.callback(handler))
	assert(t.string(name))

	self.__handles[name] = handler
end
--- Sets the current Strategy
---@param name string @The name of strategy to set
---@return nil
function Strategy:set(name)
	assert(t.union(t.string, t.table)(name))

	-- For state objects
	name = tostring(name)

	if not self.__handles[name] then
		return error(("Strategy named %s could not be found"):format(tostring(name)), 2)
	end

	self.__strategy = self.__handles[name]
end

--- Calls the current set strategy, of none is found it errors
---@vararg any
---@return any
function Strategy:call(...)
	assert(self.__strategy ~= nil, "Strategy not set")

	return self.__strategy(...)
end

Strategy.__index = function(self, index)
	if type(Strategy[index]) == "function" then
		return function(...)
			return Strategy[index](self, ...)
		end
	else
		return Strategy[index]
	end
end
Strategy.__call = function(self, ...)
	return self.call(...)
end

return setmetatable(Strategy, {
	__call = function(self, ...)
		return self.new(...)
	end,
})
