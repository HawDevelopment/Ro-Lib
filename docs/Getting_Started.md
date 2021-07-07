
## Basics

Ro-Lib has java-script-like syntax. Ro-Lib is divided up into smaller sub-modules that are modular and easy to use.
Heres a quik example of some Ro-Lib code improvements.

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

Ro-Lib has every pattern you need. It can be hard finding the right pattern, so heres all the patterns with their uses.

| Method      | Description                                               | Use                                                      |
| ----------- | --------------------------------------------------------- | -------------------------------------------------------- | 
| Chain       | Chain, pass checks along a chain                          | Good for auth and guard statements                       |
| Command     | Command, register and call functions                      | Works well for enemy systems and components              |
| Factory     | Factory, constructing classes                             | Creating lots of classes                                 |
| Observer    | Observer, observe instead of querying                     | Signal data structures                                   |
| Singleton   | Singleton, create only one object                         | Only creating one of a kind object                       |
| State       | State, changing and reactive variables                    | Changing values, or for things out of scope              |
| Strategy    | Strategy, family of callbacks to pick                     | Abilities and weapons                                    |

## Examples

Heres some examples for when to use the patterns.

??? example "Ability"
    
    When making abilities it's best if they are modular and short. Here's it's best to use Strategy and Factory to construct and use abilities.
    
??? example "Placement System"

    Placement systems can have a lot of functionality and controls. So it can be difficult to manage them all. Here it's best to use Observer for listening for events and Command to executing them.

??? example "Admin auth"

    Auth can have many if statements. It's here Chain really shines, helping clear up hundred lines of if statements.

??? example "Button state"

    State should be reactive, use State.