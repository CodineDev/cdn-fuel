-- Variables
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
local PaidForFuel = false

-- Debug ---
if Config.FuelDebug then
	RegisterCommand('setfuel0', function()
		local vehicle = QBCore.Functions.GetClosestVehicle()
		SetFuel(vehicle, 0)
		QBCore.Functions.Notify(Lang:t("success.set_fuel_0"), 'success')
	end, false)
	RegisterCommand('setfuel50', function()
		local vehicle = QBCore.Functions.GetClosestVehicle()
		SetFuel(vehicle, 50)
		QBCore.Functions.Notify(Lang:t("success.set_fuel_50"), 'success')
	end, false)
	RegisterCommand('setfuel100', function()
		local vehicle = QBCore.Functions.GetClosestVehicle()
		SetFuel(vehicle, 0)
		QBCore.Functions.Notify(Lang:t("success.set_fuel_100"), 'success')
	end, false)
end
-- Functions
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

local function GlobalTax(value)
	local tax = (value / 100 * Config.GlobalTax)
	return tax
end

local function SetBusy(state)
	if Config.FuelDebug then print("Attempting to Set Busy State for Inventory!") end
	if Config.FuelDebug and not Config.InventoryBusy then print("Attempting to Set Busy State for Inventory, but, Config.InventoryBusy is Disabled, meaning busy state will not change!") end
	if Config.InventoryBusy then
		if state then
			LocalPlayer.state:set("inv_busy", true, true) -- Busy
		elseif not state then
			LocalPlayer.state:set("inv_busy", false, false) -- Not Busy
		end
	end
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

-- Thread Stuff --

if Config.LeaveEngineRunning then
    CreateThread(function()
        while true do
            Wait(100)
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
				local vehicle = GetVehiclePedIsIn(ped, true)
				local enginerunning = GetIsVehicleEngineRunning(vehicle)
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
end

if Config.ShowAllGasStations then
	CreateThread(function()
		for _, gasStationCoords in pairs(Config.GasStationsBlips) do
			CreateBlip(gasStationCoords)
		end
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
			if fuelSynced then fuelSynced = false end
			if inBlacklisted then inBlacklisted = false end
		end
	end
end)

-- Client Events
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
						QBCore.Functions.Notify(Lang:t("error.fuel_more_than_zero"), 'error', 7500)
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
				QBCore.Functions.Notify(Lang:t("error.nozzle_cant_reach"), 'error')
				if Config.FuelNozzleExplosion then
					AddExplosion(grabbednozzlecoords.x, grabbednozzlecoords.y, grabbednozzlecoords.z, 'EXP_TAG_PROPANE', 1.0, true,false, 5.0)
					StartScriptFire(grabbednozzlecoords.x, grabbednozzlecoords.y, grabbednozzlecoords.z - 1, 25, false)
					SetFireSpreadRate(10.0)
					Wait(5000)
					StopFireInRange(grabbednozzlecoords.x, grabbednozzlecoords.y, grabbednozzlecoords.z - 1, 3.0)
				end
			end
			Wait(2500)
		end
	end)
end)

RegisterNetEvent('cdn-fuel:client:returnnozzle', function()
	holdingnozzle = false
	TargetCreated = false
	LoadAnimDict("pickup_object")
    TaskPlayAnim(ped, "pickup_object", "putdown_low", 2.0, 8.0, -1, 17, 0, 0, 0, 0)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "putbacknozzle", 0.4)
	StopAnimTask(ped, 'pickup_object', 'putdown_low', 1.0)
	Wait(250)
	if Config.FuelTargetExport then exports['qb-target']:AllowRefuel(false) end
	DeleteObject(fuelnozzle)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		DeleteObject(fuelnozzle)
	end
end)

if Config.RenewedPhonePayment then
	RegisterNetEvent('cdn-fuel:client:phone:PayForFuel', function(amount)
		local cost = amount * Config.CostMultiplier
		local tax = GlobalTax(cost)
		local total = math.ceil(cost + tax)
		local success = exports['qb-phone']:PhoneNotification(Lang:t("menu.gas_station"), Lang:t("txt.total") .. ' $'..total, 'fas fa-gas-pump', '#9f0e63', "NONE", 'fas fa-check-circle', 'fas fa-times-circle')
		if success then
			if QBCore.Functions.GetPlayerData().money['bank'] <= (GlobalTax(amount) + amount) then
				QBCore.Functions.Notify(Lang:t("error.not_enough_money"), "error")
			else
				TriggerServerEvent('cdn-fuel:server:PayForFuel', cost, "bank")
				RefuelPossible = true
				RefuelPossibleAmount = amount
				RefuelPurchaseType = "bank"
				RefuelCancelled = false
			end
		end
	end)
