--[[
    Factory Class
    HawDevelopment
    11/06/2021
--]]
local t = require(game.ReplicatedStorage.t)

---alias Factory {__enum: table<string, number>, __factories: table<string, function>, rule: fun(types: Rule[]), create: fun(type: string | number, ...): table, base: fun(base: table<string | number, FactoryArgument>)}
---@alias Rule fun(type: any): boolean

---@class Factory
local Factory = {}

---@module Types
Factory.Type = require(script.Parent.Types)

---@type fun(num: number): Argument
Factory.Argument = require(script.Parent.Argument)

local function Copy(tab)
	local newtab = {}
	for index, value in pairs(tab) do
		newtab[index] = value
	end
	return newtab
end

--- Creates a new factory
---@param enum table<string, number> @Table with name as indexes and number as values
---@param factories table<string, function> @Table with name as indexes and constructor as values
---@return Factory
function Factory.new(enum, factories)
	assert(t.table(enum))
	assert(t.table(factories))

	-- We want to error if enums doesnt line up with factories
	do
		for index, _ in pairs(enum) do
			if type(index) == "number" then
				error(("Index %s in enum isnt of type string, enum indexes must be strings"):format(index))
			end

			if not factories[index] then
				error(("Index %s in enum doesnt have a corresponding factory"):format(tostring(index)), 2)
			end
		end
	end

	local self = setmetatable({}, Factory)

	self.__factories = Copy(factories)
	self.__enum = Copy(enum)

	return self
end

--- Create a class with type and arguments
---@param type number | string @Type with corresponding name in Enum list
---@vararg any
---@return table
function Factory:create(type, ...)
	assert(t.union(t.string, t.number)(type))
	local args = table.pack(...)

	-- Get name from type
	local enumName

	for name, enumType in pairs(self.__enum) do
		if enumType == type or name == type then
			enumName = name
			break
		end
	end

	assert(enumName, "Type has no corresponding Enum")
	assert(self.__factories[enumName], "Enum has no corresponding constructer")

	-- Rules
	if self.__rule then
		for index, value in ipairs(args) do
			if self.__rule[index](value) == false then
				error(
					("Argument %d in function with type %s, doesnt comply with rules"):format(index, typeof(value)),
					3
				)
			end
		end
	end

	-- Create class
	local class = {}

	-- Base
	if self.__base then
		for index, argument in pairs(self.__base) do
			class[index] = args[tonumber(argument())]
		end
	end

	self.__factories[enumName](class, ...)
	return class
end

--- Sets the rule class types
---@param types table<any, Rule>
function Factory:rule(types)
	assert(t.union(t.table, t.none)(types))

	if type(types) == "table" then
		assert(t.values(t.callback)(types))

		self.__rule = Copy(types)
	else
		self.__rule = nil
	end
end

--- Sets the base of the class
---@param base table<any, Argument> @The arguments with corresponding class indexes
function Factory:base(base)
	assert(t.union(t.table, t.none)(base))

	if type(base) == "table" then
		-- Baseic error handling
		for index, value in pairs(base) do
			if not (type(index) == "number" or type(index) == "string") then
				error(("Index %s in base, isnt of type string or number"):format(index), 3)
			end

			if not (tostring(value):match("Argument%(%d-%)")) then
				error(("Value with index %s in base, isnt of type Argument"):format(index), 3)
			end
		end

		self.__base = Copy(base)
	else
		self.__base = nil
	end
end

-- Metatables stuff
Factory.__index = function(self, index)
	if type(Factory[index]) == "function" then
		return function(...)
			return Factory[index](self, ...)
		end
	else
		return Factory[index]
	end
end
Factory.__call = function(self, ...)
	return self.create(...)
end

return setmetatable(Factory, {
	__call = function(_, ...)
		return _.new(...)
	end,
})
