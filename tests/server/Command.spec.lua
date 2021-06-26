--[[
    Command tests
    HawDevelopment
    26/06/2021
--]]

--[[
    State test
    HawDevelopment
    26/06/2021
--]]

return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local libs = require(ReplicatedStorage.libs)
	---@module Command
	local Command = require(libs.Command)

	local commands = {
		Hey = function()
			-- Hello!
		end,
		Bye = function()
			-- Bye! :(
		end,
	}

	describe("Command.new", function()
		it("should return a valid command", function()
			local command = Command.new()

			expect(command.__commands).to.be.a("table")
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				Command.new(10)
			end).to.be.throw()

			expect(function()
				Command.new(workspace)
			end).to.be.throw()
		end)

		it("should be able to be created using __call", function()
			expect(function()
				Command()
			end).to.never.be.throw()
		end)
	end)

	describe("Command.add", function()
		local command
		beforeEach(function()
			command = Command.new()
		end)

		it("should add a command", function()
			command.add(commands.Hey, "Hey")
			expect(command.__commands["Hey"]).to.be.ok()
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				command.add(true)
			end).to.be.throw()

			expect(function()
				command.add(commands.Bye, 10)
			end).to.be.throw()
		end)
	end)

	describe("Command.execute", function()
		local command
		beforeEach(function()
			command = Command.new()
		end)

		it("should execure a function", function()
			local res
			command.add(function()
				res = true
			end, "Test")

			expect(function()
				command.execute("Test")
			end).to.never.be.throw()

			expect(res).to.be.equal(true)
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				command.execute(10)
			end).to.be.throw()

			expect(function()
				command.execute(true)
			end).to.be.throw()
		end)
	end)
end
