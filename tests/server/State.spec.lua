--[[
    State test
    HawDevelopment
    26/06/2021
--]]

return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local lib = require(ReplicatedStorage.lib)
	local Observer = require(lib.Observer)
	---@module State
	local State = require(lib.State)

	describe("State.new", function()
		it("should return a valid state", function()
			local state = State.new(true)

			expect(state.__observer).to.be.a("table")
			expect(state.__state).to.be.equal(true)
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				State.new(nil, 10)
			end).to.be.throw()

			expect(function()
				State.new(nil, game)
			end).to.be.throw()
		end)

		it("should be able to be created using __call", function()
			expect(function()
				State()
			end).to.never.be.throw()
		end)
	end)

	describe("State.observer", function()
		local state
		beforeEach(function()
			state = State.new()
		end)

		it("should set observer", function()
			local observer = Observer.new()

			state.observer(observer)
			expect(state.__observer).to.be.equal(observer)
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				State.new(true, "Sup")
			end).to.be.throw()

			expect(function()
				State.new(true, 10)
			end).to.be.throw()
		end)
	end)

	describe("State.bind", function()
		local state
		beforeEach(function()
			state = State.new()
		end)

		it("should bind a function", function()
			expect(function()
				state.bind(function()
					print("Hello world!")
				end)
			end).to.never.be.throw()
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				state.bind("yes")
			end).to.be.throw()

			expect(function()
				state.bind(function() end, workspace)
			end).to.be.throw()
		end)
	end)

	describe("State.set", function()
		local state
		beforeEach(function()
			state = State.new()
		end)

		it("should set the state", function()
			state.set(10)

			expect(state.__state).to.be.equal(10)
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				state.set(1, game)
			end).to.be.throw()

			expect(function()
				state.set(1, false)
			end).to.be.throw()
		end)
	end)

	describe("State.get", function()
		local state
		beforeEach(function()
			state = State.new()
		end)

		it("should return the state", function()
			state.set(10)

			expect(state.get()).to.be.equal(10)
		end)
	end)
end
