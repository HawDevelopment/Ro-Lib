--[[
    Just messing around here, trying to check Luau and Emmylua types
    HawDevelopment
    12/06/2021
--]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Factory = require(ReplicatedStorage.libs.Factory)

-- Factory

---@type Factory
local factory = Factory.new()

Factory.Argument()
