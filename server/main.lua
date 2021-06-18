ESX = nil

-- base
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

-- update coords
RegisterServerEvent("pp-teleport:updateCoords")
AddEventHandler("pp-teleport:updateCoords", function(coords)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer ~= nil then
        xPlayer.updateCoords(coords)
    end
end)