
### lib

Houses all the components of Ro-Lib.
Contains:

* Chain
* Command
* Factory
* Observer
* Singleton
* State
* Strategy

All patterns are classes. When calling a method you should use `.` instead of `:`

``` lua
-- DONT
chain:add()
state:set()
Strategy.new()

-- DO
chain.set()
state.set()
Strategy()
```

## Chain

First, add handlers to the chain. Each handler should return a boolean if it succeeds.
Then when executing, it calls each handler one step at a time. If one returns false, it will warn and stop.

Chain or chain of responsibility is used often for auth and guard statements.

### `Chain.new`

`Chain.new(chain: {[number]: function}?, shouldWarn: boolean?): Chain`

Creates a new chain.
if shouldWarn is set to true it will warn on fail. Defualts to false.

``` lua
local lib = require(path.to.lib)
local Chain = require(lib.Chain)

local chain1 = Chain()

-- Or

local chain2 = Chain({
    function() end,
})
```

### `Chain.add`

`Chain.add(handler: function, index: number?): self`

Adds a new handler to the chain.
The handler function should return a boolean.

``` lua
local lib = require(path.to.lib)
local Chain = require(lib.Chain)

local chain = Chain()

chain.add(function()
    print("Hello world!")
end)

-- When the chain is called it will print!
```

### `Chain.execute`

`Chain.execute(...any): boolean`

Executes the current chain, returns false on fail.

``` lua
local lib = require(path.to.lib)
local Chain = require(lib.Chain)

local chain = Chain()

local res = true
chain.add(function()
    res = false
    
    -- Se we dont get a warn
    return true
end)

-- You could use chain() here
chain.execute()

print(res) -> false
```

## Command

Register functions and then later call them by name. Use when you have lots of functions bound to one object.

### `Command.new`

`Command.new(commands: {[string]: function}?): Command`

Creates a new command.
Command handlers are just a regular function.

``` lua
local lib = require(path.to.lib)
local Command = require(lib.Command)

Command.new()

-- Or

Command({
    Name = function end
})
```

### `Command.add`

`Command.add(command: function, name: string)`

Adds a new handler to the command.

``` lua
local lib = require(path.to.lib)
local Command = require(lib.Command)

local command = Command.new()

command.add(function()
    print("Hello world!")
end, "Hello")

-- When the Hello handler is called it will print!
```

### `Command.execute`

`Command.execute(name: string, ...any): any`

Calls the specified handler.

``` lua
local lib = require(path.to.lib)
local Command = require(lib.Command)

local command = Command.new()

command.add(function(arg)
    print(arg)
end, "Hello")

command.execute("Hello", "Hello world!")
```

## Factory

Create an enum with corresponding name and function, and start creating classes at your will.
This is what a defualt factory looks like:

``` lua
local lib = require(path.to.lib)
local Factory = require(lib.Factory)

local enum = {
    Support = 1,
    Ticket = 2,
}

local funcs = {
    Support = function()
        print("Support!")
    end,
    Ticket = function()
        print("Ticket!")
    end,
}

local factory = Factory.new(enum, funcs)
```


### `Factory.new`

`Factory.new(enum: {[string]: number}, factories: {[string]: function}): Factory`

Creates a new factory
Factory functions should only modify the table given to them.

``` lua
local lib = require(path.to.lib)
local Factory = require(lib.Factory)

local enum = {
    Dev = 1,
    Mod = 2,
}

local funcs = {
    Dev = function(class)
        print("Develper!")
        class.Name = "Developer"
    end,
    Mod = function(class)
        print("Moderator!")
        class.Name = "Moderator"
    end,
}

Factory.new(enum, funcs)
```

### `Factory.create`

`Factory.create(type: string | number, ...any)`

Creates a new class, using the specified function.

