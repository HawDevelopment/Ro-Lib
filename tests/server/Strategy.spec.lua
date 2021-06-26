--[[
    Strategy tests
    HawDevelopment
    23/06/2021
--]]

return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local lib = require(ReplicatedStorage.libs)

	---@module Strategy
	local Strategy = require(lib.Strategy)

	local handles = {
		Support = function(name)
			return "Support " .. tostring(name)
		end,
		Ticket = function(name)
			return "Ticket " .. tostring(name)
		end,
	}

	describe("Strategy.new", function()
		it("should return a valid strategy", function()
			local strat = Strategy.new(handles, "Support")

			expect(strat.__handles).to.be.a("table")
			expect(strat.__strategy).to.be.a("function")
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				Strategy.new("Sup")
			end).to.be.throw()

			expect(function()
				Strategy.new(69)
			end).to.be.throw()
		end)

		it("should be able to be created using __call", function()
			expect(function()
				Strategy(handles)
			end).to.never.be.throw()
		end)
	end)

	describe("Strategy.set", function()
		local strat
		beforeEach(function()
			strat = Strategy.new(handles)
		end)

		it("should set the current strategy", function()
			-- Reset strategy
			strat.__strategy = nil
			strat.set("Ticket")

			expect(strat.__strategy).to.be.a("function")
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				strat.set(game)
			end).to.be.throw()

			expect(function()
				strat.set()
			end).to.be.throw()

			expect(function()
				strat.set({})
			end).to.be.throw()
		end)

		it("should error if strategy isnt found", function()
			expect(function()
				strat.set("Developer")
			end).to.be.throw()
		end)
	end)

	describe("Strategy.call", function()
		local strat
		beforeEach(function()
			strat = Strategy.new(handles, 1)
		end)

		it("should call strategy and return its value", function()
			-- Just to be sure
			strat.set("Support")

			local ret
			expect(function()
				ret = strat.call("1")
			end).to.never.be.throw()

			expect(ret).to.be.equal("Support 1")
		end)

		it("should error if no strategy is set", function()
			strat.__strategy = nil
			expect(function()
				strat.call()
			end).to.be.throw()
		end)

		it("should be able to be called using __call", function()
			strat.set("Ticket")

			local ret
			expect(function()
				ret = strat("1")
			end).to.never.be.throw()

			expect(ret).to.be.equal("Ticket 1")
		end)
	end)
end
