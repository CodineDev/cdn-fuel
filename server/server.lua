-- Variables

local QBCore = exports['qb-core']:GetCoreObject()

-- Functions

local function GlobalTax(value)
	local tax = (value / 100 * Config.GlobalTax)
	return tax
end

-- Server Events

RegisterNetEvent("cdn-fuel:server:OpenMenu", function(amount, inGasStation, hasWeapon, purchasetype)
	local src = source
	if not src then return end
	local player = QBCore.Functions.GetPlayer(src)
	if not player then return end
	local tax = GlobalTax(amount)
	local total = math.ceil(amount + tax)
	local fuelamounttotal = (amount / Config.CostMultiplier)
	if amount < 1 then TriggerClientEvent('QBCore:Notify', src, "You can't fuel a negative amount!", 'error') return end
	if inGasStation == true and not hasWeapon then
		TriggerClientEvent('qb-menu:client:openMenu', src, {
			{
				header = 'Gas Station',
				txt = 'The total cost is going to be: $'..total..' including taxes.' ,
				params = {
					event = "cdn-fuel:client:RefuelVehicle",
					args = {
						fuelamounttotal = fuelamounttotal, 
						purchasetype = purchasetype,
					}
				}
			},
		})
	end
end)

RegisterNetEvent("cdn-fuel:server:PayForFuel", function(amount, purchasetype)
	local src = source
	if not src then return end
	local player = QBCore.Functions.GetPlayer(src)
	if not player then return end
	local tax = GlobalTax(amount)
	local total = math.ceil(amount + tax)
	local moneyremovetype = purchasetype
	if purchasetype == "bank" then
		moneyremovetype = "bank"
	elseif purchasetype == "cash" then
		moneyremovetype = "cash"
	end
	local fuelprice = (Config.CostMultiplier * 1)
	if Config.FuelPurchaseDescription then
		player.Functions.RemoveMoney(moneyremovetype, total, "Purchased Fuel")
	else
		player.Functions.RemoveMoney(moneyremovetype, total)
	end
end)