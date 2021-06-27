--[[
    Singleton Tests
    HawDevelopment
    14/06/2021
--]]

return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local lib = require(ReplicatedStorage.libs)
	local Singleton = require(lib.Singleton)

	local function ObjectCreater()
		return {
			Name = "HawDevelopment",
			Skill = "Scripting",
			Iq = -10,
		}
	end

	describe("Singleton.new", function()
		it("should create a valid singleton", function()
			local singleton
			expect(function()
				singleton = Singleton.new(ObjectCreater)
			end).to.never.be.throw()

			expect(singleton.__creator).to.be.equal(ObjectCreater)
			expect(singleton.__obj).to.be.equal(nil)
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				Singleton.new()
			end).to.be.throw()

			expect(function()
				Singleton.new("Yes")
			end).to.be.throw()

			expect(function()
				Singleton.new(420)
			end).to.be.throw()
		end)

		it("should be able to be created using __call", function()
			expect(function()
				Singleton(ObjectCreater)
			end).to.never.be.throw()
		end)
	end)

	describe("Singleton.get", function()
		local singleton
		beforeEach(function()
			singleton = Singleton.new(ObjectCreater)
		end)

		it("should return the singleton", function()
			local ret
			expect(function()
				ret = singleton.get()
			end).to.never.be.throw()

			expect(ret).to.be.a("table")
			expect(ret.Name).to.be.equal("HawDevelopment")
			expect(ret.Iq).to.be.equal(-10)
			expect(ret.Skill).to.be.equal("Scripting")
		end)

		it("should be able to be created using __call", function()
			expect(function()
				singleton(ObjectCreater)
			end).to.never.be.throw()
		end)
	end)

	describe("Singleton.destroy", function()
		local singleton
		beforeEach(function()
			singleton = Singleton.new(ObjectCreater)
		end)

		it("should destroy the current object", function()
			local ret
			expect(function()
				ret = singleton.get()
			end).to.never.be.throw()

			singleton.destroy()
			expect(singleton.__obj).to.be.equal(nil)

			expect(singleton.get()).to.never.be.equal(ret)
		end)
	end)
end
