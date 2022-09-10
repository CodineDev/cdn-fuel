-- Variables --
local QBCore = exports['qb-core']:GetCoreObject()
local fuelSynced = false
local inBlacklisted = false
local inGasStation = false
local holdingnozzle = false
local Stations = {}
local props = {
	'prop_gas_pump_1d',
	'prop_gas_pump_1a',
	'prop_gas_pump_1b',
	'prop_gas_pump_1c',
	'prop_vintage_pump',
	'prop_gas_pump_old2',
	'prop_gas_pump_old3',
}
local refueling = false

-- Functions
local function ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, Config.FuelDecor) then
		SetFuel(vehicle, math.random(200, 800) / 10)
	elseif not fuelSynced then
		SetFuel(vehicle, GetFuel(vehicle))
		fuelSynced = true
	end
	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
		SetVehicleEngineOn(veh, true, true, true)
	else
		SetVehicleEngineOn(veh, true, true, true)
	end
end

-- THIS IS A TEST COMMAND! DO NOT HAVE THIS ENABLED ON YOUR LIVE SERVER!!!
-- RegisterCommand('setfuel', function ()
-- 	local vehicle = QBCore.Functions.GetClosestVehicle()
-- 	SetFuel(vehicle, 15)
-- end, false)

local function GlobalTax(value)
	local tax = (value / 100 * Config.GlobalTax)
	return tax
end

if Config.LeaveEngineRunning then
	CreateThread(function()
		while true do
			Wait(100)
			local ped = PlayerPedId()
			if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
				local engineWasRunning = GetIsVehicleEngineRunning(GetVehiclePedIsIn(ped, true))
				Wait(1000)
				if DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) and not IsEntityDead(ped) and not IsPauseMenuActive() then
					local veh = GetVehiclePedIsIn(ped, true)
					if engineWasRunning then
						SetVehicleEngineOn(veh, true, true, true)
					end
				end
			end
		end
	end)
end

if Config.ShowNearestGasStationOnly then
    CreateThread(function()
	local currentGasBlip = 0
	while true do
		local coords = GetEntityCoords(PlayerPedId())
		local closest = 1000
		local closestCoords
		for _, gasStationCoords in pairs(Config.GasStationsBlips) do
			local dstcheck = #(coords - gasStationCoords)
			if dstcheck < closest then
				closest = dstcheck
				closestCoords = gasStationCoords
			end
		end
		if DoesBlipExist(currentGasBlip) then
			RemoveBlip(currentGasBlip)
		end
		currentGasBlip = CreateBlip(closestCoords)
		Wait(10000)
	end
	end)
elseif Config.ShowAllGasStations then
    CreateThread(function()
        for _, gasStationCoords in pairs(Config.GasStationsBlips) do
            CreateBlip(gasStationCoords)
        end
    end)
end

CreateThread(function() 
    for k=1, #Config.GasStations do
		Stations[k] = PolyZone:Create(Config.GasStations[k].zones, {
			name="GasStation"..k,
			minZ = 	Config.GasStations[k].minz,
			maxZ = Config.GasStations[k].maxz,
			debugPoly = false
		})
		Stations[k]:onPlayerInOut(function(isPointInside)
			if isPointInside then
				inGasStation = true
			else
				inGasStation = false
			end
		end)
    end
end)

CreateThread(function()
	DecorRegister(Config.FuelDecor, 1)
	for index = 1, #Config.Blacklist do
		if type(Config.Blacklist[index]) == 'string' then
			Config.Blacklist[GetHashKey(Config.Blacklist[index])] = true
		else
			Config.Blacklist[Config.Blacklist[index]] = true
		end
	end
	for index = #Config.Blacklist, 1, -1 do
		Config.Blacklist[index] = nil
	end
	while true do
		Wait(1000)
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)
			if Config.Blacklist[GetEntityModel(vehicle)] then
				inBlacklisted = true
			else
				inBlacklisted = false
			end
			if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then
				ManageFuelUsage(vehicle)
			end
		else
			if fuelSynced then
				fuelSynced = false
			end
			if inBlacklisted then
				inBlacklisted = false
			end
		end
	end
end)

