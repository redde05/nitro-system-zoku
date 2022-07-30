ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('nitro', function(source)
    local xPlayer  = ESX.GetPlayerFromId(source)
    local nitroquantity = xPlayer.getInventoryItem('nitro').count
    if nitroquantity > 0 then
        TriggerClientEvent('nitro:start', source)
    end
end)

RegisterServerEvent('nitro:removeInventoryItem')
AddEventHandler('nitro:removeInventoryItem', function(item, quantity)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, quantity)
end)
