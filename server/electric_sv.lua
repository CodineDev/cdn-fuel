-- Variables
local QBCore = exports['qb-core']:GetCoreObject()

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
	local tax = GlobalTax(amount)
	local total = math.ceil(amount + tax)
	local fuelamounttotal = (amount / FuelPrice)
	if amount < 1 then TriggerClientEvent('QBCore:Notify', src, Lang:t("electric_more_than_zero"), 'error') return end
	Wait(50)
	if inGasStation and not hasWeapon then
		if Config.RenewedPhonePayment and purchasetype == "bank" then
			TriggerClientEvent("cdn-fuel:client:electric:phone:PayForFuel", src, fuelamounttotal)
		else
			TriggerClientEvent('qb-menu:client:openMenu', src, {
				{
					header = Lang:t("menu_electric_header"),
					isMenuHeader = true,
					icon = "fas fa-bolt",
				},
				{
					header = "",
					icon = "fas fa-info-circle",
					isMenuHeader = true,
					txt = Lang:t("menu_purchase_station_header_1")..total..Lang:t("menu_purchase_station_header_2") ,
				},
				{
					header = Lang:t("menu_purchase_station_confirm_header"),
					icon = "fas fa-check-circle",
					txt = Lang:t("menu_electric_accept"),
					params = {
						event = "cdn-fuel:client:electric:ChargeVehicle",
						args = {
							fuelamounttotal = fuelamounttotal, 
							purchasetype = purchasetype,
						}
					}
				},
				{
					header = Lang:t("menu_header_close"),
					txt = Lang:t("menu_electric_cancel"), 
					icon = "fas fa-times-circle",
					params = {
						event = "qb-menu:closeMenu",
					}
				},
			})
		end
	end
end)