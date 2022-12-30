-- Variables
local QBCore = exports['qb-core']:GetCoreObject()
local fuelSynced = false
local inGasStation = false
local inBlacklisted = false
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
	'denis3d_prop_gas_pump', -- Gabz Ballas Gas Station Pump.
}
local refueling = false
local GasStationBlips = {} -- Used for managing blips on the client, so labels can be updated.

-- Debug ---
if Config.FuelDebug then
	RegisterCommand('setfuel0', function()
		local vehicle = QBCore.Functions.GetClosestVehicle()
		SetFuel(vehicle, 0)
		QBCore.Functions.Notify(Lang:t("set_fuel_debug")..' 0L', 'success')
	end, false)
	RegisterCommand('setfuel50', function()
		local vehicle = QBCore.Functions.GetClosestVehicle()
		SetFuel(vehicle, 50)
		QBCore.Functions.Notify(Lang:t("set_fuel_debug")..' 50L', 'success')
	end, false)
	RegisterCommand('setfuel100', function()
		local vehicle = QBCore.Functions.GetClosestVehicle()
		SetFuel(vehicle, 0)
		QBCore.Functions.Notify(Lang:t("set_fuel_debug")..' 100L', 'success')
	end, false)
end

-- Functions
function FetchStationInfo(info)
	if not Config.PlayerOwnedGasStationsEnabled then ReserveLevels = 1000 StationFuelPrice = Config.CostMultiplier return end
	if Config.FuelDebug then print("Fetching Information for Location #" ..CurrentLocation) end
	QBCore.Functions.TriggerCallback('cdn-fuel:server:fetchinfo', function(result)
		if result then
			for _, v in pairs(result) do
				-- Reserves --
				if info == "all" or info == "reserves" then
					Currentreserveamount = math.floor(v.fuel)
					ReserveLevels = tonumber(Currentreserveamount)
					if Config.FuelDebug then print("Fetched Reserve Levels: "..ReserveLevels.." Liters!") end
					if Currentreserveamount < Config.MaxFuelReserves then
						ReservesNotBuyable = false
					else
						ReservesNotBuyable = true
					end
					if Config.UnlimitedFuel then ReservesNotBuyable = true if Config.FuelDebug then print("Reserves are not buyable, because Config.UnlimitedFuel is set to true.") end end
				end
				-- Fuel Price --
				if info == "all" or info == "fuelprice" then
					StationFuelPrice = v.fuelprice
				end
				-- Balance --
				if info == "all" or info == "balance" then
					StationBalance = v.balance
					if info == "balance" then
						return StationBalance
					end
				end
				----------------
			end
		else
			if Config.FuelDebug then print("Error, fetching information failed.") end
		end

	end, CurrentLocation)
end exports(FetchStationInfo, FetchStationInfo)

function FetchCurrentLocation()
	if Config.FuelDebug then print("Fetching Current Location") end
	return CurrentLocation
end

local function ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, Config.FuelDecor) then
		SetFuel(vehicle, math.random(200, 800) / 10)
	elseif not fuelSynced then
		SetFuel(vehicle, GetFuel(vehicle))
		fuelSynced = true
	end
	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle,
		GetVehicleFuelLevel(vehicle) -
		Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
		SetVehicleEngineOn(veh, true, true, true)
	else
		SetVehicleEngineOn(veh, true, true, true)
	end
end

function GlobalTax(value)
	local tax = (value / 100 * Config.GlobalTax)
	return tax
end

local function CanAfford(price, purchasetype)
	local purchasetype = purchasetype
	if purchasetype == "bank" then Money = QBCore.Functions.GetPlayerData().money['bank'] elseif purchasetype == 'cash' then Money = QBCore.Functions.GetPlayerData().money['cash'] end
	if Money < price then
		return false
	else
		return true
	end
end

function IsInGasStation()
	return inGasStation
end


-- Thread Stuff --

if Config.LeaveEngineRunning then
	CreateThread(function()
		while true do
			Wait(100)
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
				local vehicle = GetVehiclePedIsIn(ped, true)
				local enginerunning = GetIsVehicleEngineRunning(vehicle)
				if Config.FuelDebug then if enginerunning then print('Engine is running!') else print('Engine is not running!') end end
				Wait(900)
				if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
					if enginerunning then SetVehicleEngineOn(vehicle, true, true, false) enginerunning = false end
					TaskLeaveVehicle(ped, veh, keepDooRopen and 256 or 0)
				end
			end
		end
	end)
end

if Config.ShowNearestGasStationOnly then
	RegisterNetEvent('cdn-fuel:client:updatestationlabels', function(location, newLabel)
		if not location then if Config.FuelDebug then print('location is nil') end return end
		if not newLabel then if Config.FuelDebug then print('newLabel is nil') end return end
		if Config.FuelDebug then print("Changing Label for Location #"..location..' to '..newLabel) end
		Config.GasStations[location].label = newLabel
	end)

	CreateThread(function()
		TriggerServerEvent('cdn-fuel:server:updatelocationlabels')
		Wait(1000)
		local currentGasBlip = 0
		while true do
			local coords = GetEntityCoords(PlayerPedId())
			local closest = 1000
			local closestCoords
			local closestLocation
			local location = 0
			for _, ourCoords in pairs(Config.GasStations) do
				location = location + 1
				local gasStationCoords = vector3(Config.GasStations[location].pedcoords.x, Config.GasStations[location].pedcoords.y, Config.GasStations[location].pedcoords.z)
				local dstcheck = #(coords - gasStationCoords)
				if dstcheck < closest then
					closest = dstcheck
					closestCoords = gasStationCoords
					closestLocation = location
				end
			end
			if DoesBlipExist(currentGasBlip) then
				RemoveBlip(currentGasBlip)
			end
			currentGasBlip = CreateBlip(closestCoords, Config.GasStations[closestLocation].label)
			Wait(10000)
		end
	end)
else
	RegisterNetEvent('cdn-fuel:client:updatestationlabels', function(location, newLabel)
		if not location then if Config.FuelDebug then print('location is nil') end return end
		if not newLabel then if Config.FuelDebug then print('newLabel is nil') end return end
		if Config.FuelDebug then print("Changing Label for Location #"..location..' to '..newLabel) end
		Config.GasStations[location].label = newLabel
		local coords = vector3(Config.GasStations[location].pedcoords.x, Config.GasStations[location].pedcoords.y, Config.GasStations[location].pedcoords.z)
		RemoveBlip(GasStationBlips[location])
		GasStationBlips[location] = CreateBlip(coords, Config.GasStations[location].label)
	end)

	CreateThread(function()
		TriggerServerEvent('cdn-fuel:server:updatelocationlabels')
		Wait(1000)
		local location = 0
		local gasStationCoords
		for _ in pairs(Config.GasStations) do
			location = location + 1
			gasStationCoords = vector3(Config.GasStations[location].pedcoords.x, Config.GasStations[location].pedcoords.y, Config.GasStations[location].pedcoords.z)
		end
		GasStationBlips[location] = CreateBlip(gasStationCoords, Config.GasStations[location].label)
		Wait(10000) -- 10 Second Checks for Updating Blip Names
	end)