-- Client Events
RegisterNetEvent('cdn-fuel:client:grabnozzle', function()
	local ped = PlayerPedId()
	if holdingnozzle then return end
	fuelnozzle = CreateObject(GetHashKey('prop_cs_fuel_nozle'), 1.0, 1.0, 1.0, true, true, false)
	local lefthand = GetPedBoneIndex(ped, 18905)
	AttachEntityToEntity(fuelnozzle, ped, lefthand, 0.13, 0.04, 0.01, -42.0, -115.0, -63.42, 0, 1, 0, 1, 0, 1) -- Be careful when adjusting!
	holdingnozzle = true
	local grabbednozzlecoords = GetEntityCoords(ped)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "pickupnozzle", 0.4)
	Citizen.CreateThread(function()
		while holdingnozzle do
			local currentcoords = GetEntityCoords(ped)
			local dist = #(grabbednozzlecoords - currentcoords)
			if dist > 12.5 then
				holdingnozzle = false
				DeleteObject(fuelnozzle)
				if Config.FuelNozzleExplosion then
					AddExplosion(grabbednozzlecoords.x, grabbednozzlecoords.y, grabbednozzlecoords.z, 'EXP_TAG_PROPANE', 1.0, true, false, 5.0)
					StartScriptFire(grabbednozzlecoords.x, grabbednozzlecoords.y, grabbednozzlecoords.z - 1, 25, false)
					SetFireSpreadRate(10.0) 
					Wait(5000)
					StopFireInRange(grabbednozzlecoords.x, grabbednozzlecoords.y, grabbednozzlecoords.z - 1, 3.0)
				end
			end
			Wait(2500)
		end
	end)
	if Config.FuelDebug then print('Tried to attach ' ..fuelnozzle.. " to "..ped) end
end)

RegisterNetEvent('cdn-fuel:client:returnnozzle', function()
	holdingnozzle = false
	DeleteObject(fuelnozzle)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "putbacknozzle", 0.4)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
	   DeleteObject(fuelnozzle) -- Remove Nozzle if Script is Started.
	end
end)

RegisterNetEvent('cdn-fuel:client:FinalMenu', function(purchasetype)
	local money = nil
	if purchasetype == "bank" then money = QBCore.Functions.GetPlayerData().money['bank'] elseif purchasetype == 'cash' then money = QBCore.Functions.GetPlayerData().money['cash'] end
	local FuelPrice = (1 * Config.CostMultiplier)
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local curfuel = GetFuel(vehicle)
	local finalfuel
	if curfuel < 10 then finalfuel = string.sub(curfuel, 1, 1) else finalfuel = string.sub(curfuel, 1, 2) end
	local maxfuel = (100 - finalfuel - 1)
	local wholetankcost = (FuelPrice * maxfuel)
	local wholetankcostwithtax = math.ceil(FuelPrice * maxfuel + GlobalTax(wholetankcost))
	local fuel = exports['qb-input']:ShowInput({
		header = "Select the Amount of Fuel<br>Current Price: $"..FuelPrice.." / Liter <br> Current Fuel: " ..finalfuel.." Liters <br> Full Tank Cost: $"..wholetankcostwithtax.."",
		submitText = "Insert Nozzle",
		inputs = {
			{
				type = 'number',
				isRequired = true,
				name = 'amount',
				text = 'The Tank Can Hold ' .. maxfuel .. ' More Liters.'
			}
		}
	})
	if fuel then
		if not fuel.amount then return end
		if not holdingnozzle then return end
		if (fuel.amount + finalfuel) >= 100 then
		else
			if (fuel.amount * Config.CostMultiplier) <= money then
				local totalcost = (fuel.amount * Config.CostMultiplier)
				TriggerServerEvent('cdn-fuel:server:OpenMenu', totalcost, inGasStation, false, purchasetype)
			else
				QBCore.Functions.Notify("You don't have enough money!", 'error', 7500)
			end
		end
	end
end)

