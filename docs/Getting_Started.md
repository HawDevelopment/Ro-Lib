
## Basics

Ro-Lib has java-script-like syntax. It's divided up into smaller sub-modules that are easy to use. It has a lot of modules, so that will be at least one that's useful for you.

If you are still unsure here's something for you.

=== "Bad code"

    ``` lua
    local function FistAttack()
        -- ...
    end

    local function KickAttack()
        -- ...
    end

    local function MagicAttack()
        -- ...
    end

    local selected = "Fist"
    local function Attack(...)
        
        if selected == "Fist" then
            FistAttack(...)
        elseif selected == "Kick" then
            KickAttack(...)
        elseif selected == "Magic" then
            MagicAttack(...)
        else
            warn("Could not find Attack with name: " .. selected)
        end
    end
    ```

=== "Good code"

    ``` lua
    local Command = require(lib.Command)

    local command = Command.new({
        Fist = function()
            -- ...
        end,

        Kick = function()
            -- ...
        end,

        Magic = function()
            -- ...
        end,
    })
    
    local selected = "Fist"
    local function Attack(...)
        command.execute(selected, ...)
    end
    ```


## Patterns

Ro-Lib has every pattern you would want, and there's a lot. So here's a list with all patterns and their uses.

| Method      | Description                                               | Use                                                      |
| ----------- | --------------------------------------------------------- | -------------------------------------------------------- | 
| Chain       | Chain allows you to pass checks along a chain             | Good for auth and checking inputs                        |
| Command     | Command allows you to register and call functions         | Works weel for enemy systeams and components             |
| Factory     | Factory is used when for constructing classes             | When you have need to create many classes                |
| Observer    | Observer can be used instead of querying                  | Makes events a lot better to use                         |
| Singleton   | Singletong for when you only need one instance of a class | Useful for services, when you only wanr one instance     |
| State       | State can be used for changing and reactive variables     | When you have constantly changing values                 |
| Strategy    | Strategy when you have a family of callbacks to pick      | Best with abilityis, works will with Command and Factory |

## Examples

It's maybe hard to figure out when to use which patterns, so here are some examples to help.

??? example "Ability"
    
    When making abilities it can be best if they are modular and short. Here's it best to use Strategy and Factory to construct and use abilities.
    
??? example "Placement System"

    Placement systems can have lots of functionality and controls. So it can be hard managing them all. But using Observer to listen for events and Command to execute them can make it much easier.

??? example "Admin auth"

    For auth, the chain of responsibility (scary name) is the best choice. The chain can help clear up if statements.

??? example "Button state"

    Of course, you should use state for state management.

??? example "Round manager"

    You should use singleton for round management, you wouldn't want two have to manager or two rounds in the same place.