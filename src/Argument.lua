--[[
    Argument Class
    HawDevelopment
    13/06/2021
--]]

--- Creates a new argument
---@param num number
---@return Argument
return function(num)
	---@class Argument
	local self = newproxy(true)

	local wrapStr = ("Argument(%d)"):format(num)

	getmetatable(self).__call = function()
		return num
	end
	getmetatable(self).__tostring = function()
		return wrapStr
	end

	return self
end
