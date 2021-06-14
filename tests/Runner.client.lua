--[[
    Test Runner
    HawDevelopment
    11/06/2021
--]]

local TestEz = require(game.ReplicatedStorage.TestEz)

local Tests = script.Parent:WaitForChild("Tests")

TestEz.TestBootstrap:run(Tests:GetDescendants())
