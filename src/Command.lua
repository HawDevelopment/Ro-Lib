--[[
    Command class
    HawDevelopment
    26/06/2021
--]]

local t = require(script.Parent.t)
local Observer = require(script.Parent.Observer)

local t_type = t.union(t.string, t.none)

---@class Command
local Command = {}
Command.__index = Command

--- Creates a new command
---@param commands table<string, fun(any): any> | nil
function Command.new(commands)
	assert(t.union(t.table, t.none)(commands))
	local self = setmetatable({}, Command)

	self.__commands = commands or {}

	return self
end

--- Adds a new command
---@param command fun(any): any
---@param name string
function Command:add(command, name)
	assert(t.callback(command))
	assert(t.string(name))
	self.__commands[name] = command
end

--- Executes command with given name
---@param name string
function Command:execute(name, ...)
	assert(t.string(name))
	assert(self.__commands[name] ~= nil, ("Command with name %s could not be found"):format(name))

	self.__commands[name](...)
end

Command.__index = function(self, index)
	if type(Command[index]) == "function" then
		return function(...)
			return Command[index](self, ...)
		end
	else
		return Command[index]
	end
end
Command.__call = function(self, ...)
	return self.set(...)
end

return setmetatable(Command, {
	__call = function(self, ...)
		return self.new(...)
	end,
})