``` lua
local lib = require(path.to.lib)
local Factory = require(lib.Factory)

local factory = Factory.new({
    Dev = 1,
    Mod = 2,
}, {
    Dev = function(class)
        class.Name = "Developer"
    end,
    Mod = function(class)
        class.Name = "Moderator"
    end,
})

factory.create("Dev") -> {Name = "Developer"}

-- Or

factory.create(2) -> {Name = "Moderator"}
```

### `Factory.rule`

`Factory.rule(rule: {[number]: function}?)`

Sets the current rules, useful when having lots of similar agruments.
The rules are just a table, each index will be called with argument of that index and should return true or false.

``` lua
local lib = require(path.to.lib)
local Factory = require(lib.Factory)

local factory = Factory.new({
    Hello = 1
}, {
    Hello = function(class, name)
        
        class.Message = "Hello, " .. name
        
    end,
})

factory.rule({
    Factory.Type.string,
})

-- Or you can use t by osyrisrblx: https://github.com/osyrisrblx/t

factory.rule({
    t.string,
})

-- Will error
factory.create(1, 10)
factory.create(1, nil)
factory.create(1, workspace)

-- WON'T error
factory.create(1, "HawDevelopment")
factory.create(1, "Elttob")
factory.create(1, "Berezaa")
```

### `Factory.base`

`Factory.base(base: {[string]: any})`

Sets the current base.
A base is just the base class of any class created. You can also use `Factory.Argument` for linking arguments to the base.

``` lua
local lib = require(path.to.lib)
local Factory = require(lib.Factory)

local factory = Factory.new({
    Test = 1
}, {
    Test = function(class)
        -- Wont do anything
    end,
})

factory.base({
    Name = Factory.Argument(1),
    Age = 13,
    Skill = "Scripting",
})

-- Base can be used for repetative things
factory.create(1, "HawDevelopment") -> {Name = "HawDevelopment", Age = 13, Skill = "Scripting"}
```

## Observer

You probably know Signals. Observers work mostly in the same way, the only difference is that you have many "watchers" bound to one observer, and you can have many underlying types.
Types are like sub observer. So this is what a regular observer could look like:

* function
* function
* Sub:
    * function
    * function

### Observer.new

`Observer.new(watcher: {[any]: function}?): Observer`

Creates a new observer.
A watcher is a function that will be called when the observer is fires.

``` lua
local lib = require(path.to.lib)
local Observer = require(lib.Observer)

Observer.new()

-- Or

Observer({
    function() end,
})
```

### Observer.add

`Observer.add(watcher: function, type: string?)`

Adds a new watcher, you can also give it a type.

``` lua
local lib = require(path.to.lib)
local Observer = require(lib.Observer)

local observer = Observer.new()

observer.add(function() end)

-- Or

observer.add(function() end, "Sub")
```

### Observer.fire

`Observer.fire(type: string | "All" | nil, ...any)`

Fires the observer, if a type is given that isnt "All" it will only call watchers of that type.

``` lua
local lib = require(path.to.lib)
local Observer = require(lib.Observer)

local observer = Observer.new()

observer.add(function()
    print("1")
end)

observer.add(function()
    print("2")
end, "Sub")

observer.fire() -- "1" will print

observer.fire("Sub") -- "2" will print
```

## Singleton

Would you need more than one round? Using singleton you can create one class and then use it all over your program, no need to check if it exists.
It doesn't create the class before you call the get method for the first time.


### Singleton.new

`Singleton.new(constructor: function | table): Singleton`

Creates a new singleton.
The constructor can be a function or a class with a `.new` function, should return the value to be set as the singleton value.

``` lua
local lib = require(path.to.lib)
local Singleton = require(lib.Singleton)

Singleton.new(function()

end)

-- Or

Singleton({
    new = function()
        
    end
})
```

### Singleton.get

`Singleton.get(): any`

Gets the current storring object of the singleton, if it hasnt been created it will call the constructor.

