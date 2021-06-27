--[[
    State class
    HawDevelopment
    26/06/2021
--]]

local t = require(script.Parent.t)
local Observer = require(script.Parent.Observer)

local t_type = t.union(t.string, t.none)

---@class State
local State = {}
State.__index = State

--- Creates a new state
---@param default any | nil
---@param observer Observer | nil
function State.new(default, observer)
	assert(t.union(t.table, t.none)(observer))
	local self = setmetatable({}, State)

	self.__state = default
	self.__observer = observer or Observer.new()

	return self
end

--- Sets state observer
---@param observer Observer
function State:observer(observer)
	assert(t.table(observer))
	self.__observer = observer
end

--- Adds a callback to state obsever
---@param callback fun(state: any) | "function(state) end"
---@param type string | nil
function State:bind(callback, type)
	assert(t.callback(callback))
	assert(t_type(type))
	self.__observer.add(callback, type)
end

---@return table
local function Mix(tab1, tab2)
	for i, v in pairs(tab2) do
		tab1[i] = b
	end
	return tab1
end

--- Sets the state
---@param state any
---@type string | nil
function State:set(state, type)
	assert(t.any(state))
	assert(t_type(type))

	if typeof(state) == "table" then
		setmetatable(
			state,
			Mix(getmetatable(state) or {}, {
				__newindex = function()
					error("State is read only!", 2)
				end,
			})
		)
	end

	self.__observer.fire(type or "all", state)
	self.__state = state
end

--- Gets the state
---@return any
function State:get()
	return self.__state
end

State.__tostring = function(self)
	return tostring(self.__state)
end

State.__index = function(self, index)
	if type(State[index]) == "function" then
		return function(...)
			return State[index](self, ...)
		end
	else
		return State[index]
	end
end
State.__call = function(self, ...)
	return self.set(...)
end

return setmetatable(State, {
	__call = function(self, ...)
		return self.new(...)
	end,
})