end

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
		header = Lang:t("txt.select_amount_fuel") .. "<br>" .. Lang:t("txt.current_price") .. ": $" ..
		FuelPrice .. " / " .. Lang:t("txt.liter") .. " <br> " .. Lang:t("txt.current_fuel") .. ": " .. finalfuel .. " " .. Lang:t("txt.liters") .. " <br> " .. Lang:t("txt.fuel_tank_cost") .. ": $" ..
		wholetankcostwithtax .. "",
		submitText = Lang:t("txt.insert_nozzle"),
		inputs = { {
			type = 'number',
			isRequired = true,
			name = 'amount',
			text = Lang:t("txt.tank_can_hold") .. ' ' .. maxfuel .. ' ' .. Lang:t("txt.more_liters")
		}}
	})
	if fuel then
		if not fuel.amount then return end
		if not holdingnozzle then return end
		if (fuel.amount + finalfuel) >= 100 then
			QBCore.Functions.Notify(Lang:t("error.cannot_fit"), "error")
		else
			if GlobalTax(fuel.amount * Config.CostMultiplier) + (fuel.amount * Config.CostMultiplier) <= money then
				local totalcost = (fuel.amount * Config.CostMultiplier)
				TriggerServerEvent('cdn-fuel:server:OpenMenu', totalcost, inGasStation, false, purchasetype)
			else
				QBCore.Functions.Notify(Lang:t("error.cant_afford"), 'error', 7500)
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
				header = Lang:t("menu.gas_station"),
				isMenuHeader = true,
				icon = "fas fa-gas-pump",
			},
			{
				header = Lang:t("menu.cash"),
				txt = Lang:t("txt.pay_cash") .. playercashamount .. ")",
				icon = "fas fa-usd",
				params = {
					event = "cdn-fuel:client:FinalMenu",
					args = 'cash',
				}
			},
			{
				header = Lang:t("menu.bank"),
				txt = Lang:t("txt.pay_card"),
				icon = "fas fa-credit-card",
				params = {
					event = "cdn-fuel:client:FinalMenu",
					args = 'bank',
				}
			},
			{
				header = Lang:t("menu.cancel"),
				txt = Lang:t("txt.dont_want_anymore"),
				icon = "fas fa-times-circle",
			},
		})
	else
		QBCore.Functions.Notify(Lang:t("error.already_full"), error)
	end
end)