end

CreateThread(function()
	for k = 1, #Config.GasStations do
		Stations[k] = PolyZone:Create(Config.GasStations[k].zones, {
			name = "GasStation" .. k,
			minZ = Config.GasStations[k].minz,
			maxZ = Config.GasStations[k].maxz,
			debugPoly = false
		})
		Stations[k]:onPlayerInOut(function(isPointInside)
			if isPointInside then
				inGasStation = true
				if Config.FuelDebug then print("Updating Location...")end
				UpdatedLocation = k
				CurrentLocation = UpdatedLocation
				if Config.FuelDebug then print("New Location: "..CurrentLocation) end
				if Config.PlayerOwnedGasStationsEnabled then
					TriggerEvent('cdn-fuel:stations:updatelocation', UpdatedLocation)
				end
			else
				inGasStation = false
			end
		end)
	end
end)

CreateThread(function()
	DecorRegister(Config.FuelDecor, 1)
	while true do
		Wait(1000)
		local ped = PlayerPedId()
		-- Blacklist Electric Vehicles, if you disables the Config.ElectricVehicleCharging or put the vehicle in Config.NoFuelUsage!
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)
			if Config.ElectricVehicles[GetEntityModel(vehicle)] and not Config.ElectricVehicleCharging then
				inBlacklisted = true
			elseif Config.NoFuelUsage[GetEntityModel(vehicle)] then
				inBlacklisted = true
			else
				inBlacklisted = false
			end
			if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then
				ManageFuelUsage(vehicle)
			end
		else
			if fuelSynced then fuelSynced = false end
			if inBlacklisted then inBlacklisted = false end
		end
	end
end)

-- Client Events
if Config.RenewedPhonePayment then
	RegisterNetEvent('cdn-fuel:client:phone:PayForFuel', function(amount)
		if Config.PlayerOwnedGasStationsEnabled then
			FetchStationInfo("fuelprice")
			Wait(100)
		else
			FuelPrice = Config.CostMultiplier
		end
		local cost = amount * FuelPrice
		local tax = GlobalTax(cost)
		local total = math.ceil(cost + tax)
		local success = exports['qb-phone']:PhoneNotification(Lang:t("fuel_phone_header"), Lang:t("phone_notification")..total, 'fas fa-gas-pump', '#9f0e63', "NONE", 'fas fa-check-circle', 'fas fa-times-circle')
		if success then
			if QBCore.Functions.GetPlayerData().money['bank'] <= (GlobalTax(amount) + amount) then
				QBCore.Functions.Notify(Lang:t("not_enough_money"), "error")
			else
				TriggerServerEvent('cdn-fuel:server:PayForFuel', total, "bank", FuelPrice)
				RefuelPossible = true
				RefuelPossibleAmount = amount
				RefuelPurchaseType = "bank"
				RefuelCancelled = false
			end
		end
	end)
end

RegisterNetEvent('cdn-fuel:client:RefuelMenu', function()
	if Config.RenewedPhonePayment then
		if not RefuelPossible then 
			TriggerEvent('cdn-fuel:client:SendMenuToServer')
		else 
			if Config.RenewedPhonePayment then
				if not Cancelledrefuel and not RefuelCancelled then
					if RefuelPossibleAmount then
						local purchasetype = "bank"
						local fuelamounttotal = tonumber(RefuelPossibleAmount)
						TriggerEvent('cdn-fuel:client:RefuelVehicle', purchasetype, fuelamounttotal) 
					else
						QBCore.Functions.Notify(Lang:t("more_than_zero"), 'error', 7500)
					end
				end
			else

			end
		end
	else
		TriggerEvent('cdn-fuel:client:SendMenuToServer')
	end
end)

