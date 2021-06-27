--[[
    Chain tests
    HawDevelopment
    26/06/2021
--]]

return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local lib = require(ReplicatedStorage.lib)
	---@module Chain
	local Chain = require(lib.Chain)

	local chains = {
		function()
			return true
		end,
		function()
			return false, "Error!"
		end,
	}

	describe("Chain.new", function()
		it("should return a valid Chain", function()
			local Chain = Chain.new(chains)

			expect(Chain.__chain).to.be.a("table")
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				Chain.new(13)
			end).to.be.throw()

			expect(function()
				Chain.new(workspace)
			end).to.be.throw()
		end)

		it("should be able to be created using __call", function()
			expect(function()
				Chain()
			end).to.never.be.throw()
		end)
	end)

	describe("Chain.add", function()
		local chain
		beforeEach(function()
			chain = Chain.new(chains)
		end)

		it("should add a handler to the Chain", function()
			chain.add(function() end, 1)
			expect(#chain.__chain).to.be.equal(3)
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				chain.add(true)
			end).to.be.throw()

			expect(function()
				chain.add(function() end, "yes")
			end).to.be.throw()
		end)
	end)

	describe("Chain.execute", function()
		local chain
		beforeEach(function()
			chain = Chain.new(chains)
		end)

		it("should execute the chain", function()
			local res = true

			expect(function()
				res = chain.execute()
			end).to.never.be.throw()

			expect(res).to.be.equal(false)
		end)
	end)
end
