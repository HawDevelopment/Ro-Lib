--[[
    Observer
    HawDevelopment
    24/06/2021
--]]

local t = require(script.Parent.t)
local symbol = require(script.Parent.Symbol)

---@module Observer
---@class Observer
local Observer = {}
Observer.__index = Observer

--- Creates a new Observer
---@param listeners nil | table | "nil" | "{}" @Start listeners
---@return Observer
function Observer.new(listeners)
	assert(t.union(t.table, t.none)(listeners))

	local self = setmetatable({}, Observer)

	self.__listeners = listeners or {}

	return self
end

--- Adds a handler / listener to observer
---@param handler fun(any) | "function(arg1, arg2) end"
---@param type string
---@return fun() @Function that when called whil remove handler from its index
function Observer:add(handler, type)
	assert(t.callback(handler))
	assert(t.union(t.string, t.none)(type))

	local tab = self.__listeners
	if type then
		if not self.__listeners[type] then
			self.__listeners[type] = {}
		end

		tab = self.__listeners[type]
	end

	local index = #tab + 1
	tab[index] = handler

	return function()
		tab[index] = nil
	end
end

--- Fires observer, calling every listener
---@param type string | nil
---@vararg any
---@return Observer
function Observer:fire(type, ...)
	local tab = self.__listeners
	if type and string.lower(type) ~= "all" then
		if not self.__listeners[type] then
			self.__listeners[type] = {}
		end

		tab = self.__listeners[type]
	end

	for _, fun in pairs(tab) do
		fun(...)
	end

	return self
end

Observer.__index = function(self, index)
	if type(Observer[index]) == "function" then
		return function(...)
			return Observer[index](self, ...)
		end
	else
		return Observer[index]
	end
end
Observer.__call = function(self, ...)
	return self.fire(...)
end

return setmetatable(Observer, {
	__call = function(self, ...)
		return self.new(...)
	end,
})
