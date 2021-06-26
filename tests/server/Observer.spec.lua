--[[
    Observer tests
    HawDevelopment
    24/06/2021
--]]

return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local lib = require(ReplicatedStorage.libs)
	---@module Observer
	local Observer = require(lib.Observer)

	describe("Observer.new", function()
		it("should create a valid observer", function()
			local observer
			expect(function()
				observer = Observer.new()
			end).to.never.be.throw()

			expect(observer.__listeners).to.be.a("table")
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				Observer.new(game)
			end).to.be.throw()

			expect(function()
				Observer.new("Yes")
			end).to.be.throw()

			expect(function()
				Observer.new(420)
			end).to.be.throw()
		end)

		it("should be able to be created using __call", function()
			expect(function()
				Observer()
			end).to.never.be.throw()
		end)
	end)

	describe("Observer.add", function()
		---@type Observer
		local observer

		beforeEach(function()
			observer = Observer.new()
		end)

		it("should add handler to listners", function()
			expect(function()
				observer.add(function() end)
			end).to.never.be.throw()

			expect(#observer.__listeners).to.be.equal(1)
		end)

		it("should return a function", function()
			local func = observer.add(function() end)

			expect(func).to.be.a("function")
			expect(#observer.__listeners).to.be.equal(1)

			func()

			expect(#observer.__listeners).to.be.equal(0)
		end)

		it("should work with types", function()
			observer.add(function() end, "Hello!")

			expect(#observer.__listeners["Hello!"]).to.be.equal(1)
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				observer.add("Yes", 1)
			end).to.be.throw()

			expect(function()
				observer.add(10, game)
			end).to.be.throw()

			expect(function()
				observer.add({})
			end).to.be.throw()
		end)
	end)

	describe("Observer.fire", function()
		---@type Observer
		local observer

		beforeEach(function()
			observer = Observer.new()
		end)

		it("should fire listners", function()
			local res = false

			observer.add(function()
				res = true
			end)
			observer.fire()

			expect(res).to.be.equal(true)
		end)

		it("should fire listners with types", function()
			local res = false

			observer.add(function()
				res = true
			end, "Hello!")
			observer.fire("Hello!")

			expect(res).to.be.equal(true)
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				observer.fire({}, true)
			end).to.be.throw()
		end)
	end)
end
