local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
ESX              = nil
local PlayerData = {}
local nitroBegin = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do

        Citizen.Wait(0)
		local force = 55.0
        	local ped = GetPlayerPed(-1)
		local playerVeh = GetVehiclePedIsIn(ped, false)
	
		if IsControlPressed(1, 105) and nitroBegin then
			SetVehicleBoostActive(playerVeh, 1, 0)
			SetVehicleForwardSpeed(playerVeh, force)
			StartScreenEffect("RaceTurbo", 0, 0)
			SetVehicleBoostActive(playerVeh, 0, 0)
			nitroBegin = false
        end
    end
end)

RegisterNetEvent('nitro:start')
AddEventHandler('nitro:start', function()
	local playerPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(playerPed)
	local vehicle = ESX.Game.GetVehicleInDirection()

	if IsPedSittingInAnyVehicle(playerPed) then
		exports['mythic_notify']:DoHudText('inform', 'You cant install the nitro bottle inside the vehicle!')
	else
		if DoesEntityExist(vehicle) and IsPedOnFoot(playerPed) then
			TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
			exports['progressBars']:startUI(5000, "Installing Nitro Bottle...")
			Citizen.CreateThread(function()
				Citizen.Wait(5000)
				ClearPedTasksImmediately(playerPed)
        		startNitro()
        		TriggerServerEvent('nitro:removeInventoryItem','nitro', 1)
				exports['mythic_notify']:DoHudText('inform', 'You Installed a Nitro Bottle!')
			end)
		else
			exports['mythic_notify']:DoHudText('inform', 'No Vehicle(s) Nearby!')
		end
	end
end)

function startNitro()
    nitroBegin = true
end