RegisterNetEvent('cdn-fuel:client:RefuelVehicle', function(data)
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
	if not holdingnozzle then return end
	if amount < 1 then return end
	if amount < 10 then fuelamount = string.sub(amount, 1, 1) else fuelamount = string.sub(amount, 1, 2) end
	local refillCost = (amount * Config.CostMultiplier)
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local ped = PlayerPedId()
	local time = amount * Config.RefuelTime
	if amount < 10 then time = 10 * Config.RefuelTime end
	local vehicleCoords = GetEntityCoords(vehicle)
	if inGasStation then
		if isCloseVeh() then
			RequestAnimDict("timetable@gardener@filling_can")
			while not HasAnimDictLoaded('timetable@gardener@filling_can') do Wait(100) end
			if GetIsVehicleEngineRunning(vehicle) and Config.VehicleBlowUp then
				local Chance = math.random(1, 100)
				if Chance <= Config.BlowUpChance then
					AddExplosion(vehicleCoords, 5, 50.0, true, false, true)
					return
				end
			end
			TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 8.0, 1.0, -1, 1, 0, 0, 0, 0)
			refueling = true
			Refuelamount = 0
			CreateThread(function()
				while refueling do
					if Refuelamount == nil then Refuelamount = 0 end
					Wait(Config.RefuelTime)
					Refuelamount = Refuelamount + 1
					if Cancelledrefuel then
						local refillCostB4Tax = math.ceil(Refuelamount * Config.CostMultiplier)
						if Config.RenewedPhonePayment and purchasetype == "bank" then
							local remainingamount = (amount - Refuelamount)
							MoneyToGiveBack = (GlobalTax(remainingamount) + (remainingamount * Config.CostMultiplier))
							TriggerServerEvent("cdn-fuel:server:phone:givebackmoney", MoneyToGiveBack)
						else
							TriggerServerEvent('cdn-fuel:server:PayForFuel', refillCostB4Tax, purchasetype)
						end
						local curfuel = GetFuel(vehicle)
						local finalfuel = (curfuel + Refuelamount)
						if finalfuel >= 98 and finalfuel <= 100 then
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
			SetBusy(true)
			QBCore.Functions.Progressbar("refuel-car", Lang:t("progress.refueling"), time, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {},
				function()
					SetBusy(false)
					refueling = false
					if not Config.RenewedPhonePayment then TriggerServerEvent('cdn-fuel:server:PayForFuel', refillCost, purchasetype) end
					local curfuel = GetFuel(vehicle)
					local finalfuel = (curfuel + fuelamount)
					if finalfuel > 99 and finalfuel < 100 then
						SetFuel(vehicle, 100)
					else
						SetFuel(vehicle, finalfuel)
					end
					StopAnimTask(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
					TriggerServerEvent("InteractSound_SV:PlayOnSource", "fuelstop", 0.4)
					RefuelCancelled = true
					RefuelPossibleAmount = 0
					RefuelPossible = false
				end,
				function()
					SetBusy(false)
					refueling = false
					Cancelledrefuel = true
					StopAnimTask(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
					TriggerServerEvent("InteractSound_SV:PlayOnSource", "fuelstop", 0.4)
					
				end)
		end
	else return end
end)

-- Target Export

exports['qb-target']:AddTargetModel(props, {
	options = {
		{
			num = 1,
			type = "client",
			event = "cdn-fuel:client:grabnozzle",
			icon = "fas fa-gas-pump",
			label = Lang:t("txt.grab_nozzle"),
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
			label = Lang:t("txt.purchase_jerry"),
			canInteract = function()
				if not IsPedInAnyVehicle(PlayerPedId()) and not holdingnozzle then
					return true
				end
			end
		},
		{
			num = 3, -- This is the position number of your option in the list of options in the qb-target context menu (OPTIONAL)
			type = "client",
			event = "cdn-fuel:client:returnnozzle",
			icon = "fas fa-hand",
			label = Lang:t("txt.return_nozzle"),
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
					TriggerEvent("cdn-fuel:client:RefuelMenu")
				end,
				icon = "fas fa-gas-pump",
				label = Lang:t("txt.insert_nozzle"),
				canInteract = function()
					if inGasStation and not refueling and holdingnozzle then
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
	if IsPedInAnyVehicle(PlayerPedId(), false) then QBCore.Functions.Notify(Lang:t("error.cannot_from_inside"), 'error') return end
	if Config.FuelDebug then print("Item Data: " .. json.encode(itemData)) end
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local vehiclecoords = GetEntityCoords(vehicle)
	local pedcoords = GetEntityCoords(PlayerPedId())
	if GetVehicleBodyHealth(vehicle) < 100 then QBCore.Functions.Notify(Lang:t("error.too_damaged"), 'error') return end
	if holdingnozzle then
		local fulltank
		if itemData.info.gasamount == Config.JerryCanCap then fulltank = true
		GasString = Lang:t("txt.jerry_full")
		else fulltank = false
		GasString = Lang:t("txt.refuel_jerry")
		end
		exports['qb-menu']:openMenu({
			{
				header = Lang:t("menu.jerry_can"),
				isMenuHeader = true,
			},
			{
				header = Lang:t("menu.refuel_jerry"),
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
				header = Lang:t("menu.cancel"),
				txt = Lang:t("txt.dont_want_anymore"),
				icon = "fas fa-times-circle",
			},
		})
	else
		if #(vehiclecoords - pedcoords) > 2.5 then return end
		local nogas
		if itemData.info.gasamount < 1 then nogas = true
		GasString = Lang:t("txt.no_gas_jerry")
		else nogas = false
		GasString = Lang:t("txt.refuel_vehicle")
		end
		exports['qb-menu']:openMenu({
			{
				header = Lang:t("menu.jerry_can"),
				isMenuHeader = true,
			},
			{
				header = Lang:t("menu.refuel_vehicle"),
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
				header = Lang:t("menu.cancel"),
				txt = Lang:t("txt.dont_want_anymore"),
				icon = "fas fa-times-circle",
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
		if purchasetype == 'bank' then QBCore.Functions.Notify(Lang:t("error.not_enough_bank"), 'error') end
		if purchasetype == "cash" then QBCore.Functions.Notify(Lang:t("error.not_enough_pocket"), 'error') end
	end
end)

RegisterNetEvent('cdn-fuel:client:purchasejerrycan', function()
	local playercashamount = QBCore.Functions.GetPlayerData().money['cash']
	exports['qb-menu']:openMenu({
		{
			header = Lang:t("menu.purchase_jerry") .. " $"..(math.ceil(Config.JerryCanPrice + GlobalTax(Config.JerryCanPrice))),
			isMenuHeader = true,
			icon = "fas fa-fire-flame-simple",
		},
		{
			header = Lang:t("menu.cash"),
			txt = Lang:t("txt.pay_cash") .. playercashamount .. ")",
			icon = "fas fa-usd",
			params = {
				event = "cdn-fuel:client:jerrycanfinalmenu",
				args = 'cash',
			}
		},
		{
			header = "Bank",
			txt = Lang:t("txt.pay_card"),
			icon = "fas fa-credit-card",
			params = {
				event = "cdn-fuel:client:jerrycanfinalmenu",
				args = 'bank',
			}
		},
		{
			header = Lang:t("menu.cancel"),
			txt = Lang:t("txt.dont_want_anymore"),
			icon = "fas fa-times-circle",
		},
	})
end)

RegisterNetEvent('cdn-fuel:jerrycan:refuelvehicle', function(data)
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local vehfuel = math.floor(GetFuel(vehicle))
	local maxvehrefuel = (100 - math.ceil(vehfuel))
	local itemData = data.itemData
	local jerrycanfuelamount = itemData.info.gasamount
	if maxvehrefuel < Config.JerryCanCap then
		maxvehrefuel = maxvehrefuel
	else
		maxvehrefuel = Config.JerryCanCap
	end
	if maxvehrefuel >= jerrycanfuelamount then maxvehrefuel = jerrycanfuelamount elseif maxvehrefuel < jerrycanfuelamount then maxvehrefuel = maxvehrefuel end
	local refuel = exports['qb-input']:ShowInput({
		header = Lang:t("menu.how_much_gas"),
		submitText = Lang:t("menu.refuel_vehicle"),
		inputs = {
			{
				type = 'number',
				isRequired = true,
				name = 'amount',
				text = Lang:t("txt.can_insert") .. maxvehrefuel .. Lang:t("txt.liter_of_gas")
			}
		}
	})
	if refuel then
		if tonumber(refuel.amount) == 0 then QBCore.Functions.Notify(Lang:t("error.fuel_more_than_zero"), 'error') return elseif tonumber(refuel.amount) < 0 then QBCore.Functions.Notify(Lang:t("error.negative_amount"), 'error') return end
		if tonumber(refuel.amount) > jerrycanfuelamount then QBCore.Functions.Notify(Lang:t("error.not_this_much"), 'error') return end
		local refueltimer = Config.RefuelTime * tonumber(refuel.amount)
		if tonumber(refuel.amount) < 10 then refueltimer = Config.RefuelTime * 10 end
		SetBusy(true)
        JerrycanProp = CreateObject(GetHashKey('w_am_jerrycan'), 1.0, 1.0, 1.0, true, true, false)
        local lefthand = GetPedBoneIndex(PlayerPedId(), 18905)
        AttachEntityToEntity(JerrycanProp, PlayerPedId(), lefthand, 0.11 --[[Left - Right (Kind of)]] , 0.05--[[Up - Down]], 0.27 --[[Forward - Backward]], -15.0, 170.0, -90.42, 0, 1, 0, 1, 0, 1)
		QBCore.Functions.Progressbar('refuel_gas', Lang:t("progress.refueling") .. ' ' .. tonumber(refuel.amount) .. Lang:t("txt.liter_of_gas"), refueltimer, false, true, { -- Name | Label | Time | useWhileDead | canCancel
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, { animDict = Config.RefuelAnimDict, anim = Config.RefuelAnim, flags = 17, }, {}, {},
		function() -- Play When Done
			SetBusy(false)
			DeleteObject(JerrycanProp)
			StopAnimTask(PlayerPedId(), Config.RefuelAnimDict, Config.RefuelAnim, 1.0)
			QBCore.Functions.Notify(Lang:t("success.put").. ' ' .. tonumber(refuel.amount) .. Lang:t("success.into"), 'success')
			local syphonData = data.itemData
			local srcPlayerData = QBCore.Functions.GetPlayerData()
			TriggerServerEvent('cdn-fuel:info', "remove", tonumber(refuel.amount), srcPlayerData, syphonData)
			SetFuel(vehicle, (vehfuel + refuel.amount))
		end, function() -- Play When Cancel
			SetBusy(false)
			DeleteObject(JerrycanProp)
			StopAnimTask(PlayerPedId(), Config.RefuelAnimDict, Config.RefuelAnim, 1.0)
			QBCore.Functions.Notify(Lang:t("error.cancelled"), 'error')
		end)
	end
end)

RegisterNetEvent('cdn-fuel:jerrycan:refueljerrycan', function(data)
	local itemData = data.itemData
	local JerryCanMaxRefuel = (Config.JerryCanCap - itemData.info.gasamount)
	local jerrycanfuelamount = itemData.info.gasamount
	local refuel = exports['qb-input']:ShowInput({
		header = Lang:t("menu.how_much_gas") .. " (CASH)",
		submitText = Lang:t("menu.refuel_jerry"),
		inputs = { {
			type = 'number',
			isRequired = true,
			name = 'amount',
			text = Lang:t("txt.up_to") .. JerryCanMaxRefuel .. Lang:t("txt.liter_of_gas")
		} }
	})
	if refuel then
		if tonumber(refuel.amount) == 0 then QBCore.Functions.Notify(Lang:t("error.fuel_more_than_zero"), 'error') return elseif tonumber(refuel.amount) < 0 then QBCore.Functions.Notify(Lang:t("error.negative_amount"), 'error') return end
		if tonumber(refuel.amount) + tonumber(jerrycanfuelamount) > Config.JerryCanCap then QBCore.Functions.Notify(Lang:t("error.cant_fit_much_jerry"), 'error') return end
		if tonumber(refuel.amount) > Config.JerryCanCap then QBCore.Functions.Notify(Lang:t("error.cant_hold_much_jerry"), 'error') return end
		local refueltimer = Config.RefuelTime * tonumber(refuel.amount)
		if tonumber(refuel.amount) < 10 then refueltimer = Config.RefuelTime * 10 end
		local price = (tonumber(refuel.amount) * Config.CostMultiplier) + GlobalTax(tonumber(refuel.amount) * Config.CostMultiplier)
		if not CanAfford(price, "cash") then QBCore.Functions.Notify(Lang:t("error.not_enough_cash").." "..refuel.amount.."L!", 'error') return end
		if GetIsVehicleEngineRunning(vehicle) and Config.VehicleBlowUp then
			local Chance = math.random(1, 100)
			if Chance <= Config.BlowUpChance then
				AddExplosion(vehicleCoords, 5, 50.0, true, false, true)
				return
			end 
		end
		SetBusy(true)
        JerrycanProp = CreateObject(GetHashKey('w_am_jerrycan'), 1.0, 1.0, 1.0, true, true, false)
        local lefthand = GetPedBoneIndex(PlayerPedId(), 18905)
        AttachEntityToEntity(JerrycanProp, PlayerPedId(), lefthand, 0.11 --[[Left - Right (Kind of)]] , 0.05--[[Up - Down]], 0.27 --[[Forward - Backward]], -15.0, 170.0, -90.42, 0, 1, 0, 1, 0, 1)
		SetEntityVisible(fuelnozzle, false, 0)
		QBCore.Functions.Progressbar('refuel_gas', Lang:t("progress.refueling_jerry"), refueltimer, false,true, { -- Name | Label | Time | useWhileDead | canCancel
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, { animDict = Config.RefuelAnimDict, anim = Config.RefuelAnim, flags = 17, }, {}, {},
		function() -- Play When Done
			SetEntityVisible(fuelnozzle, true, 0)
			SetBusy(false)
			DeleteObject(JerrycanProp)
			StopAnimTask(PlayerPedId(), Config.RefuelAnimDict, Config.RefuelAnim, 1.0)
			QBCore.Functions.Notify(Lang:t("success.put") .. ' '  .. tonumber(refuel.amount) .. 'L'.. Lang:t("progress.refueling_jerry"), 'success')
			local syphonData = data.itemData
			local srcPlayerData = QBCore.Functions.GetPlayerData()
			TriggerServerEvent('cdn-fuel:info', "add", tonumber(refuel.amount), srcPlayerData, syphonData)
			TriggerServerEvent('cdn-fuel:server:PayForFuel', tonumber(refuel.amount) * Config.CostMultiplier, "cash")
		end, function() -- Play When Cancel
			SetEntityVisible(fuelnozzle, true, 0)
			SetBusy(false)
			DeleteObject(JerrycanProp)
			StopAnimTask(PlayerPedId(), Config.RefuelAnimDict, Config.RefuelAnim, 1.0)
			QBCore.Functions.Notify(Lang:t("error.cancelled"), 'error')
		end)
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
	if IsPedInAnyVehicle(PlayerPedId(), false) then QBCore.Functions.Notify(Lang:t("error.cannot_syphon"), 'error') return end
	if Config.SyphonDebug then print("Item Data: " .. json.encode(itemData)) end
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local vehiclecoords = GetEntityCoords(vehicle)
	local pedcoords = GetEntityCoords(PlayerPedId())
	if #(vehiclecoords - pedcoords) > 2.5 then return end
	if GetVehicleBodyHealth(vehicle) < 100 then QBCore.Functions.Notify(Lang:t("error.too_damaged_syphon"), 'error') return end
	local nogas
	if itemData.info.gasamount < 1 then nogas = true Nogasstring = Lang:t("error.no_gas_syphon") else nogas = false Nogasstring = Lang:t("txt.to_use_stolen") end
	local syphonfull if itemData.info.gasamount == Config.SyphonKitCap then syphonfull = true Stealfuelstring = Lang:t("success.syphon_full") .." " .. Config.SyphonKitCap .. "L!" elseif GetFuel(vehicle) < 1 then syphonfull = true Stealfuelstring = Lang:t("error.fuel_tank_empty") else syphonfull = false Stealfuelstring = Lang:t("txt.steal_fuel") end -- Disable Options based on item data
	exports['qb-menu']:openMenu({
		{
			header = Lang:t("menu.syphon_kit"),
			isMenuHeader = true,
		},
		{
			header = Lang:t("menu.syphon"),
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
			header = Lang:t("menu.refuel"),
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
			header = Lang:t("menu.cancel"),
			txt = Lang:t("txt.dont_want_anymore"),
			icon = "fas fa-times-circle",
		},
	})
end)

RegisterNetEvent('cdn-syphoning:syphon', function(data)
	local reason = data.reason
	local HasSyphon = QBCore.Functions.HasItem("syphoningkit", 1)
	if Config.SyphonDebug then print('Item Data Syphon: ' .. json.encode(data.itemData)) end
	if Config.SyphonDebug then print('Reason: ' .. reason) end
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
				header = Lang:t("menu.how_much_gas_steal"),
				submitText = Lang:t("txt.begin_syphon"),
				inputs = {
					{
						type = 'number',
						isRequired = true,
						name = 'amount',
						text = Lang:t("txt.you_can_steal") .. Stealstring .. 'L' ..  Lang:t("txt.from_the_car")
					}
				}
			})
			if syphon then
				if not syphon.amount then return end
				if tonumber(syphon.amount) < 0 then QBCore.Functions.Notify(Lang:t("error.steal_negative_amount"), 'error') return end
				if tonumber(syphon.amount) == 0 then QBCore.Functions.Notify(Lang:t("error.steal_more_than_zero"), 'error') return end
				if tonumber(syphon.amount) > maxsyphon then QBCore.Functions.Notify(Lang:t("error.cannot_syphon_this_much").. fitamount .. " L", 'error') return end
				if currentsyphonamount + syphon.amount > Config.SyphonKitCap then QBCore.Functions.Notify(Lang:t("error.cannot_syphon_this_much").. fitamount .. " L.", 'error') return end
				if (tonumber(syphon.amount) <= tonumber(cargasamount)) then
					local removeamount = (tonumber(cargasamount) - tonumber(syphon.amount))
					local syphonstring
					if tonumber(syphon.amount) < 10 then syphonstring = string.sub(syphon.amount, 1, 1) else syphonstring = string.sub(syphon.amount, 1, 2) end -- This is to remove the .0 part from them end for the notification.
					local syphontimer = Config.RefuelTime * syphon.amount
					if tonumber(syphon.amount) < 10 then syphontimer = Config.RefuelTime * 10 end
					SetBusy(true)
					QBCore.Functions.Progressbar('syphon_gas', ng:t("progress.syphoning").. ' ' .. syphonstring .. Lang:t("txt.liter_of_gas"), syphontimer, false, true,
					{ -- Name | Label | Time | useWhileDead | canCancel
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}, { animDict = Config.StealAnimDict, anim = Config.StealAnim, flags = 1, }, {}, {},
					function() -- Play When Done
						SetBusy(false)
						StopAnimTask(PlayerPedId(), Config.StealAnimDict, Config.StealAnim, 1.0)
						PoliceAlert(GetEntityCoords(PlayerPedId()))
						QBCore.Functions.Notify(Lang:t("success.syphon_success") .. ' ' .. syphonstring .. 'L', 'success')
						SetFuel(vehicle, removeamount)
						local syphonData = data.itemData
						local srcPlayerData = QBCore.Functions.GetPlayerData()
						TriggerServerEvent('cdn-fuel:info', "add", tonumber(syphon.amount), srcPlayerData, syphonData)
					end, function() -- Play When Cancel
						SetBusy(false)
						PoliceAlert(GetEntityCoords(PlayerPedId()))
						StopAnimTask(PlayerPedId(), Config.StealAnimDict, Config.StealAnim, 1.0)
						QBCore.Functions.Notify(Lang:t("error.cancelled"), 'error')
					end)
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
				header = Lang:t("menu.how_much_gas"),
				submitText = Lang:t("menu.refuel_vehicle"),
				inputs = {
					{
						type = 'number',
						isRequired = true,
						name = 'amount',
						text = Lang:t("txt.up_to").. " " .. Maxrefuel .. Lang:t("txt.liter_of_gas")
					}
				}
			})
			if refuel then
				if tonumber(refuel.amount) == 0 then QBCore.Functions.Notify(Lang:t("error.fuel_more_than_zero"), 'error') return elseif tonumber(refuel.amount) < 0 then QBCore.Functions.Notify(Lang:t("error.negative_amount"), 'error') return elseif tonumber(refuel.amount) > 100 then QBCore.Functions.Notify(Lang:t("error.cant_refuel_more"), 'error') return end
				if tonumber(refuel.amount) > tonumber(currentsyphonamount) then QBCore.Functions.Notify(Lang:t("error.not_enough_gas"), 'error') return end
				if tonumber(refuel.amount) + tonumber(cargasamount) > 100 then QBCore.Functions.Notify(Lang:t("error.cant_hold_this_much"), 'error') return end
				local refueltimer = Config.RefuelTime * tonumber(refuel.amount)
				if tonumber(refuel.amount) < 10 then refueltimer = Config.RefuelTime * 10 end
				SetBusy(true)
				QBCore.Functions.Progressbar('refuel_gas', Lang:t("progress.refueling") .. ' '  .. tonumber(refuel.amount) .. Lang:t("txt.liter_of_gas"), refueltimer, false, true, { -- Name | Label | Time | useWhileDead | canCancel
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, { animDict = Config.RefuelAnimDict, anim = Config.RefuelAnim, flags = 17, }, {}, {},
				function() -- Play When Done
					SetBusy(false)
					StopAnimTask(PlayerPedId(), Config.RefuelAnimDict, Config.RefuelAnim, 1.0)
					QBCore.Functions.Notify(Lang:t("success.put") .. ' '  .. tonumber(refuel.amount) .. Lang:t("success.into"), 'success')
					SetFuel(vehicle, cargasamount + tonumber(refuel.amount))
					local syphonData = data.itemData
					local srcPlayerData = QBCore.Functions.GetPlayerData()
					TriggerServerEvent('cdn-fuel:info', "remove", tonumber(refuel.amount), srcPlayerData, syphonData)
				end, function() -- Play When Cancel
					SetBusy(false)
					StopAnimTask(PlayerPedId(), Config.RefuelAnimDict, Config.RefuelAnim, 1.0)
					QBCore.Functions.Notify(Lang:t("error.cancelled"), 'error')
				end)
			end
		end
	else
		QBCore.Functions.Notify(Lang:t("error.need_something"), 'error', 7500)
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
	AddTextComponentString("(10-90) - Gasoline Theft")
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