RegisterNetEvent('cdn-fuel:client:grabnozzle', function()
	if Config.PlayerOwnedGasStationsEnabled then
		ShutOff = false
		Wait(50)
		QBCore.Functions.TriggerCallback('cdn-fuel:server:checkshutoff', function(result)
			if result == true then
				QBCore.Functions.Notify(Lang:t("emergency_shutoff_active"), 'error', 7500) ShutOff = true return
			else
				ShutOff = false
			end
		end, CurrentLocation)
		Wait(50)
	else
		ShutOff = false
		Wait(50)
	end
	if not ShutOff then
		local ped = PlayerPedId()
		if holdingnozzle then return end
		LoadAnimDict("anim@am_hold_up@male")
		TaskPlayAnim(ped, "anim@am_hold_up@male", "shoplift_high", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
		TriggerServerEvent("InteractSound_SV:PlayOnSource", "pickupnozzle", 0.4)
		Wait(300)
		StopAnimTask(ped, "anim@am_hold_up@male", "shoplift_high", 1.0)
		fuelnozzle = CreateObject(GetHashKey('prop_cs_fuel_nozle'), 1.0, 1.0, 1.0, true, true, false)
		local lefthand = GetPedBoneIndex(ped, 18905)
		AttachEntityToEntity(fuelnozzle, ped, lefthand, 0.13, 0.04, 0.01, -42.0, -115.0, -63.42, 0, 1, 0, 1, 0, 1)
		local grabbednozzlecoords = GetEntityCoords(ped)
		holdingnozzle = true
		Citizen.CreateThread(function()
			while holdingnozzle do
				local currentcoords = GetEntityCoords(ped)
				local dist = #(grabbednozzlecoords - currentcoords)
				if not TargetCreated then if Config.FuelTargetExport then exports['qb-target']:AllowRefuel(true) end end
				TargetCreated = true
				if dist > 7.5 then
					if TargetCreated then if Config.FuelTargetExport then exports['qb-target']:AllowRefuel(false) end end
					TargetCreated = true
					holdingnozzle = false
					DeleteObject(fuelnozzle)
					QBCore.Functions.Notify(Lang:t("nozzle_cannot_reach"), 'error')
					if Config.FuelNozzleExplosion then
						AddExplosion(grabbednozzlecoords.x, grabbednozzlecoords.y, grabbednozzlecoords.z, 'EXP_TAG_PROPANE', 1.0, true,false, 5.0)
						StartScriptFire(grabbednozzlecoords.x, grabbednozzlecoords.y, grabbednozzlecoords.z - 1,25,false)
						SetFireSpreadRate(10.0)
						Wait(5000)
						StopFireInRange(grabbednozzlecoords.x, grabbednozzlecoords.y, grabbednozzlecoords.z - 1, 3.0)
					end
				end
				Wait(2500)
			end
		end)
	end
end)

RegisterNetEvent('cdn-fuel:client:returnnozzle', function()
	if IsHoldingElectricNozzle() then 
		SetElectricNozzle("putback") 
	else
		holdingnozzle = false
		TargetCreated = false
		LoadAnimDict("pickup_object")
		TaskPlayAnim(ped, "pickup_object", "putdown_low", 2.0, 8.0, -1, 17, 0, 0, 0, 0)
		TriggerServerEvent("InteractSound_SV:PlayOnSource", "putbacknozzle", 0.4)
		StopAnimTask(ped, 'pickup_object', 'putdown_low', 1.0)
		Wait(250)
		if Config.FuelTargetExport then exports['qb-target']:AllowRefuel(false) end
		DeleteObject(fuelnozzle)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		DeleteObject(fuelnozzle)
	end
end)

RegisterNetEvent('cdn-fuel:client:FinalMenu', function(purchasetype)
	FetchStationInfo("all")
	Wait(100)
	if Config.PlayerOwnedGasStationsEnabled and not Config.UnlimitedFuel then 
		if ReserveLevels < 1 then
			QBCore.Functions.Notify(Lang:t("station_no_fuel"), 'error', 7500) return
		end
	end
	local money = nil
	if purchasetype == "bank" then money = QBCore.Functions.GetPlayerData().money['bank'] elseif purchasetype == 'cash' then money = QBCore.Functions.GetPlayerData().money['cash'] end
	if Config.PlayerOwnedGasStationsEnabled then
		FuelPrice = (1 * StationFuelPrice)
	else
		FuelPrice = (1 * Config.CostMultiplier)
	end
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local curfuel = GetFuel(vehicle)
	local finalfuel
	if curfuel < 10 then finalfuel = string.sub(curfuel, 1, 1) else finalfuel = string.sub(curfuel, 1, 2) end
	local maxfuel = (100 - finalfuel - 1)
	local wholetankcost = (FuelPrice * maxfuel)
	local wholetankcostwithtax = math.ceil(FuelPrice * maxfuel + GlobalTax(wholetankcost))
	if Config.PlayerOwnedGasStationsEnabled and not Config.UnlimitedFuel then
		if ReserveLevels < maxfuel then
			local wholetankcost = (FuelPrice * ReserveLevels)
			local wholetankcostwithtax = math.ceil(FuelPrice * ReserveLevels + GlobalTax(wholetankcost))
			fuel = exports['qb-input']:ShowInput({
				header = "Select the Amount of Fuel<br>Current Price: $" ..
				FuelPrice .. " / Liter <br> Current Fuel: " .. finalfuel .. " Liters <br> Full Tank Cost: $" ..
				wholetankcostwithtax .. "",
				submitText = Lang:t("input_insert_nozzle"),
				inputs = { {
					type = 'number',
					isRequired = true,
					name = 'amount',
					text = 'Only '..ReserveLevels..' Liters are available.'
				}}
			})
		else
			fuel = exports['qb-input']:ShowInput({
				header = "Select the Amount of Fuel<br>Current Price: $" ..
				FuelPrice .. " / Liter <br> Current Fuel: " .. finalfuel .. " Liters <br> Full Tank Cost: $" ..
				wholetankcostwithtax .. "",
				submitText = Lang:t("input_insert_nozzle"),
				inputs = { {
					type = 'number',
					isRequired = true,
					name = 'amount',
					text = 'The Tank Can Hold ' .. maxfuel .. ' More Liters.'
				}}
			})	
		end
	else
		fuel = exports['qb-input']:ShowInput({
			header = "Select the Amount of Fuel<br>Current Price: $" ..
			FuelPrice .. " / Liter <br> Current Fuel: " .. finalfuel .. " Liters <br> Full Tank Cost: $" ..
			wholetankcostwithtax .. "",
			submitText = Lang:t("input_insert_nozzle"),
			inputs = { {
				type = 'number',
				isRequired = true,
				name = 'amount',
				text = 'The Tank Can Hold ' .. maxfuel .. ' More Liters.'
			}}
		})	
	end
	if fuel then
		if not fuel.amount then return end
		if not holdingnozzle then return end
		if Config.PlayerOwnedGasStationsEnabled and not Config.UnlimitedFuel then
			if tonumber(fuel.amount) > tonumber(ReserveLevels) then
				QBCore.Functions.Notify(Lang:t("station_not_enough_fuel"), "error") return
			end
		end
		if (fuel.amount + finalfuel) >= 100 then
			QBCore.Functions.Notify(Lang:t("tank_cannot_fit"), "error")
		else
			if GlobalTax(fuel.amount * FuelPrice) + (fuel.amount * FuelPrice) <= money then
				local totalcost = (fuel.amount * FuelPrice)
				TriggerServerEvent('cdn-fuel:server:OpenMenu', totalcost, inGasStation, false, purchasetype, FuelPrice)
			else
				QBCore.Functions.Notify(Lang:t("not_enough_money"), 'error', 7500)
			end
		end
	end
end)

RegisterNetEvent('cdn-fuel:client:SendMenuToServer', function()
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local NotElectric = false
	if Config.ElectricVehicleCharging then
		local isElectric = GetCurrentVehicleType(vehicle)
		if isElectric == 'electricvehicle' then
			QBCore.Functions.Notify(Lang:t("need_electric_charger"), 'error', 7500) return 
		end
		NotElectric = true
	else
		NotElectric = true
	end
	Wait(50)
	if NotElectric then
		local CurFuel = GetVehicleFuelLevel(vehicle)
		local playercashamount = QBCore.Functions.GetPlayerData().money['cash']
		if not holdingnozzle then return end
		if CurFuel < 95 then
			exports['qb-menu']:openMenu({
				{
					header = Config.GasStations[CurrentLocation].label,
					isMenuHeader = true,
					icon = "fas fa-gas-pump",
				},
				{
					header = Lang:t("menu_header_cash"),
					txt = Lang:t("menu_pay_with_cash") .. playercashamount .. ")",
					icon = "fas fa-usd",
					params = {
						event = "cdn-fuel:client:FinalMenu",
						args = 'cash',
					}
				},
				{
					header = Lang:t("menu_header_bank"),
					txt = Lang:t("menu_pay_with_bank"),
					icon = "fas fa-credit-card",
					params = {
						event = "cdn-fuel:client:FinalMenu",
						args = 'bank',
					}
				},
				{
					header = Lang:t("menu_header_close"),
					txt = Lang:t("menu_refuel_cancel"),
					icon = "fas fa-times-circle",
					params = {
						event = "qb-menu:closeMenu",
					}
				},
			})
		else
			QBCore.Functions.Notify(Lang:t("tank_already_full"), 'error')
		end
	else
		QBCore.Functions.Notify(Lang:t("need_electric_charger"), 'error', 7500)
	end
end)

RegisterNetEvent('cdn-fuel:client:RefuelVehicle', function(data)
	FetchStationInfo("all")
	Wait(100)
	
	local purchasetype
	local amount
	local fuelamount

	if not Config.RenewedPhonePayment then 
		purchasetype = data.purchasetype 
	elseif data.purchasetype == "cash" then 
		purchasetype = "cash"
	else
		purchasetype = RefuelPurchaseType
	end
	if Config.FuelDebug then print("Purchase Type: "..purchasetype) end
	if not Config.RenewedPhonePayment then 
		amount = data.fuelamounttotal 
	elseif data.purchasetype == "cash" then
		amount = data.fuelamounttotal
	elseif not data.fuelamounttotal then
		amount = RefuelPossibleAmount 
	end
	if Config.PlayerOwnedGasStationsEnabled then
		FuelPrice = (1 * StationFuelPrice)
	else
		FuelPrice = (1 * Config.CostMultiplier)
	end
	if not holdingnozzle then return end
	if amount < 1 then return end
	if amount < 10 then fuelamount = string.sub(amount, 1, 1) else fuelamount = string.sub(amount, 1, 2) end
	local refillCost = (amount * FuelPrice)
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local ped = PlayerPedId()
	local time = amount * Config.RefuelTime
	if amount < 10 then time = 10 * Config.RefuelTime end
	local vehicleCoords = GetEntityCoords(vehicle)
	if inGasStation then
		if isCloseVeh() then
			RequestAnimDict(Config.RefuelAnimationDictionary)
			while not HasAnimDictLoaded('timetable@gardener@filling_can') do Wait(100) end
			if GetIsVehicleEngineRunning(vehicle) and Config.VehicleBlowUp then
				local Chance = math.random(1, 100)
				if Chance <= Config.BlowUpChance then
					AddExplosion(vehicleCoords, 5, 50.0, true, false, true)
					return
				end
			end
			TaskPlayAnim(ped, Config.RefuelAnimationDictionary, Config.RefuelAnimation, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
			refueling = true
			Refuelamount = 0
			CreateThread(function()
				while refueling do
					if Refuelamount == nil then Refuelamount = 0 end
					Wait(Config.RefuelTime)
					Refuelamount = Refuelamount + 1
					if Cancelledrefuel then
						local finalrefuelamount = math.floor(Refuelamount)
						local refillCost = (finalrefuelamount * FuelPrice)
						if Config.RenewedPhonePayment and purchasetype == "bank" then
							local remainingamount = (amount - Refuelamount)
							MoneyToGiveBack = (GlobalTax(remainingamount) + (remainingamount * FuelPrice))
							TriggerServerEvent("cdn-fuel:server:phone:givebackmoney", MoneyToGiveBack)
						else
							TriggerServerEvent('cdn-fuel:server:PayForFuel', refillCost, purchasetype, FuelPrice)
						end
						if Config.PlayerOwnedGasStationsEnabled and not Config.UnlimitedFuel then
							TriggerServerEvent('cdn-fuel:station:server:updatereserves', "remove", finalrefuelamount, ReserveLevels, CurrentLocation)
							TriggerServerEvent('cdn-fuel:station:server:updatebalance', "add", finalrefuelamount, StationBalance, CurrentLocation, FuelPrice)
						end
						local curfuel = GetFuel(vehicle)
						local finalfuel = (curfuel + Refuelamount)
						if finalfuel >= 98 and finalfuel < 100 then
							SetFuel(vehicle, 100)
						else
							SetFuel(vehicle, finalfuel)
						end
						if Config.RenewedPhonePayment then
							RefuelCancelled = true
							RefuelPossibleAmount = 0
							RefuelPossible = false
						end
						Cancelledrefuel = false
					end
				end
			end)
			TriggerServerEvent("InteractSound_SV:PlayOnSource", "refuel", 0.3)
			QBCore.Functions.Progressbar("refuel-car", Lang:t("prog_refueling_vehicle"), time, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function()
				refueling = false
				if not Config.RenewedPhonePayment or purchasetype == "cash" then 
					TriggerServerEvent('cdn-fuel:server:PayForFuel', refillCost, purchasetype, FuelPrice) 
				end
				local curfuel = GetFuel(vehicle)
				local finalfuel = (curfuel + fuelamount)
				if finalfuel > 99 and finalfuel < 100 then
					SetFuel(vehicle, 100)
				else
					SetFuel(vehicle, finalfuel)
				end
				if Config.PlayerOwnedGasStationsEnabled and not Config.UnlimitedFuel then
					TriggerServerEvent('cdn-fuel:station:server:updatereserves', "remove", fuelamount, ReserveLevels, CurrentLocation)
					TriggerServerEvent('cdn-fuel:station:server:updatebalance', "add", fuelamount, StationBalance, CurrentLocation, FuelPrice)
				else
					if Config.FuelDebug then print("Config.PlayerOwnedGasStationsEnabled == false or Config.UnlimitedFuel == true, this means reserves will not be changed.") end
				end
				StopAnimTask(ped, Config.RefuelAnimationDictionary, Config.RefuelAnimation, 3.0, 3.0, -1, 2, 0, 0, 0, 0)
				TriggerServerEvent("InteractSound_SV:PlayOnSource", "fuelstop", 0.4)
				if Config.RenewedPhonePayment then
					RefuelPossible = false
					RefuelPossibleAmount = 0
					RefuelPurchaseType = "bank"
				end
			end, function()
				refueling = false
				Cancelledrefuel = true
				StopAnimTask(ped, Config.RefuelAnimationDictionary, Config.RefuelAnimation, 3.0, 3.0, -1, 2, 0, 0, 0, 0)
				TriggerServerEvent("InteractSound_SV:PlayOnSource", "fuelstop", 0.4)
			end, "fas fa-gas-pump")
		end
	else 
		return 
	end
end)

-- Target Export

exports['qb-target']:AddTargetModel(props, {
	options = {
		{
			num = 1,
			type = "client",
			event = "cdn-fuel:client:grabnozzle",
			icon = "fas fa-gas-pump",
			label = Lang:t("grab_nozzle"),
			canInteract = function()
				if not holdingnozzle and not IsPedInAnyVehicle(PlayerPedId()) then
					return true
				end
			end
		},
		{
			num = 2,
			type = "client",
			event = "cdn-fuel:client:purchasejerrycan",
			icon = "fas fa-fire-flame-simple",
			label = Lang:t("buy_jerrycan"),
			canInteract = function()
				if not IsPedInAnyVehicle(PlayerPedId()) and not holdingnozzle then
					return true
				end
			end
		},
		{
			num = 3,
			type = "client",
			event = "cdn-fuel:client:returnnozzle",
			icon = "fas fa-hand",
			label = Lang:t("return_nozzle"),
			canInteract = function()
				if holdingnozzle and not refueling then
					return true
				end
			end
		},

	},
	distance = 2.0
})

-- Threads

CreateThread(function()
	local bones = {
		"petroltank",
		"petroltank_l",
		"petroltank_r",
		"wheel_rf",
		"wheel_rr",
		"petrolcap ",
		"seat_dside_r",
		"engine",
	}
	exports['qb-target']:AddTargetBone(bones, {
		options = {
			{
				type = "client",
				action = function ()
					TriggerEvent('cdn-fuel:client:RefuelMenu')
				end,
				icon = "fas fa-gas-pump",
				label = Lang:t("input_insert_nozzle"),
				canInteract = function()
					if inGasStation and not refueling and holdingnozzle then
						return true
					end
				end
			},
			{
				type = "client",
				action = function()
					TriggerEvent('cdn-fuel:client:electric:RefuelMenu')
				end,
				icon = "fas fa-bolt",
				label = Lang:t("insert_electric_nozzle"),
				canInteract = function()
					if inGasStation and not refueling and IsHoldingElectricNozzle() then
						return true
					end
				end
			},
		},
		distance = 1.5,
	})
end)

-- Jerry Can --
RegisterNetEvent('cdn-fuel:jerrycan:refuelmenu', function(itemData)
	if IsPedInAnyVehicle(PlayerPedId(), false) then QBCore.Functions.Notify(Lang:t("cannot_refuel_inside"), 'error') return end
	if Config.FuelDebug then print("Item Data: " .. json.encode(itemData)) end
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local vehiclecoords = GetEntityCoords(vehicle)
	local pedcoords = GetEntityCoords(PlayerPedId())
	if GetVehicleBodyHealth(vehicle) < 100 then QBCore.Functions.Notify(Lang:t("vehicle_is_damaged"), 'error') return end
	if holdingnozzle then
		local fulltank
		if itemData.info.gasamount == Config.JerryCanCap then fulltank = true
			GasString = Lang:t("menu_jerry_can_footer_full_gas")
		else fulltank = false
			GasString = Lang:t("menu_jerry_can_footer_refuel_gas")
		end
		exports['qb-menu']:openMenu({
			{
				header = Lang:t("menu_header_jerry_can"),
				isMenuHeader = true,
			},
			{
				header = Lang:t("menu_header_refuel_jerry_can"),
				txt = GasString,
				icon = "fas fa-gas-pump",
				params = {
					event = "cdn-fuel:jerrycan:refueljerrycan",
					args = {
						itemData = itemData,
					},
				},
				disabled = fulltank,
			},
			{
				header = Lang:t("menu_header_close"),
				txt = Lang:t("menu_jerry_can_close"),
				icon = "fas fa-times-circle",
				params = {
					event = "qb-menu:closeMenu",
				}
			},
		})
	else
		if #(vehiclecoords - pedcoords) > 2.5 then return end
		local nogas
		if itemData.info.gasamount < 1 then nogas = true
			GasString = Lang:t("menu_jerry_can_footer_no_gas")
		else nogas = false
			GasString = Lang:t("menu_jerry_can_footer_use_gas")
		end
		exports['qb-menu']:openMenu({
			{
				header = Lang:t("menu_header_jerry_can"),
				isMenuHeader = true,
			},
			{
				header = Lang:t("menu_header_refuel_vehicle"),
				txt = GasString,
				icon = "fas fa-gas-pump",
				params = {
					event = "cdn-fuel:jerrycan:refuelvehicle",
					args = {
						itemData = itemData,
					},
				},
				disabled = nogas,
			},
			{
				header = Lang:t("menu_header_close"),
				txt = Lang:t("menu_jerry_can_close"),
				icon = "fas fa-times-circle",
				params = {
					event = "qb-menu:closeMenu",
				}
			},
		})
	end
end)

RegisterNetEvent('cdn-fuel:client:jerrycanfinalmenu', function(purchasetype)
	Moneyamount = nil
	if purchasetype == 'bank' then
		Moneyamount = QBCore.Functions.GetPlayerData().money['bank']
	elseif purchasetype == 'cash' then
		Moneyamount = QBCore.Functions.GetPlayerData().money['cash']
	end
	if Moneyamount > math.ceil(Config.JerryCanPrice + GlobalTax(Config.JerryCanPrice)) then
		TriggerServerEvent('cdn-fuel:server:purchase:jerrycan', purchasetype)
	else
		if purchasetype == 'bank' then QBCore.Functions.Notify(Lang:t("not_enough_money_in_bank"), 'error') end
		if purchasetype == "cash" then QBCore.Functions.Notify(Lang:t("not_enough_money_in_pocket"), 'error') end
	end
end)

RegisterNetEvent('cdn-fuel:client:purchasejerrycan', function()
	local playercashamount = QBCore.Functions.GetPlayerData().money['cash']
	exports['qb-menu']:openMenu({
		{
			header = Lang:t("menu_jerry_can_purchase_header")..(math.ceil(Config.JerryCanPrice + GlobalTax(Config.JerryCanPrice))),
			isMenuHeader = true,
			icon = "fas fa-fire-flame-simple",
		},
		{
			header = Lang:t("menu_header_cash"),
			txt = Lang:t("menu_pay_with_cash") .. playercashamount .. ")",
			icon = "fas fa-usd",
			params = {
				event = "cdn-fuel:client:jerrycanfinalmenu",
				args = 'cash',
			}
		},
		{
			header = Lang:t("menu_header_bank"),
			txt = Lang:t("menu_pay_with_bank"),
			icon = "fas fa-credit-card",
			params = {
				event = "cdn-fuel:client:jerrycanfinalmenu",
				args = 'bank',
			}
		},
		{
			header = Lang:t("menu_header_close"),
			txt = Lang:t("menu_jerry_can_footer_close"),
			icon = "fas fa-times-circle",
			params = {
				event = "qb-menu:closeMenu",
			}
		},
	})
end)

RegisterNetEvent('cdn-fuel:jerrycan:refuelvehicle', function(data)
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local vehfuel = math.floor(GetFuel(vehicle))
	local maxvehrefuel = (100 - math.ceil(vehfuel))
	local itemData = data.itemData
	local jerrycanfuelamount = itemData.info.gasamount
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local NotElectric = false
	if Config.ElectricVehicleCharging then
		local isElectric = GetCurrentVehicleType(vehicle)
		if isElectric == 'electricvehicle' then
			QBCore.Functions.Notify(Lang:t("need_electric_charger"), 'error', 7500) return 
		end
		NotElectric = true
	else
		NotElectric = true
	end
	Wait(50)
	if NotElectric then
		if maxvehrefuel < Config.JerryCanCap then
			maxvehrefuel = maxvehrefuel
		else
			maxvehrefuel = Config.JerryCanCap
		end
		if maxvehrefuel >= jerrycanfuelamount then maxvehrefuel = jerrycanfuelamount elseif maxvehrefuel < jerrycanfuelamount then maxvehrefuel = maxvehrefuel end
		local refuel = exports['qb-input']:ShowInput({
			header = Lang:t("input_select_refuel_header"),
			submitText = Lang:t("input_refuel_submit"),
			inputs = {
				{
					type = 'number',
					isRequired = true,
					name = 'amount',
					text = Lang:t("input_max_fuel_footer_1") .. maxvehrefuel .. Lang:t("input_max_fuel_footer_2")
				}
			}
		})
		if refuel then
			if tonumber(refuel.amount) == 0 then QBCore.Functions.Notify(Lang:t("more_than_zero"), 'error') return elseif tonumber(refuel.amount) < 0 then QBCore.Functions.Notify(Lang:t("more_than_zero"), 'error') return end
			if tonumber(refuel.amount) > jerrycanfuelamount then QBCore.Functions.Notify(Lang:t("jerry_can_not_enough_fuel"), 'error') return end
			local refueltimer = Config.RefuelTime * tonumber(refuel.amount)
			if tonumber(refuel.amount) < 10 then refueltimer = Config.RefuelTime * 10 end
			JerrycanProp = CreateObject(GetHashKey('w_am_jerrycan'), 1.0, 1.0, 1.0, true, true, false)
			local lefthand = GetPedBoneIndex(PlayerPedId(), 18905)
			AttachEntityToEntity(JerrycanProp, PlayerPedId(), lefthand, 0.11 --[[Left - Right (Kind of)]] , 0.05--[[Up - Down]], 0.27 --[[Forward - Backward]], -15.0, 170.0, -90.42, 0, 1, 0, 1, 0, 1)
			QBCore.Functions.Progressbar('refuel_gas', Lang:t("prog_refueling_vehicle"), refueltimer, false, true, { -- Name | Label | Time | useWhileDead | canCancel
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, { 
				animDict = Config.JerryCanAnimDict,
				anim = Config.JerryCanAnim,
				flags = 17,
			}, {}, {}, function() -- Play When Done
				DeleteObject(JerrycanProp)
				StopAnimTask(PlayerPedId(), Config.JerryCanAnimDict, Config.JerryCanAnim, 1.0)
				QBCore.Functions.Notify(Lang:t("jerry_can_success_vehicle"), 'success')
				local syphonData = data.itemData
				local srcPlayerData = QBCore.Functions.GetPlayerData()
				TriggerServerEvent('cdn-fuel:info', "remove", tonumber(refuel.amount), srcPlayerData, syphonData)
				SetFuel(vehicle, (vehfuel + refuel.amount))
			end, function() -- Play When Cancel
				DeleteObject(JerrycanProp)
				StopAnimTask(PlayerPedId(), Config.JerryCanAnimDict, Config.JerryCanAnim, 1.0)
				QBCore.Functions.Notify(Lang:t("cancelled"), 'error')
			end, "jerrycan")
		end
	else
		QBCore.Functions.Notify(Lang:t("need_electric_charger"), 'error', 7500) return 
	end
end)

RegisterNetEvent('cdn-fuel:jerrycan:refueljerrycan', function(data)
	FetchStationInfo("fuelprice")
	Wait(100)
	if Config.PlayerOwnedGasStationsEnabled then
		FuelPrice = (1 * StationFuelPrice)
	else
		FuelPrice = (1 * Config.CostMultiplier)
	end

	local itemData = data.itemData
	local JerryCanMaxRefuel = (Config.JerryCanCap - itemData.info.gasamount)
	local jerrycanfuelamount = itemData.info.gasamount
	local refuel = exports['qb-input']:ShowInput({
		header = Lang:t("input_select_refuel_header"),
		submitText = Lang:t("input_refuel_jerrycan_submit"),
		inputs = { {
			type = 'number',
			isRequired = true,
			name = 'amount',
			text = Lang:t("input_max_fuel_footer_1") .. JerryCanMaxRefuel .. Lang:t("input_max_fuel_footer_2")
		} }
	})
	if refuel then
		if tonumber(refuel.amount) == 0 then QBCore.Functions.Notify(Lang:t("more_than_zero"), 'error') return elseif tonumber(refuel.amount) < 0 then QBCore.Functions.Notify(Lang:t("more_than_zero"), 'error') return end
		if tonumber(refuel.amount) + tonumber(jerrycanfuelamount) > Config.JerryCanCap then QBCore.Functions.Notify(Lang:t("jerry_can_not_fit_fuel"), 'error') return end
		if tonumber(refuel.amount) > Config.JerryCanCap then QBCore.Functions.Notify(Lang:t("jerry_can_not_fit_fuel"), 'error') return end
		local refueltimer = Config.RefuelTime * tonumber(refuel.amount)
		if tonumber(refuel.amount) < 10 then refueltimer = Config.RefuelTime * 10 end
		local price = (tonumber(refuel.amount) * FuelPrice) + GlobalTax(tonumber(refuel.amount) * FuelPrice)
		if not CanAfford(price, "cash") then QBCore.Functions.Notify(Lang:t("not_enough_money_in_cash"), 'error') return end
		if GetIsVehicleEngineRunning(vehicle) and Config.VehicleBlowUp then
			local Chance = math.random(1, 100)
			if Chance <= Config.BlowUpChance then
				AddExplosion(vehicleCoords, 5, 50.0, true, false, true)
				return
			end 
		end
		JerrycanProp = CreateObject(GetHashKey('w_am_jerrycan'), 1.0, 1.0, 1.0, true, true, false)
		local lefthand = GetPedBoneIndex(PlayerPedId(), 18905)
		AttachEntityToEntity(JerrycanProp, PlayerPedId(), lefthand, 0.11 --[[Left - Right (Kind of)]] , 0.05--[[Up - Down]], 0.27 --[[Forward - Backward]], -15.0, 170.0, -90.42, 0, 1, 0, 1, 0, 1)
		SetEntityVisible(fuelnozzle, false, 0)
		QBCore.Functions.Progressbar('refuel_gas', Lang:t("prog_jerry_can_refuel"), refueltimer, false,true, { -- Name | Label | Time | useWhileDead | canCancel
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {
			animDict = Config.JerryCanAnimDict,
			anim = Config.JerryCanAnim,
			flags = 17,
		}, {}, {}, function() -- Play When Done
			SetEntityVisible(fuelnozzle, true, 0)
			DeleteObject(JerrycanProp)
			StopAnimTask(PlayerPedId(), Config.JerryCanAnimDict, Config.JerryCanAnim, 1.0)
			QBCore.Functions.Notify(Lang:t("jerry_can_success"), 'success')
			local syphonData = data.itemData
			local srcPlayerData = QBCore.Functions.GetPlayerData()
			TriggerServerEvent('cdn-fuel:info', "add", tonumber(refuel.amount), srcPlayerData, syphonData)
			TriggerServerEvent('cdn-fuel:server:PayForFuel', tonumber(refuel.amount) * FuelPrice, "cash", FuelPrice)
		end, function() -- Play When Cancel
			SetEntityVisible(fuelnozzle, true, 0)
			DeleteObject(JerrycanProp)
			StopAnimTask(PlayerPedId(), Config.JerryCanAnimDict, Config.JerryCanAnim, 1.0)
			QBCore.Functions.Notify(Lang:t("cancelled"), 'error')
		end, "jerrycan")
	end
end)

--- Syphoning ---
local function PoliceAlert(coords)
	local chance = math.random(1, 100)
	if chance < Config.SyphonPoliceCallChance then
		if Config.SyphonDispatchSystem == "ps-dispatch" then
			exports['ps-dispatch']:SuspiciousActivity()
		elseif Config.SyphonDispatchSystem == "qb-dispatch" then
			TriggerServerEvent('qb-dispatch:911call', coords)
		elseif Config.SyphonDispatchSystem == "qb-default" then
			TriggerServerEvent('cdn-syphoning:callcops', coords)
		elseif Config.SyphonDispatchSystem == "custom" then
			-- Put your own dispatch system here
		else
			if Config.SyphonDebug then print("There was an attempt to call police but this dispatch system is not supported!") end
		end
	end
end

-- Events --
RegisterNetEvent('cdn-syphoning:syphon:menu', function(itemData)
	if IsPedInAnyVehicle(PlayerPedId(), false) then QBCore.Functions.Notify(Lang:t("syphon_inside_vehicle"), 'error') return end
	if Config.SyphonDebug then print("Item Data: " .. json.encode(itemData)) end
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local vehiclename = GetEntityModel(vehicle)
	local vehiclecoords = GetEntityCoords(vehicle)
	local pedcoords = GetEntityCoords(PlayerPedId())
	if Config.ElectricVehicleCharging then
		NotElectric = true
		for i = 1, #Config.ElectricVehicles do
			local current = GetHashKey(Config.ElectricVehicles[i])
			if Config.SyphonDebug then print("^5Current Search: ^2"..current.." ^5Player's Vehicle: ^2"..vehiclename) end
			if current == vehiclename then
				NotElectric = false
				if Config.SyphonDebug then print("^2"..current.. "^5 has been found. It ^2matches ^5the Player's Vehicle: ^2"..vehiclename..". ^5This means syphoning will not be allowed.") end
				QBCore.Functions.Notify(Lang:t("syphon_electric_vehicle"), 'error', 7500) return
			end
		end
	else
		NotElectric = true
	end
	if NotElectric then
		if #(vehiclecoords - pedcoords) > 2.5 then return end
		if GetVehicleBodyHealth(vehicle) < 100 then QBCore.Functions.Notify(Lang:t("vehicle_is_damaged"), 'error') return end
		local nogas
		if itemData.info.gasamount < 1 then nogas = true Nogasstring = Lang:t("menu_syphon_empty") else nogas = false Nogasstring = Lang:t("menu_syphon_refuel") end
		local syphonfull if itemData.info.gasamount == Config.SyphonKitCap then syphonfull = true Stealfuelstring = Lang:t("menu_syphon_kit_full") elseif GetFuel(vehicle) < 1 then syphonfull = true Stealfuelstring = Lang:t("menu_syphon_vehicle_empty") else syphonfull = false Stealfuelstring = Lang:t("menu_syphon_allowed") end -- Disable Options based on item data
		exports['qb-menu']:openMenu({
			{
				header = "Syphoning Kit",
				isMenuHeader = true,
			},
			{
				header = Lang:t("menu_syphon_header"),
				txt = Stealfuelstring,
				params = {
					event = "cdn-syphoning:syphon",
					args = {
						itemData = itemData,
						reason = "syphon",
					},
				},
				icon = "fas fa-fire-flame-simple",
				disabled = syphonfull,
			},
			{
				header = Lang:t("menu_syphon_refuel_header"),
				txt = Nogasstring,
				icon = "fas fa-gas-pump",
				params = {
					event = "cdn-syphoning:syphon",
					args = {
						itemData = itemData,
						reason = "refuel",
					},
				},
				disabled = nogas,
			},
			{
				header = Lang:t("menu_header_close"),
				txt = Lang:t("menu_syphon_cancel"),
				icon = "fas fa-times-circle",
				params = {
					event = "qb-menu:closeMenu",
				}
			},
		})
	end
end)

RegisterNetEvent('cdn-syphoning:syphon', function(data)
	local reason = data.reason
	local HasSyphon = QBCore.Functions.HasItem("syphoningkit", 1)
	if Config.SyphonDebug then print('Item Data Syphon: ' .. json.encode(data.itemData)) end
	if Config.SyphonDebug then print('Reason: ' .. reason) end
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local NotElectric = false
	if Config.ElectricVehicleCharging then
		local isElectric = GetCurrentVehicleType(vehicle)
		if isElectric == 'electricvehicle' then
			QBCore.Functions.Notify(Lang:t("need_electric_charger"), 'error', 7500) return 
		end
		NotElectric = true
	else
		NotElectric = true
	end
	Wait(50)
	if NotElectric then
		if HasSyphon then
			local currentsyphonamount = data.itemData.info.gasamount
			local fitamount = (Config.SyphonKitCap - currentsyphonamount)
			local vehicle = QBCore.Functions.GetClosestVehicle()
			local vehiclecoords = GetEntityCoords(vehicle)
			local pedcoords = GetEntityCoords(PlayerPedId())
			if #(vehiclecoords - pedcoords) > 2.5 then return end -- If car is farther than 2.5 then return end
			local cargasamount = GetFuel(vehicle)
			local maxsyphon = math.floor(GetFuel(vehicle))
			if Config.SyphonKitCap <= 100 then
				if maxsyphon > Config.SyphonKitCap then
					maxsyphon = Config.SyphonKitCap
				end
			end
			if maxsyphon >= fitamount then
				Stealstring = fitamount
			else
				Stealstring = maxsyphon
			end
			if reason == "syphon" then
				local syphon = exports['qb-input']:ShowInput({
					header = "Select how much gas to steal.",
					submitText = "Begin Syphoning",
					inputs = {
						{
							type = 'number',
							isRequired = true,
							name = 'amount',
							text = 'You can steal ' .. Stealstring .. 'L from the car.'
						}
					}
				})
				if syphon then
					if not syphon.amount then return end
					if tonumber(syphon.amount) < 0 then QBCore.Functions.Notify(Lang:t("syphon_more_than_zero"), 'error') return end
					if tonumber(syphon.amount) == 0 then QBCore.Functions.Notify(Lang:t("syphon_more_than_zero"), 'error') return end
					if tonumber(syphon.amount) > maxsyphon then QBCore.Functions.Notify(Lang:t("syphon_kit_cannot_fit_1").. fitamount .. Lang:t("syphon_kit_cannot_fit_2"), 'error') return end
					if currentsyphonamount + syphon.amount > Config.SyphonKitCap then QBCore.Functions.Notify(Lang:t("syphon_kit_cannot_fit_1").. fitamount .. Lang:t("syphon_kit_cannot_fit_2"), 'error') return end
					if (tonumber(syphon.amount) <= tonumber(cargasamount)) then
						local removeamount = (tonumber(cargasamount) - tonumber(syphon.amount))
						local syphonstring
						if tonumber(syphon.amount) < 10 then syphonstring = string.sub(syphon.amount, 1, 1) else syphonstring = string.sub(syphon.amount, 1, 2) end -- This is to remove the .0 part from them end for the notification.
						local syphontimer = Config.RefuelTime * syphon.amount
						if tonumber(syphon.amount) < 10 then syphontimer = Config.RefuelTime * 10 end
						QBCore.Functions.Progressbar('syphon_gas', Lang:t("prog_syphoning"), syphontimer, false, true, { -- Name | Label | Time | useWhileDead | canCancel
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						}, {
							animDict = Config.StealAnimDict,
							anim = Config.StealAnim,
							flags = 1,
						}, {}, {}, function() -- Play When Done
							StopAnimTask(PlayerPedId(), Config.StealAnimDict, Config.StealAnim, 1.0)
							PoliceAlert(GetEntityCoords(PlayerPedId()))
							QBCore.Functions.Notify(Lang:t("syphon_success"), 'success')
							SetFuel(vehicle, removeamount)
							local syphonData = data.itemData
							local srcPlayerData = QBCore.Functions.GetPlayerData()
							TriggerServerEvent('cdn-fuel:info', "add", tonumber(syphon.amount), srcPlayerData, syphonData)
						end, function() -- Play When Cancel
							PoliceAlert(GetEntityCoords(PlayerPedId()))
							StopAnimTask(PlayerPedId(), Config.StealAnimDict, Config.StealAnim, 1.0)
							QBCore.Functions.Notify(Lang:t("cancelled"), 'error')
						end, "syphoningkit")
					end
				end
			elseif reason == "refuel" then
				if 100 - math.ceil(cargasamount) < Config.SyphonKitCap then
					Maxrefuel = 100 - math.ceil(cargasamount)
					if Maxrefuel > currentsyphonamount then Maxrefuel = currentsyphonamount end
				else
					Maxrefuel = currentsyphonamount
				end
				local refuel = exports['qb-input']:ShowInput({
					header = Lang:t("input_select_refuel_header"),
					submitText = Lang:t("input_refuel_submit"),
					inputs = {
						{
							type = 'number',
							isRequired = true,
							name = 'amount',
							text = Lang:t("input_max_fuel_footer_1") .. Maxrefuel .. Lang:t("input_max_fuel_footer_2")
						}
					}
				})
				if refuel then
					if tonumber(refuel.amount) == 0 then QBCore.Functions.Notify(Lang:t("more_than_zero"), 'error') return elseif tonumber(refuel.amount) < 0 then QBCore.Functions.Notify(Lang:t("more_than_zero"), 'error') return elseif tonumber(refuel.amount) > 100 then QBCore.Functions.Notify("You can't refuel more than 100L!", 'error') return end
					if tonumber(refuel.amount) > tonumber(currentsyphonamount) then QBCore.Functions.Notify(Lang:t("syphon_not_enough_gas"), 'error') return end
					if tonumber(refuel.amount) + tonumber(cargasamount) > 100 then QBCore.Functions.Notify(Lang:t("tank_cannot_fit"), 'error') return end
					local refueltimer = Config.RefuelTime * tonumber(refuel.amount)
					if tonumber(refuel.amount) < 10 then refueltimer = Config.RefuelTime * 10 end
					QBCore.Functions.Progressbar('refuel_gas', Lang:t("prog_refueling_vehicle"), refueltimer, false, true, { -- Name | Label | Time | useWhileDead | canCancel
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}, {
						animDict = Config.JerryCanAnimDict,
						anim = Config.JerryCanAnim,
						flags = 17,
					}, {}, {}, function() -- Play When Done
						StopAnimTask(PlayerPedId(), Config.JerryCanAnimDict, Config.JerryCanAnim, 1.0)
						QBCore.Functions.Notify(Lang:t("syphon_success_vehicle"), 'success')
						SetFuel(vehicle, cargasamount + tonumber(refuel.amount))
						local syphonData = data.itemData
						local srcPlayerData = QBCore.Functions.GetPlayerData()
						TriggerServerEvent('cdn-fuel:info', "remove", tonumber(refuel.amount), srcPlayerData, syphonData)
					end, function() -- Play When Cancel
						StopAnimTask(PlayerPedId(), Config.JerryCanAnimDict, Config.JerryCanAnim, 1.0)
						QBCore.Functions.Notify(Lang:t("cancelled"), 'error')
					end, "syphoningkit")
				end
			end
		else
			QBCore.Functions.Notify(Lang:t("syphon_no_syphon_kit"), 'error', 7500)
		end
	else
		QBCore.Functions.Notify(Lang:t("need_electric_charger"), 'error', 7500) return 
	end
end)

RegisterNetEvent('cdn-syphoning:client:callcops', function(coords)
	local PlayerJob = QBCore.Functions.GetPlayerData().job
	if PlayerJob.name ~= "police" or not PlayerJob.onduty then return end
	local transG = 250
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 648)
	SetBlipColour(blip, 17)
	SetBlipDisplay(blip, 4)
	SetBlipAlpha(blip, transG)
	SetBlipScale(blip, 1.2)
	SetBlipFlashes(blip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(Lang:t("syphon_dispatch_string"))
	EndTextCommandSetBlipName(blip)
	while transG ~= 0 do
		Wait(180 * 4)
		transG = transG - 1
		SetBlipAlpha(blip, transG)
		if transG == 0 then
			SetBlipSprite(blip, 2)
			RemoveBlip(blip)
			return
		end
	end
end)

