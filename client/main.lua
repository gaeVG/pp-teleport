ESX = nil

local PlayerData = {}

-- base
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(500)
        TriggerEvent("esx:getSharedObject", function (obj) ESX = obj end)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(500)
    end

    PlayerData = ESX.GetPlayerData()
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
        Citizen.Wait(5)

        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local inRange = false

        for teleport, v in pairs(Config.Teleports) do
            if PlayerData.job and v.job == PlayerData.job.name or v.job == "all" then
                local dist = GetDistanceBetweenCoords(coords, v.entrance["x"], v.entrance["y"], v.entrance["z"])
                
                if dist < 15.0 then
                    DrawMarker(2, v.entrance["x"], v.entrance["y"], v.entrance["z"], 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.15, 119, 72, 126, 155, false, 1, false, false, false, false, false)
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
function TeleportPlayer(coords, heading)
    local playerPed = PlayerPedId()

    SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
    SetEntityHeading(playerPed, heading)
    TriggerServerEvent("pp-teleport:updateCoords", coords)
end
