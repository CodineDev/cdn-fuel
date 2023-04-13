local QBCore = exports[Config.Core]:GetCoreObject()

function GetFuel(vehicle)
	return DecorGetFloat(vehicle, Config.FuelDecor)
end

function SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, Config.FuelDecor, GetVehicleFuelLevel(vehicle))
	end
end

function LoadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Wait(5)
	end
end

function GlobalTax(value)
	if Config.GlobalTax < 0.1 then
		return 0
	end
	local tax = (value / 100 * Config.GlobalTax)
	return tax
end

function Comma_Value(amount)
	local formatted = amount
	while true do  
	  formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
	  if (k==0) then
		break
	  end
	end
	return formatted
end

function math.percent(percent, maxvalue)
	if tonumber(percent) and tonumber(maxvalue) then
		return (maxvalue*percent)/100
	end
	return false
end

function Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function GetCurrentVehicleType(vehicle)
	if not vehicle then 
		vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
	end
	if not vehicle then return false end
	local vehiclename = GetEntityModel(vehicle)
	for _, currentCar in pairs(Config.ElectricVehicles) do
		if currentCar == vehiclename or joaat(currentCar) == vehiclename then
		  	return 'electricvehicle'
		end
	end
	return 'gasvehicle'
end

function CreateBlip(coords, label)
	local blip = AddBlipForCoord(coords)
	local vehicle = GetCurrentVehicleType()
	local electricbolt = Config.ElectricSprite -- Sprite
	if vehicle == 'electricvehicle' then
		SetBlipSprite(blip, electricbolt) -- This is where the fuel thing will get changed into the electric bolt instead of the pump.
		SetBlipColour(blip, 5)
	else
		SetBlipColour(blip, 4)
		SetBlipSprite(blip, 361)
	end
	SetBlipScale(blip, 0.6)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(label)
	EndTextCommandSetBlipName(blip)
	return blip
end

function IsPlayerNearVehicle()
	if Config.FuelDebug then
		print("Checking if player is near a vehicle!")
	end
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local closestVehCoords = GetEntityCoords(vehicle)
	if #(GetEntityCoords(PlayerPedId(), closestVehCoords)) > 3.0 then
		return true
	end
	return false
end