``` lua
local lib = require(path.to.lib)
local Singleton = require(lib.Singleton)

local singleton = Singleton.new(function()
    return {
        Name = "HawDevelopment"
    }
end)

-- Havent been creating so it calls the constructor
local ret = singleton.get()

-- Returns the same table
print(ret == singleton.get()) -> true
```

### Singleton.destroy

`Singleton.destroy()`

Destroys the current object stored.

``` lua
local lib = require(path.to.lib)
local Singleton = require(lib.Singleton)

local singleton = Singleton.new(function()
    return {
        Name = "HawDevelopment"
    }
end)


local ret = singleton.get()

singleton.destroy()

print(ret == singleton.get()) -> false
```

## State

Sometimes it can be hard to manage player state.

### State.new

`State.new(defualt: any?, observer: Observer): State`

Creates a new state.
If an obsever is given, it will be used instead of creating a new one. The observer of the state will be called when a new state has been set.


``` lua
local lib = require(path.to.lib)
local State = require(lib.State)


State.new()

-- Or

State("Hello", Observer.new())
```

### State.observer

`State.observer(observer: Observer)`

Sets the current observer.

``` lua
local lib = require(path.to.lib)
local State = require(lib.State)
local Observer = require(lib.Observer)

local state = State.new()

state.observer(Observer.new())
```

### State.bind

`State.bind(callback: function, type: string?)`

Binds the callback to the internal observer of the state.

``` lua
local lib = require(path.to.lib)
local State = require(lib.State)

local state = State.new()

state.bind(function(arg)
    print(arg)
end)

state.set("Hello world") -- prints "Hello world!"

-- You can also bind to a specific type
state.bind(function(arg)
    print(arg)
end, "Function 2")

state.set("Number 2!", "Function 2") -- prints "Number 2!"
```

### State.set

`State.set(state: any, type: string?)`

Sets the current state.
It will also call the current observer with the new state. If a type is given, it will only call functions bound to that type in the observer.

``` lua
local lib = require(path.to.lib)
local State = require(lib.State)

local state = State.new()

state.set("Hello world")

print(state.get()) -> "Hello world!"
```

### State.get

`State.get(): any`

Returns the current set state.

``` lua
local lib = require(path.to.lib)
local State = require(lib.State)

local state = State.new()

state.set("Whats up?")

print(state.get() == "Whats up?") -> true
```

## Strategy

Have you ever had different changing selections that require a specific function? With Strategy you register functions with a specific name, then later set it as the strategy and then execute the function at will.
Especially useful for changing powers and abilities.

### Strategy.new

`Strategy.new(handles: {[string]: function}, start: string?): Strategy`

Creates a new strategy.
If start is given it will set the index to it.

``` lua
local lib = require(path.to.lib)
local Strategy = require(lib.Strategy)

Strategy.new()

-- Or

Strategy({
    Name = function()
        
    end
}, "Name")
```

### Strategy.add

`Strategy.add(handler: function, name: string)`

Adds the handler to the list of handlers in the strategy.

``` lua
local lib = require(path.to.lib)
local Strategy = require(lib.Strategy)

local strategy = Strategy.new()

strategy.add(function()
    
end, "Name")
```

### Strategy.set

`Strategy.set(name: string | State)`

Sets the current strategy.

!!! warning "State"
    
    If a state is given, it will get the current state and set that as the strategy, and **NOT** update the strategy when the state updates.

``` lua
local lib = require(path.to.lib)
local Strategy = require(lib.Strategy)
local State = require(lib.State)

local strategy = Strategy.new()

strategy.add(function(arg)
    print(arg)
end, "Hello")

strategy.set("Hello")

-- Is the same as

local state = State.new()
state.set("Hello")

strategy.set(state)
```

### Strategy.call

`Strategy.call(...any): any`

Calls the current set strategy with given args.

``` lua
local lib = require(path.to.lib)
local Strategy = require(lib.Strategy)

local strategy = Strategy.new()

strategy.add(function()
    return 1 + 1
end, "Plus")

strategy.set("Plus")

print(strategy.call()) -> 2
```

