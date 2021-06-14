--[[
    Factory Tests
    HawDevelopment
    11/06/2021
--]]

return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local Factory = require(ReplicatedStorage.libs.Factory)
	local t = require(ReplicatedStorage.t)

	local factoryEnum = {
		Developer = 1,
		Tester = 2,
	}

	local factories = {
		Developer = function(tab, name, age)
			tab.Name = name
			tab.Age = age
			tab.Profession = "Developer"
		end,
		Tester = function(tab, name, age)
			tab.Name = name
			tab.Age = age
			tab.Profession = "Tester"
		end,
	}

	describe("Factory.new", function()
		it("should create a valid factory", function()
			-- Enum, Table
			local factory = Factory.new(factoryEnum, factories)

			expect(factory.__factories).to.be.a("table")
			expect(factory.__enum).to.be.a("table")

			-- Factory should make a cope of input
			expect(factory.__factoris).to.never.be.equal(factories)
			expect(factory.__enum).to.never.be.equal(factoryEnum)

			-- Should be callable
			expect(getmetatable(factory).__call).to.be.a("function")
		end)

		it("should throw if given wrong arguments", function()
			expect(function()
				Factory.new(nil, nil)
			end).to.be.throw()

			expect(function()
				Factory.new("Factory", 10)
			end).to.be.throw()

			expect(function()
				Factory.new(game, function()
				end)
			end).to.be.throw()
		end)

		it("should error if enum doesnt line up with factories", function()
			expect(function()
				Factory.new({
					Developer = 1,
					CEO = 2,
				}, {
					CEO = function()
					end,
				})
			end).to.be.throw()
		end)

		it("should be able to be created using __call", function()
			local factory = Factory(factoryEnum, factories)

			expect(factory).to.be.a("table")
		end)
	end)

	describe("Factory.create", function()
		local factory = Factory(factoryEnum, factories)

		it("should create a valid class", function()
			local class = factory.create(1, "HawDevelopment", 69)

			expect(class.Name).to.be.equal("HawDevelopment")
			expect(class.Age).to.be.equal(69)
			expect(class.Profession).to.be.equal("Developer")
		end)

		it("should be able to use string as a type", function()
			local class = factory.create("Developer", "HawDevelopment", 69)

			expect(class.Name).to.be.equal("HawDevelopment")
			expect(class.Age).to.be.equal(69)
			expect(class.Profession).to.be.equal("Developer")
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				factory.create(nil, 10, {})
			end).to.be.throw()

			expect(function()
				factory.create("yes", {}, "what")
			end).to.be.throw()
		end)

		it("should comply with Factory rules", function()
			local ruleFactory = Factory.new(factoryEnum, factories)
			ruleFactory.rule({
				Factory.Type.string,
				t.number,
			})

			expect(function()
				ruleFactory.create(1, 1, "10")
			end).to.be.throw()

			expect(function()
				ruleFactory.create(1, "1", 10)
			end).to.never.be.throw()
		end)

		it("should comply with Factory bases", function()
			local baseFactory = Factory.new(factoryEnum, {
				Developer = function()
				end,
				Tester = function()
				end,
			})

			baseFactory.base({
				Name = Factory.Argument(1),
				Age = Factory.Argument(2),
			})

			local class = baseFactory.create(1, "HawDevelopment", 420)

			expect(class.Name).to.be.equal("HawDevelopment")
			expect(class.Age).to.be.equal(420)
		end)
	end)

	describe("Factory.rule", function()
		---@type Factory
		local factory = Factory.new(factoryEnum, factories)

		beforeAll(function()
			factory.rule(nil)
		end)

		it("should set the rule", function()
			local rule = {
				Factory.Type.string,
				Factory.Type.number,
			}

			factory.rule(rule)

			expect(factory.__rule).to.be.a("table")
			expect(factory.__rule).to.never.be.equal(rule)

			factory.rule(nil)

			expect(factory.__rule).to.be.equal(nil)
		end)

		it("should be able to be given nil", function()
			expect(function()
				factory.rule({})
				factory.rule(nil)
			end).never.to.be.throw()

			expect(factory.__rule).to.be.equal(nil)
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				factory.rule("Yes")
			end).to.be.throw()

			expect(function()
				factory.rule(20)
			end).to.be.throw()
		end)

		it("could be used with osyrisrblx/t module", function()
			local ruleFactory = Factory.new(factoryEnum, factories)
			ruleFactory.rule({
				t.string,
				t.number,
			})

			expect(function()
				ruleFactory.create(1, 30, game)
			end).to.be.throw()

			expect(function()
				ruleFactory.create(1, "HawDevelopment", 69)
			end).to.never.be.throw()
		end)
	end)

	describe("Factory.base", function()
		local factory = Factory.new(factoryEnum, factories)

		beforeAll(function()
			factory.rule(nil)
			factory.base(nil)
		end)

		it("should set the base", function()
			local base = {
				Name = Factory.Argument(1),
				Age = Factory.Argument(2),
			}

			factory.base(base)

			expect(factory.__base).to.be.a("table")
			expect(factory.__base).to.never.be.equal(base)
		end)

		it("should be able to be given nil", function()
			expect(function()
				factory.base({})
				factory.base(nil)
			end).never.to.be.throw()

			expect(factory.__base).to.be.equal(nil)
		end)

		it("should error if given wrong arguments", function()
			expect(function()
				factory.base("No")
			end).to.be.throw()

			expect(function()
				factory.base(12)
			end).to.be.throw()
		end)
	end)
end
