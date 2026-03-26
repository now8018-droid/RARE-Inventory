ESX = exports['es_extended']:getSharedObject()

-- Vault/Storage implementation
ESX.RegisterServerCallback('nongnut_inventory:vault:putItem', function(source, cb, vaultName, itemName, itemType, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Add verification if player has access to this vault
    
     if itemType == 'item_standard' then
        if xPlayer.getInventoryItem(itemName).count >= count then
            xPlayer.removeInventoryItem(itemName, count)
            -- Save to datastore/vault DB
            -- ...
             cb(true, count) 
        else
            cb(false)
        end
    end
end)

ESX.RegisterServerCallback('nongnut_inventory:vault:takeItem', function(source, cb, vaultName, itemName, itemType, count)
    local xPlayer = ESX.GetPlayerFromId(source)
     if xPlayer.canCarryItem(itemName, count) then
         -- Remove from vault DB check
         -- ...
         xPlayer.addInventoryItem(itemName, count)
         cb(true, count)
     else
        cb(false)
     end
end)

RegisterNetEvent('nongnut_inventory:closeVault', function(vaultName)
    -- Handle vault closure unlocking users
end)
