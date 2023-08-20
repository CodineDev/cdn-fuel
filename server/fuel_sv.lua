-- Variables
if Config.Core ~= "ESX" then
	QBCore = exports[Config.Core]:GetCoreObject()
else
	ESX = exports["es_extended"]:getSharedObject()
end

function Translate(key)
	if Config.Core == "qb-core" or Config.Core == "qbx-core" then
		return Lang:t(key)
	else
		return FetchLocale(key)
	end
end

-- Functions
local function GlobalTax(value)
	local tax = (value / 100 * Config.GlobalTax)
	return tax
end

--- Events
if Config.RenewedPhonePayment and Config.Core ~= "ESX"  then
	RegisterNetEvent('cdn-fuel:server:phone:givebackmoney', function(amount)
		local src = source
		local player = QBCore.Functions.GetPlayer(src)
		player.Functions.AddMoney("bank", math.ceil(amount), Translate("phone_refund_payment_label"))
	end)
end

RegisterNetEvent("cdn-fuel:server:OpenMenu", function(amount, inGasStation, hasWeapon, purchasetype, FuelPrice)
	local src = source
	if not src then return end
	if not amount then if Config.FuelDebug then print("Amount is invalid!") end TriggerClientEvent('QBCore:Notify', src, Translate("more_than_zero"), 'error') return end
	local FuelCost = amount*FuelPrice
	local tax = GlobalTax(FuelCost)
	local total = tonumber(FuelCost + tax)
	if inGasStation == true and not hasWeapon then
		if Config.RenewedPhonePayment and purchasetype == "bank" then
			TriggerClientEvent("cdn-fuel:client:phone:PayForFuel", src, amount)
		else
			if Config.Ox.Menu then
				if Config.FuelDebug then print("going to open the context menu (OX)") end
				TriggerClientEvent('cdn-fuel:client:OpenContextMenu', src, total, amount, purchasetype)
			else
				TriggerClientEvent('qb-menu:client:openMenu', src, {
					{
						header = Translate("menu_refuel_header"),
						isMenuHeader = true,
						icon = "fas fa-gas-pump",
					},
					{
						header = "",
						icon = "fas fa-info-circle",
						isMenuHeader = true,
						txt = Translate("menu_purchase_station_header_1")..math.ceil(total)..Translate("menu_purchase_station_header_2") ,
					},
					{
						header = Translate("menu_purchase_station_confirm_header"),
						icon = "fas fa-check-circle",
						txt = Translate("menu_refuel_accept"),
						params = {
							event = "cdn-fuel:client:RefuelVehicle",
							args = {
								fuelamounttotal = amount,
								purchasetype = purchasetype,
							}
						}
					},
					{
						header = Translate("menu_header_close"),
						txt = Translate("menu_refuel_cancel"),
						icon = "fas fa-times-circle",
						params = {
							event = "qb-menu:closeMenu",
						}
					},
				})
			end
		end
	end
end)

RegisterNetEvent("cdn-fuel:server:PayForFuel", function(amount, purchasetype, FuelPrice, electric)
	local src = source
	if not src then return end
	if Config.Core ~= "ESX" then
		Player = QBCore.Functions.GetPlayer(src)
	else
		Player = ESX.GetPlayerFromId(src)
	end
	if not Player then return end
	local total = math.ceil(amount)
	if amount < 1 then
		total = 0
	end
	local moneyremovetype = purchasetype
	if Config.FuelDebug then print("Player is attempting to purchase fuel with the money type: " ..moneyremovetype) end
	if Config.FuelDebug then print("Attempting to charge client: $"..total.." for Fuel @ "..FuelPrice.." PER LITER | PER KW") end
	if purchasetype == "bank" then
		moneyremovetype = "bank"
	elseif purchasetype == "cash" then
		moneyremovetype = "cash"
	end
	local payString = Translate("menu_pay_label_1") ..FuelPrice..Translate("menu_pay_label_2")
	if electric then payString = Translate("menu_electric_payment_label_1") ..FuelPrice..Translate("menu_electric_payment_label_2") end
	if Config.Core == "ESX" then
		Player.removeAccountMoney(moneyremovetype == "cash" and "money" or "bank", total)
	else
		Player.Functions.RemoveMoney(moneyremovetype, total, payString)
	end
end)

