--[[
    Singleton Class
    HawDevelopment
    14/06/2021
--]]

local t = require(script.Parent.t)

---class @Singleton
local Singleton = {}
Singleton.__index = Singleton

--- Creates a new singleton
---@param handle fun() | table
---@return Singleton
function Singleton.new(handle)
	assert(t.union(t.callback, t.table)(handle))

	if type(handle) == "table" then
		assert(type(handle.new) == "function", "Expected class, got table")
	end

	local self = setmetatable({}, Singleton)

	self.__creator = handle

	return self
end

--- Gets or Creates object from the handler
---@return any
function Singleton:get()
	if not self.__obj then
		local ret

		if type(self.__creator) == "table" then
			ret = self.__creator.new()
		else
			ret = self.__creator()
		end

		self.__obj = ret
	end

	return self.__obj
end

--- Destroys the current set object
function Singleton:destroy()
	if self.__obj then
		if type(self.__obj) == "table" and self.__obj.Destroy then
			self.__obj:Destroy()
		end
		self.__obj = nil
	end
end

Singleton.__index = function(self, index)
	if type(Singleton[index]) == "function" then
		return function(...)
			return Singleton[index](self, ...)
		end
	else
		return Singleton[index]
	end
end
Singleton.__call = function(self, ...)
	return self.get(...)
end

return setmetatable(Singleton, {
	__call = function(self, ...)
		return self.new(...)
	end,
})
