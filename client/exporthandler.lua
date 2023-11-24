local function exportHandler(exportName, func)
    AddEventHandler(('__cfx_export_LegacyFuel_%s'):format(exportName), function(setCB)
        setCB(func)
    end)
end

exportHandler('GetFuel', function(vehicle)
    return GetFuel(vehicle)
end)

exportHandler('SetFuel', function(vehicle, fuel)
    SetFuel(vehicle, fuel)
end)