RegisterNetEvent("cdn-fuel:server:purchase:jerrycan", function(purchasetype)
	local src = source if not src then return end
	if Config.Core ~= "ESX" then
		Player = QBCore.Functions.GetPlayer(src)
		if not Player then return end
	else
		Player = ESX.GetPlayerFromId(src)
	end
	local tax = GlobalTax(Config.JerryCanPrice) local total = math.ceil(Config.JerryCanPrice + tax)
	local moneyremovetype = purchasetype
	if purchasetype == "bank" then
		moneyremovetype = "bank"
	elseif purchasetype == "cash" then
		moneyremovetype = "cash"
	end
	if Config.Ox.Inventory then
		local info = {cdn_fuel = tostring(Config.JerryCanGas)}
		exports.ox_inventory:AddItem(src, 'jerrycan', 1, info)
		local hasItem = exports.ox_inventory:GetItem(src, 'jerrycan', info, 1)
		if hasItem then
			if Config.Core == "ESX" then
				Player.removeAccountMoney(moneyremovetype == "cash" and "money" or "bank", total)
			else
				Player.Functions.RemoveMoney(moneyremovetype, total, Translate("jerry_can_payment_label"))
			end
		end
	else
		local info = {gasamount = Config.JerryCanGas}
		if Player.Functions.AddItem("jerrycan", 1, false, info) then -- Dont remove money if AddItem() not possible!
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['jerrycan'], "add")
			if Config.Core == "ESX" then
				Player.removeAccountMoney(moneyremovetype, total)
			else
				Player.Functions.RemoveMoney(moneyremovetype, total, Translate("jerry_can_payment_label"))
			end
		end
	end
end)

--- Jerry Can
--- Jerry Can
if Config.UseJerryCan and Config.Core ~= "ESX" and not Config.Ox.Inventory then
	QBCore.Functions.CreateUseableItem("jerrycan", function(source, item)
		local src = source
		TriggerClientEvent('cdn-fuel:jerrycan:refuelmenu', src, item)
	end)
end

--- Syphoning
if Config.UseSyphoning and Config.Core ~= "ESX" and not Config.Ox.Inventory then
	QBCore.Functions.CreateUseableItem("syphoningkit", function(source, item)
		local src = source
		if Config.Ox.Inventory then
			if item.metadata.cdn_fuel == nil then
				item.metadata.cdn_fuel = '0'
				exports.ox_inventory:SetMetadata(src, item.slot, item.metadata)
			end
		end
		TriggerClientEvent('cdn-syphoning:syphon:menu', src, item)
	end)
end

