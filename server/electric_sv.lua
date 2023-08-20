-- Functions
local function GlobalTax(value)
	local tax = (value / 100 * Config.GlobalTax)
	return tax
end

-- Events
RegisterNetEvent("cdn-fuel:server:electric:OpenMenu", function(amount, inGasStation, hasWeapon, purchasetype, FuelPrice)
	local src = source
	if not src then print("SRC is nil!") return end
	local player = QBCore.Functions.GetPlayer(src)
	if not player then print("Player is nil!") return end
	local FuelCost = amount*FuelPrice
	local tax = GlobalTax(FuelCost)
	local total = tonumber(FuelCost + tax)
	if not amount then if Config.FuelDebug then print("Electric Recharge Amount is invalid!") end TriggerClientEvent('QBCore:Notify', src, Translate("electric_more_than_zero"), 'error') return end
	Wait(50)
	if inGasStation and not hasWeapon then
		if Config.RenewedPhonePayment and purchasetype == "bank" then
			TriggerClientEvent("cdn-fuel:client:electric:phone:PayForFuel", src, amount)
		else
			if Config.Ox.Menu then
				TriggerClientEvent('cdn-electric:client:OpenContextMenu', src, math.ceil(total), amount, purchasetype)
			else
				TriggerClientEvent('qb-menu:client:openMenu', src, {
					{
						header = Translate("menu_electric_header"),
						isMenuHeader = true,
						icon = "fas fa-bolt",
					},
					{
						header = "",
						icon = "fas fa-info-circle",
						isMenuHeader = true,
						txt = Translate("menu_purchase_station_header_1")..math.ceil(total)..Translate("menu_purchase_station_header_2"),
					},
					{
						header = Translate("menu_purchase_station_confirm_header"),
						icon = "fas fa-check-circle",
						txt = Translate("menu_electric_accept"),
						params = {
							event = "cdn-fuel:client:electric:ChargeVehicle",
							args = {
								fuelamounttotal = amount,
								purchasetype = purchasetype,
							}
						}
					},
					{
						header = Translate("menu_header_close"),
						txt = Translate("menu_electric_cancel"),
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