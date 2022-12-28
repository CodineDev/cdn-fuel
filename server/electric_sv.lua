-- Variables
local QBCore = exports['qb-core']:GetCoreObject()
-- Functions

-- Events
RegisterNetEvent("cdn-fuel:server:electric:OpenMenu", function(amount, inGasStation, hasWeapon, purchasetype, FuelPrice)
	local src = source
	if not src then print("SRC is nil!") return end
	local player = QBCore.Functions.GetPlayer(src)
	if not player then print("Player is nil!") return end
	local tax = GlobalTax(amount)
	local total = math.ceil(amount + tax)
	local fuelamounttotal = (amount / FuelPrice)
	if amount < 1 then TriggerClientEvent('QBCore:Notify', src, "You can't charge a negative amount!", 'error') return end
	Wait(50)
	if inGasStation and not hasWeapon then
		if Config.RenewedPhonePayment and purchasetype == "bank" then
			TriggerClientEvent("cdn-fuel:client:electric:phone:PayForFuel", src, fuelamounttotal)
		else
			TriggerClientEvent('qb-menu:client:openMenu', src, {
				{
					header = "Gas Station",
					isMenuHeader = true,
					icon = "fas fa-bolt",
				},
				{
					header = "",
					icon = "fas fa-info-circle",
					isMenuHeader = true,
					txt = 'The total cost is going to be: $'..total..' including taxes.' ,
				},
				{
					header = "Confirm",
					icon = "fas fa-check-circle",
					txt = 'I would like to pay for electricity.' ,
					params = {
						event = "cdn-fuel:client:electric:ChargeVehicle",
						args = {
							fuelamounttotal = fuelamounttotal, 
							purchasetype = purchasetype,
						}
					}
				},
				{
					header = "Cancel",
					txt = "I actually don't want fuel anymore.", 
					icon = "fas fa-times-circle",
				},
			})
		end
	end
end)