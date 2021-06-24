--[[
    Symbol Class
    HawDevelopment
    24/06/2021
--]]

---@class Symbol
local Symbol = {}

--- Creates a new symbol
---@param name string @The name of the symbol
---@return Symbol
function Symbol.named(name)
	assert(type(name) == "string", "Symbols must be created using a string name!")

	local self = newproxy(true)

	local wrappedName = ("Symbol(%s)"):format(name)

	getmetatable(self).__tostring = function()
		return wrappedName
	end

	return self
end

--- Creates an unnamed symbol
---@return Symbol
function Symbol.unnamed()
	local self = newproxy(true)

	getmetatable(self).__tostring = function()
		return "Unnamed Symbol"
	end

	return self
end

return Symbol
