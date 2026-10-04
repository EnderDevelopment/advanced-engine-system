local ESX = exports['es_extended']:getSharedObject()

local currentBoost = 0.0
local maxBoost = 0.0
local engineDamage = 0.0
local componentDurability = {}
local targetBoost = 0.0
local turboInstalled = false
local engineMenuOpen = false
local boostControllerOpen = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                local plate = GetVehicleNumberPlateText(vehicle)
                ESX.TriggerServerCallback('advancedenginesystem:getEngineData', function(data)
                    if data then
                        currentBoost = data.currentBoost
                        maxBoost = data.maxBoost
                        engineDamage = data.engineDamage
                        componentDurability = data.componentDurability
                        targetBoost = data.targetBoost
                        turboInstalled = data.turboInstalled
                    end
                end, plate)
                
                if turboInstalled then
                    DrawTurboGauge()
                    HandleBoostController(vehicle)
                end
                
                HandleEngineMenu(vehicle, plate)
            end
        end
    end
end)

function DrawTurboGauge()
    local x, y = 0.85, 0.85
    local width, height = 0.1, 0.05
    
    -- Draw background
    DrawRect(x, y, width, height, 0, 0, 0, 150)
    
    -- Draw boost bar
    local boostPercentage = currentBoost / maxBoost
    DrawRect(x - (width / 2) + (width * boostPercentage / 2), y, width * boostPercentage, height, 0, 255, 0, 200)
    
    -- Draw text
    SetTextFont(4)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(string.format(Config.Locales[Config.Locale].current_boost, currentBoost))
    DrawText(x, y - 0.01)
end

function HandleBoostController(vehicle)
    if IsControlJustPressed(1, 246) then -- N key
        boostControllerOpen = not boostControllerOpen
        if boostControllerOpen then
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boost_controller', {
                title = Config.Locales[Config.Locale].boost_controller,
                align = 'top-left',
                elements = {
                    {label = string.format(Config.Locales[Config.Locale].set_target_boost, targetBoost), value = 'set_boost'}
                }
            }, function(data, menu)
                if data.current.value == 'set_boost' then
                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_boost', {
                        title = Config.Locales[Config.Locale].set_target_boost
                    }, function(data2, menu2)
                        local newTargetBoost = tonumber(data2.value)
                        if newTargetBoost and newTargetBoost >= 0 and newTargetBoost <= maxBoost then
                            targetBoost = newTargetBoost
                            local plate = GetVehicleNumberPlateText(vehicle)
                            TriggerServerEvent('advancedenginesystem:setTargetBoost', plate, targetBoost)
                            menu2.close()
                        else
                            ESX.ShowNotification('Invalid boost value')
                        end
                    end, function(data2, menu2)
                        menu2.close()
                    end)
                end
            end, function(data, menu)
                menu.close()
            end)
        end
    end
end

function HandleEngineMenu(vehicle, plate)
    if IsControlJustPressed(1, 38) then -- E key
        engineMenuOpen = not engineMenuOpen
        if engineMenuOpen then
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'engine_menu', {
                title = Config.Locales[Config.Locale].engine_menu,
                align = 'top-left',
                elements = {
                    {label = Config.Locales[Config.Locale].install_component, value = 'install_component'},
                    {label = Config.Locales[Config.Locale].remove_component, value = 'remove_component'},
                    {label = string.format(Config.Locales[Config.Locale].engine_damage, engineDamage), value = 'engine_damage'}
                }
            }, function(data, menu)
                if data.current.value == 'install_component' then
                    OpenComponentMenu(vehicle, plate, 'install')
                elseif data.current.value == 'remove_component' then
                    OpenComponentMenu(vehicle, plate, 'remove')
                end
            end, function(data, menu)
                menu.close()
            end)
        end
    end
end

function OpenComponentMenu(vehicle, plate, action)
    local elements = {}
    
    for componentType, components in pairs(Config.Components) do
        for _, component in ipairs(components) do
            table.insert(elements, {
                label = component.name,
                value = component.item,
                type = componentType,
                durability = componentDurability[componentType] or 100
            })
        end
    end
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'component_menu', {
        title = action == 'install' and Config.Locales[Config.Locale].install_component or Config.Locales[Config.Locale].remove_component,
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if action == 'install' then
            TriggerServerEvent('advancedenginesystem:installComponent', plate, data.current.type, data.current.value)
        else
            TriggerServerEvent('advancedenginesystem:removeComponent', plate, data.current.type)
        end
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                local plate = GetVehicleNumberPlateText(vehicle)
                TriggerServerEvent('advancedenginesystem:updateEngineDamage', plate)
            end
        end
    end
end)