ESX = nil

local PlayerData = {}

AddEventHandler("onClientResourceStart", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    while (function()
        if ESX == nil then
            return true
        end

        if ESX.GetPlayerData().job == nil then
            return true
        end

        PlayerData = ESX.GetPlayerData()
    end)() do
        ESX = exports["es_extended"]:getSharedObject()
        Citizen.Wait(500)
    end
end)

-- job
RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	PlayerData.job = job
end)

-- text
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- marker
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local inRange = false

        for teleport, v in pairs(Config.Teleports) do
            if PlayerData.job and v.job == PlayerData.job.name or v.job == "all" then
                local dist = GetDistanceBetweenCoords(coords, v.entrance["x"], v.entrance["y"], v.entrance["z"])
                
                if dist < 15.0 then
                    DrawMarker(2, v.entrance["x"], v.entrance["y"], v.entrance["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.15, 119, 72, 126, 155, false, 1, false, false, false, false, false)
                    if dist < 0.5 then
                        DrawText3D(v.entrance["x"], v.entrance["y"], v.entrance["z"] + 0.15, "[~g~E~s~] - " .. v.label)
                        if IsControlJustPressed(0, 38) then
                            TeleportPlayer(v.teleport, v.heading)
                        end
                    end
                    inRange = true
                end
            else
                Citizen.Wait(500)
            end
        end

        if not inRange then
            Citizen.Wait(500)
        end
    end
end)

-- teleport
function TeleportPlayer(data)
    local playerPed = PlayerPedId()

    SetEntityCoords(playerPed, data.coords.x, data.coords.y, data.coords.z, false, false, false, true)
    SetEntityHeading(playerPed, data.heading)
    TriggerServerEvent("pp-teleport:updateCoords", data.coords)
end
