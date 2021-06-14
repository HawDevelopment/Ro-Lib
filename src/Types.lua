--[[
    Types
    HawDevelopment
    12/06/2021
    
    Design from osyrisrblx/t
--]]

---@module Types
local Types = {}

local function Primitive(typeName)
	return function(value)
		local valueType = type(value)
		if valueType == typeName then
			return true
		else
			return false
		end
	end
end

Types["string"] = Primitive("string")
Types["boolean"] = Primitive("boolean")
Types["number"] = Primitive("number")
Types["nil"] = Primitive("nil")
Types["table"] = Primitive("table")
Types["thread"] = Primitive("thread")
Types["function"] = Primitive("function")
Types["userdata"] = Primitive("userdata")
Types["vector"] = Primitive("vector")

return Types