RegisterNetEvent('cdn-fuel:client:SendMenuToServer', function()
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local CurFuel = GetVehicleFuelLevel(vehicle)
	local playercashamount = QBCore.Functions.GetPlayerData().money['cash']
	if not holdingnozzle then return end

	if CurFuel < 95 then
		exports['qb-menu']:openMenu({
			{
				header = "Gas Station",
				isMenuHeader = true,
			},
			{
				header = "Cash",
				txt = "Pay with cash. <br> (You have: $"..playercashamount..")", 
				params = {
					event = "cdn-fuel:client:FinalMenu",
					args = 'cash',
				}
			},
			{
				header = "Bank",
				txt = "Pay with card.", 
				params = {
					event = "cdn-fuel:client:FinalMenu",
					args = 'bank',
				}
			},
			{
				header = "Cancel",
				txt = "I actually don't want gas anymore.", 
			},
		})
	else
		QBCore.Functions.Notify("Vehicle is already full!", "error")
	end
end)

local fuelamount
RegisterNetEvent('cdn-fuel:client:RefuelVehicle', function(data)
	local ped = PlayerPedId()
	local purchasetype = data.purchasetype
	local amount = data.fuelamounttotal
	if Config.FuelDebug then print('Purchase Type: '..purchasetype) print('Amount: '..amount) end
	if not holdingnozzle then QBCore.Functions.Notify("You need to have the fuel nozzle!", 'error') return end
	if amount < 1 then QBCore.Functions.Notify("You can't fuel a negative amount!", 'error', 7500) return end
	if amount < 10 then fuelamount = string.sub(amount, 1, 1) else fuelamount = string.sub(amount, 1, 2) end -- This is needed to fix an error.
	local refillCost = (amount * Config.CostMultiplier)
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local ped = PlayerPedId()
	local time = amount*600
	local vehicleCoords = GetEntityCoords(vehicle)
	if inGasStation == false then return end
	if inGasStation then
		if isCloseVeh() then
			RequestAnimDict("timetable@gardener@filling_can")
			while not HasAnimDictLoaded('timetable@gardener@filling_can') do Wait(100) end
			TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
			if GetIsVehicleEngineRunning(vehicle) and Config.VehicleBlowUp then
				local Chance = math.random(1, 100)
				if Chance <= Config.BlowUpChance then AddExplosion(vehicleCoords, 5, 50.0, true, false, true) return end
			end
			refueling = true
			TriggerServerEvent("InteractSound_SV:PlayOnSource", "refuel", 0.15)
			QBCore.Functions.Progressbar("refuel-car", "Refueling", time, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, 
			function() -- Done
				refueling = false
				TriggerServerEvent('cdn-fuel:server:PayForFuel', refillCost, purchasetype)
				local curfuel = GetFuel(vehicle)
				local finalfuel = (curfuel + fuelamount)
				if finalfuel > 99 and finalfuel < 100 then
					SetFuel(vehicle, 100)
				else
					SetFuel(vehicle, finalfuel)
				end
				StopAnimTask(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
				TriggerServerEvent("InteractSound_SV:PlayOnSource", "fuelstop", 0.4)
			end,
			function() -- Cancel
				QBCore.Functions.Notify("Cancelled Refueling", "error")
				refueling = false
				StopAnimTask(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
				TriggerServerEvent("InteractSound_SV:PlayOnSource", "fuelstop", 0.4)
			end)
		end
	end
end)

-- Target Exports --
exports['qb-target']:AddTargetModel(props, {
	options = {
		{
			type = "client",
			event = "cdn-fuel:client:grabnozzle",
			icon = "fas fa-gas-pump",
			label = "Grab Nozzle",
			canInteract = function()
				if not holdingnozzle and not IsPedInAnyVehicle(PlayerPedId()) then
					return true
				end
			end
		},
		{
			type = "client",
			event = "cdn-fuel:client:returnnozzle",
			icon = "fas fa-hand",
			label = "Return Nozzle",
			canInteract = function()
				if holdingnozzle and not refueling then
					return true
				end
			end
		},
	},
	distance = 2.0
})

CreateThread(function()
	local bones = {"petroltank", "petroltank_l", "petroltank_r", "wheel_rf", "wheel_rr", "petrolcap ", "seat_dside_r", "engine",}
	exports['qb-target']:AddTargetBone(bones, {
		options = {
		{
			type = "client",
			event = "cdn-fuel:client:SendMenuToServer",
			icon = "fas fa-gas-pump",
			label = "Insert Nozzle",
			canInteract = function()
				if inGasStation and not refueling and holdingnozzle then
					return true
				end
			end
		}
	},
		distance = 1.5,
	})
end)
