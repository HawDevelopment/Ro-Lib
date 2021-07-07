
# Examples

Sometimes it can be difficult to learn new libraries or understanding why to choose them. But no worry, I'm here to help!

Heres some examples of regular code, and improved code made with Ro-Lib.

=== "Bad Code"

    Taken from Vesteria levels module.

    ``` lua
    function module.getEquipmentInfo(itemBaseData)
        if itemBaseData then
            local level = itemBaseData.level or itemBaseData.minLevel
            if level then
                local stat = getStatForLevel(level)		

                local function sig(x)
                    local e = 2.7182818284590452353602874713527
                    return 15 / (1 + e^(-1 * (0.25 * x - 9)))
                end
                local cost = 1.35 * module.getQuestGoldFromLevel(level) * level^(1/3) * math.max(sig(level), 1)	
                local rarity = itemBaseData.rarity or "Common"
                if rarity == "Legendary" then
                    cost = cost * 2
                elseif rarity == "Rare" then
                    cost = cost * 1.5
                end
                local modifierData 
                if itemBaseData.equipmentSlot then
                    if itemBaseData.equipmentSlot == 1 then
                        local damage = stat					
                        cost = cost * 0.7
                        if rarity == "Legendary" then
                            damage = damage + 10
                        elseif rarity == "Rare" then
                            damage = damage + 5
                        end
                        return {damage = math.ceil(damage); cost = math.floor(cost); }
                    
                    elseif itemBaseData.equipmentSlot == 11 then
                        return {cost = math.floor(cost * 0.6)}
                    
                    else
                        local statUpgrade
                        
                        local defense
                        if itemBaseData.equipmentSlot == 8 then
                            defense = stat 
                            if rarity == "Legendary" then
                                defense = defense + 10
                            elseif rarity == "Rare" then
                                defense = defense + 5
                            end
                            cost = cost * 1
                            
                            defense = defense * (itemBaseData.defenseModifier or 1)
                            
                        elseif itemBaseData.equipmentSlot == 9 then
                            defense = 0
                            cost = cost * 0.35
                        elseif itemBaseData.equipmentSlot == 2 then
                            defense = 0
                            cost = cost * 0.5
                            local value = stat/5
                            local distribution = itemBaseData.statDistribution
                            
                            if itemBaseData.minimumClass == "hunter" then
                                distribution = distribution or {
                                    str = 0;
                                    dex = 1;
                                    int = 0;
                                    vit = 0;
                                }
                                statUpgrade = {
                                    str = 0;
                                    dex = 1;
                                    int = 0;
                                    vit = 0;
                                }
                            elseif itemBaseData.minimumClass == "warrior" then
                                distribution = distribution or {
                                    str = 1;
                                    dex = 0;
                                    int = 0;
                                    vit = 0;
                                }		
                                statUpgrade = {		
                                    str = 1;
                                    dex = 0;
                                    int = 0;
                                    vit = 0;
                                }		
                
                            elseif itemBaseData.minimumClass == "mage" then
                                distribution = distribution or {
                                    str = 0;
                                    dex = 0;
                                    int = 1;
                                    vit = 0;
                                }	
                                statUpgrade = {							
                                    str = 0;
                                    dex = 0;
                                    int = 1;
                                    vit = 0;
                                }	
                            end	
                            if distribution then
                                modifierData = {}
                                for stat, coefficient in pairs(distribution) do
                                    modifierData[stat] = math.floor(value * coefficient)
                                end
                            end				
                        end
                        if defense then
                            return {defense = math.ceil(defense); cost = math.floor(cost); modifierData = modifierData; statUpgrade = statUpgrade}
                        end
                        return false
                    end
                end
            end
        end
        return false
    end
    ```

=== "Good Code"

    

    ``` lua
    local lib = require(game.ReplicatedStorage.lib)
    
    
    function module.getEquipmentInfo(itemBaseData)
        assert(itemBaseData, "Expected item base data, got nil")
        
        local level = itemBaseData.level or itemBaseData.minLevel
        if not level then
            return false
        end
        
        local stat = getStatForLevel(level)		

        local function sig(x)
            local e = 2.7182818284590452353602874713527
            return 15 / (1 + e^(-1 * (0.25 * x - 9)))
        end
        
        local cost = 1.35 * module.getQuestGoldFromLevel(level) * level^(1/3) * math.max(sig(level), 1)	
        local rarity = itemBaseData.rarity or "Common"
        
        if rarity == "Legendary" then
            cost = cost * 2
        elseif rarity == "Rare" then
            cost = cost * 1.5
        end
        local modifierData 
        if itemBaseData.equipmentSlot then
            if itemBaseData.equipmentSlot == 1 then
                local damage = stat					
                cost = cost * 0.7
                if rarity == "Legendary" then
                    damage = damage + 10
                elseif rarity == "Rare" then
                    damage = damage + 5
                end
                return {damage = math.ceil(damage); cost = math.floor(cost); }
            
            elseif itemBaseData.equipmentSlot == 11 then
                return {cost = math.floor(cost * 0.6)}
            
            else
                local statUpgrade
                
                local defense
                if itemBaseData.equipmentSlot == 8 then
                    defense = stat 
                    if rarity == "Legendary" then
                        defense = defense + 10
                    elseif rarity == "Rare" then
                        defense = defense + 5
                    end
                    cost = cost * 1
                    
                    defense = defense * (itemBaseData.defenseModifier or 1)
                    
                elseif itemBaseData.equipmentSlot == 9 then
                    defense = 0
                    cost = cost * 0.35
                elseif itemBaseData.equipmentSlot == 2 then
                    defense = 0
                    cost = cost * 0.5
                    local value = stat/5
                    local distribution = itemBaseData.statDistribution
                    
                    if itemBaseData.minimumClass == "hunter" then
                        distribution = distribution or {
                            str = 0;
                            dex = 1;
                            int = 0;
                            vit = 0;
                        }
                        statUpgrade = {
                            str = 0;
                            dex = 1;
                            int = 0;
                            vit = 0;
                        }
                    elseif itemBaseData.minimumClass == "warrior" then
                        distribution = distribution or {
                            str = 1;
                            dex = 0;
                            int = 0;
                            vit = 0;
                        }		
                        statUpgrade = {		
                            str = 1;
                            dex = 0;
                            int = 0;
                            vit = 0;
                        }		
        
                    elseif itemBaseData.minimumClass == "mage" then
                        distribution = distribution or {
                            str = 0;
                            dex = 0;
                            int = 1;
                            vit = 0;
                        }	
                        statUpgrade = {							
                            str = 0;
                            dex = 0;
                            int = 1;
                            vit = 0;
                        }	
                    end	
                    if distribution then
                        modifierData = {}
                        for stat, coefficient in pairs(distribution) do
                            modifierData[stat] = math.floor(value * coefficient)
                        end
                    end				
                end
                if defense then
                    return {defense = math.ceil(defense); cost = math.floor(cost); modifierData = modifierData; statUpgrade = statUpgrade}
                end
                return false
            end
        end
        
    
        return false
    end
    ```