RegisterNetEvent('cdn-fuel:info', function(type, amount, srcPlayerData, itemdata)
	print("cdn-fuel:info", type, amount)
    local src = source
    local Player
	if (Config.Core == "qb-core" or Config.Core == "qbx-core") and not Config.Ox.Inventory then
		Player = QBCore.Functions.GetPlayer(src)
	end
    local srcPlayerData = srcPlayerData
	local ItemName = itemdata.name

	print("Attempting to update item metadata: "..ItemName.." Old Data: "..json.encode(itemdata))

	if Config.Ox.Inventory then
		if itemdata == "jerrycan" then
			if amount < 1 or amount > Config.JerryCanCap then if Config.FuelDebug then print("Error, amount is invalid (< 1 or > "..Config.SyphonKitCap..")! Amount:" ..amount) end return end
		elseif itemdata == "syphoningkit" then
			if amount < 1 or amount > Config.SyphonKitCap then if Config.SyphonDebug then print("Error, amount is invalid (< 1 or > "..Config.SyphonKitCap..")! Amount:" ..amount) end return end
		end
		if ItemName ~= nil then
			-- Ignore --
			itemdata.metadata = itemdata.metadata
			itemdata.slot = itemdata.slot
			if ItemName == 'jerrycan' then
				local fuel_amount = tonumber(itemdata.metadata.cdn_fuel)
				if type == "add" then
					fuel_amount = fuel_amount + amount
					itemdata.metadata.cdn_fuel = tostring(fuel_amount)
					exports.ox_inventory:SetMetadata(src, itemdata.slot, itemdata.metadata)
				elseif type == "remove" then
					fuel_amount = fuel_amount - amount
					itemdata.metadata.cdn_fuel = tostring(fuel_amount)
					exports.ox_inventory:SetMetadata(src, itemdata.slot, itemdata.metadata)
				else
					if Config.FuelDebug then print("error, type is invalid!") end
				end
			elseif ItemName == 'syphoningkit' then
				local fuel_amount = tonumber(itemdata.metadata.cdn_fuel)
				if type == "add" then
					fuel_amount = fuel_amount + amount
					itemdata.metadata.cdn_fuel = tostring(fuel_amount)
					exports.ox_inventory:SetMetadata(src, itemdata.slot, itemdata.metadata)
				elseif type == "remove" then
					fuel_amount = fuel_amount - amount
					itemdata.metadata.cdn_fuel = tostring(fuel_amount)
					exports.ox_inventory:SetMetadata(src, itemdata.slot, itemdata.metadata)
				else
					if Config.SyphonDebug then print("error, type is invalid!") end
				end
			end
		else
			if Config.FuelDebug then
				print("ItemName is invalid!")
			end
		end
	else
		if itemdata.info.name == "jerrycan" then
			if amount < 1 or amount > Config.JerryCanCap then if Config.FuelDebug then print("Error, amount is invalid (< 1 or > "..Config.SyphonKitCap..")! Amount:" ..amount) end return end
		elseif itemdata.info.name == "syphoningkit" then
			if amount < 1 or amount > Config.SyphonKitCap then if Config.SyphonDebug then print("Error, amount is invalid (< 1 or > "..Config.SyphonKitCap..")! Amount:" ..amount) end return end
		end

		if type == "add" then
			if not srcPlayerData.items[itemdata.slot].info.gasamount then
				srcPlayerData.items[itemdata.slot].info = {
					gasamount = amount,
				}
			else
				srcPlayerData.items[itemdata.slot].info.gasamount = srcPlayerData.items[itemdata.slot].info.gasamount + amount
			end
			Player.Functions.SetInventory(srcPlayerData.items)
		elseif type == "remove" then
			srcPlayerData.items[itemdata.slot].info.gasamount = srcPlayerData.items[itemdata.slot].info.gasamount - amount
			Player.Functions.SetInventory(srcPlayerData.items)
		else
			if Config.SyphonDebug then print("error, type is invalid!") end
		end
	end
end)

RegisterNetEvent('cdn-syphoning:callcops', function(coords)
    TriggerClientEvent('cdn-syphoning:client:callcops', -1, coords)
end)

--- Update Alerts
local updatePath
local resourceName

local function checkVersion(err, responseText, headers)
    local curVersion = LoadResourceFile(GetCurrentResourceName(), "version")
	if responseText == nil then print("^1"..resourceName.." check for updates failed ^7") return end
    if curVersion ~= nil and responseText ~= nil then
		if curVersion == responseText then Color = "^2" else Color = "^1" end
		if curVersion ~= responseText then
			
		else
			print("\n^1----------------------------------------------------------------------------------^7")
			print(resourceName.." is up to date.")
			print("^1----------------------------------------------------------------------------------^7")
		end
        print("\n^1----------------------------------------------------------------------------------^7")
        print(resourceName.."'s latest version is: ^2"..responseText.."!\n^7Your current version: "..Color..""..curVersion.."^7!\nIf needed, update from https://github.com"..updatePath.."")
        print("^1----------------------------------------------------------------------------------^7")
    end
end

CreateThread(function()
	updatePath = "/CodineDev/cdn-fuel"
	resourceName = "cdn-fuel ("..GetCurrentResourceName()..")"
	PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version", checkVersion, "GET")
end)