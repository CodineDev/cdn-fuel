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
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Wait(1)
		end
	end
end

function Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function CreateBlip(coords)
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, 361)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, 4)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Gas Station")
	EndTextCommandSetBlipName(blip)
	return blip
end


function isCloseVeh()
    local ped = PlayerPedId()
    coordA = GetEntityCoords(ped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 200.0, 0.0)
    vehicle = getVehicleInDirection(coordA, coordB)
    if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
        return true
    end
    return false
end

function getVehicleInDirection(coordFrom, coordTo)
	local offset = 0
	local rayHandle
	local vehicle
	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)	
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		offset = offset - 1
		if vehicle ~= 0 then break end
	end
	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	if distance > 25 then vehicle = nil end
    return vehicle ~= nil and vehicle or 0
end