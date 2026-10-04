local ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('advancedenginesystem:getEngineData', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    MySQL.Async.fetchAll('SELECT * FROM engine_components WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        if result[1] then
            local data = {
                currentBoost = 0.0,
                maxBoost = 0.0,
                engineDamage = 0.0,
                componentDurability = {
                    pistons = result[1].pistons_durability or 100,
                    conrods = result[1].conrods_durability or 100,
                    head = result[1].head_durability or 100,
                    valves = result[1].valves_durability or 100,
                    radiator = result[1].radiator_durability or 100,
                    turbo = result[1].turbo_durability or 100
                },
                targetBoost = result[1].target_boost or 0.0,
                turboInstalled = result[1].turbo ~= nil
            }
            
            MySQL.Async.fetchAll('SELECT damage FROM engine_damage WHERE plate = @plate', {
                ['@plate'] = plate
            }, function(damageResult)
                if damageResult[1] then
                    data.engineDamage = damageResult[1].damage
                end
                
                for _, component in ipairs(Config.Components.turbo) do
                    if component.item == result[1].turbo then
                        data.maxBoost = component.maxBoost
                        break
                    end
                end
                
                cb(data)
            end)
        else
            cb(nil)
        end
    end)
end)

RegisterNetEvent('advancedenginesystem:installComponent')
AddEventHandler('advancedenginesystem:installComponent', function(plate, componentType, componentItem)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(componentItem)
    
    if item.count > 0 then
        MySQL.Async.execute('INSERT INTO engine_components (plate, @componentType, @componentType_durability) VALUES (@plate, @componentItem, 100) ON DUPLICATE KEY UPDATE @componentType = @componentItem, @componentType_durability = 100', {
            ['@plate'] = plate,
            ['@componentType'] = componentType,
            ['@componentType_durability'] = componentType .. '_durability',
            ['@componentItem'] = componentItem
        }, function(rowsChanged)
            xPlayer.removeInventoryItem(componentItem, 1)
            TriggerClientEvent('esx:showNotification', source, 'Component installed successfully')
        end)
    else
        TriggerClientEvent('esx:showNotification', source, 'You do not have this component')
    end
end)

RegisterNetEvent('advancedenginesystem:removeComponent')
AddEventHandler('advancedenginesystem:removeComponent', function(plate, componentType)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    MySQL.Async.fetchAll('SELECT @componentType FROM engine_components WHERE plate = @plate', {
        ['@plate'] = plate,
        ['@componentType'] = componentType
    }, function(result)
        if result[1] and result[1][componentType] then
            local componentItem = result[1][componentType]
            
            MySQL.Async.execute('UPDATE engine_components SET @componentType = NULL, @componentType_durability = NULL WHERE plate = @plate', {
                ['@plate'] = plate,
                ['@componentType'] = componentType,
                ['@componentType_durability'] = componentType .. '_durability'
            }, function(rowsChanged)
                xPlayer.addInventoryItem(componentItem, 1)
                TriggerClientEvent('esx:showNotification', source, 'Component removed successfully')
            end)
        else
            TriggerClientEvent('esx:showNotification', source, 'No component installed')
        end
    end)
end)

RegisterNetEvent('advancedenginesystem:setTargetBoost')
AddEventHandler('advancedenginesystem:setTargetBoost', function(plate, targetBoost)
    MySQL.Async.execute('UPDATE engine_components SET target_boost = @targetBoost WHERE plate = @plate', {
        ['@plate'] = plate,
        ['@targetBoost'] = targetBoost
    })
end)

RegisterNetEvent('advancedenginesystem:updateEngineDamage')
AddEventHandler('advancedenginesystem:updateEngineDamage', function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    MySQL.Async.fetchAll('SELECT * FROM engine_components WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        if result[1] then
            local damage = 0.0
            
            for componentType, durability in pairs(result[1]) do
                if componentType:find('_durability') then
                    local component = componentType:gsub('_durability', '')
                    if durability < 100 then
                        damage = damage + (100 - durability) * (Config.DamageRates[component] or 0.1)
                    end
                end
            end
            
            MySQL.Async.execute('INSERT INTO engine_damage (plate, damage) VALUES (@plate, @damage) ON DUPLICATE KEY UPDATE damage = @damage', {
                ['@plate'] = plate,
                ['@damage'] = damage
            })
        end
    end)
end)