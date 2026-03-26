ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('nongnut_inventory:getTrunk', function(source, cb, plate)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)
    -- In a real scenario, you'd fetch trunk data from DB or array based on plate
    -- For now, returning empty/default
    local trunkData = {
        items = {},
        weapons = {},
        accounts = {}
    }
    
    -- Example: Query DB for trunk_inventory WHERE plate = plate
     MySQL.Async.fetchAll('SELECT * FROM trunk_inventory WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        if result[1] then
            local data = json.decode(result[1].data)
            cb(data, 0, 100000) -- weight, maxWeight
        else
            cb({}, 0, 100000)
        end
    end)
end)

ESX.RegisterServerCallback('nongnut_inventory:trunk:putItem', function(source, cb, plate, itemName, itemType, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Logic to remove from player and add to DB trunk
    -- ...
    
    if itemType == 'item_standard' then
        if xPlayer.getInventoryItem(itemName).count >= count then
            xPlayer.removeInventoryItem(itemName, count)
            -- Save to DB trunk
            -- ...
            cb(true, count, 0) -- success, count, newWeight
        else
            cb(false)
        end
    end
    -- Add other types
end)

ESX.RegisterServerCallback('nongnut_inventory:trunk:takeItem', function(source, cb, plate, itemName, itemType, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Logic to remove from DB trunk and add to player
    
     if xPlayer.canCarryItem(itemName, count) then
         -- Remove from DB
         -- ...
         xPlayer.addInventoryItem(itemName, count)
         cb(true, count, 0)
     else
        cb(false)
     end
end)
