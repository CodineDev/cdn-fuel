if Config.PlayerOwnedGasStationsEnabled then -- This is so Player Owned Gas Stations are a Config Option, instead of forced. Set this option in shared/config.lua!
    
    -- Variables
    local QBCore = exports['qb-core']:GetCoreObject()
    
    -- Functions
    local function GlobalTax(value)
        local tax = (value / 100 * Config.GlobalTax)
        return tax
    end

    function math.percent(percent, maxvalue)
        if tonumber(percent) and tonumber(maxvalue) then
            return (maxvalue*percent)/100
        end
        return false
    end

    local function UpdateStationLabel(location, newLabel, src)
        if not newLabel or newLabel == nil then
            if Config.FuelDebug then print('Attempting to fetch label for Location #'..location) end
            MySQL.Async.fetchAll('SELECT label FROM fuel_stations WHERE location = ?', {location}, function(result)
                if result then
                    local data = result[1]
                    if data == nil then return end
                    local newLabel = data.label
                    TriggerClientEvent('cdn-fuel:client:updatestationlabels', -1, location, newLabel)
                else
                    if Config.FuelDebug then print('No Result! (UpdateStationLabel() line 29 station_sv.lua)') end
                    cb(false)
                end
            end)
        else
            if Config.FuelDebug then print(newLabel, location) end
            MySQL.Async.execute('UPDATE fuel_stations SET label = ? WHERE `location` = ?', {newLabel, location})
            if src then
                TriggerClientEvent('cdn-fuel:client:updatestationlabels', src, location, newLabel)
            else
                TriggerClientEvent('cdn-fuel:client:updatestationlabels', -1, location, newLabel)
            end
        end
    end
    
    -- Events
    RegisterNetEvent('cdn-fuel:server:updatelocationlabels', function()
        local src = source
        local location = 0
        for _ in pairs(Config.GasStations) do
            location = location + 1
            UpdateStationLabel(location, nil, src)
        end
    end)

    RegisterNetEvent('cdn-fuel:server:buyStation', function(location, CitizenID)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local CostOfStation = Config.GasStations[location].cost + GlobalTax(Config.GasStations[location].cost)
        if Player.Functions.RemoveMoney("bank", CostOfStation, Lang:t("stations.station_purchased_location_payment_label")..Config.GasStations[location].label) then
            MySQL.Async.execute('UPDATE fuel_stations SET owned = ? WHERE `location` = ?', {1, location})
            MySQL.Async.execute('UPDATE fuel_stations SET owner = ? WHERE `location` = ?', {CitizenID, location})
        end
    end)

    RegisterNetEvent('cdn-fuel:stations:server:sellstation', function(location)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local GasStationCost = Config.GasStations[location].cost + GlobalTax(Config.GasStations[location].cost)
        local SalePrice = math.percent(Config.GasStationSellPercentage, GasStationCost)
        if Player.Functions.AddMoney("bank", SalePrice, Lang:t("stations.station_sold_location_payment_label")..Config.GasStations[location].label) then
            MySQL.Async.execute('UPDATE fuel_stations SET owned = ? WHERE `location` = ?', {0, location})
            MySQL.Async.execute('UPDATE fuel_stations SET owner = ? WHERE `location` = ?', {0, location})
            TriggerClientEvent('QBCore:Notify', src, Lang:t("stations.station_sold_success"), 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("stations.station_cannot_sell"), 'error')
        end
    end)

    RegisterNetEvent('cdn-fuel:station:server:Withdraw', function(amount, location, StationBalance)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local setamount = (StationBalance - amount)
        if Config.FuelDebug then print("Attempting to withdraw $"..amount.." from Location #"..location.."'s Balance!") end
        if amount > StationBalance then TriggerClientEvent('QBCore:Notify', src, Lang:t("stations.station_withdraw_too_much"), 'success') return end
        MySQL.Async.execute('UPDATE fuel_stations SET balance = ? WHERE `location` = ?', {setamount, location})
        Player.Functions.AddMoney("bank", amount, Lang:t("stations.station_withdraw_payment_label")..Config.GasStations[location].label)
        TriggerClientEvent('QBCore:Notify', src, Lang:t("stations.station_success_withdrew_1")..amount..Lang:t("stations.station_success_withdrew_2"), 'success')
    end)

    RegisterNetEvent('cdn-fuel:station:server:Deposit', function(amount, location, StationBalance)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local setamount = (StationBalance + amount)
        if Config.FuelDebug then print("Attempting to deposit $"..amount.." to Location #"..location.."'s Balance!") end
        if Player.Functions.RemoveMoney("bank", amount, Lang:t("stations.station_deposit_payment_label")..Config.GasStations[location].label) then
            MySQL.Async.execute('UPDATE fuel_stations SET balance = ? WHERE `location` = ?', {setamount, location})
            TriggerClientEvent('QBCore:Notify', src, Lang:t("stations.station_success_deposit_1")..amount..Lang:t("stations.station_success_deposit_2"), 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("stations.station_cannot_afford_deposit")..amount.."!", 'success')
        end
    end)

    RegisterNetEvent('cdn-fuel:stations:server:Shutoff', function(location)
        local src = source
        if Config.FuelDebug then print("Toggling Emergency Shutoff Valves for Location #"..location) end
        Config.GasStations[location].shutoff = not Config.GasStations[location].shutoff
        Wait(5)
        TriggerClientEvent('QBCore:Notify', src, Lang:t("stations.station_shutoff_success"), 'success')
        if Config.FuelDebug then print('Successfully altered the shutoff valve state for location #'..location..'!') end
        if Config.FuelDebug then print(Config.GasStations[location].shutoff) end
    end)

    RegisterNetEvent('cdn-fuel:station:server:updatefuelprice', function(fuelprice, location)
        local src = source
        if Config.FuelDebug then print('Attempting to update Location #'..location.."'s Fuel Price to a new price: $"..fuelprice) end
        MySQL.Async.execute('UPDATE fuel_stations SET fuelprice = ? WHERE `location` = ?', {fuelprice, location})
        TriggerClientEvent('QBCore:Notify', src, Lang:t("stations.station_fuel_price_success")..fuelprice..Lang:t("stations.station_per_liter"), 'success')
    end)

    RegisterNetEvent('cdn-fuel:station:server:updatereserves', function(reason, amount, currentlevel, location)
        if reason == "remove" then
            NewLevel = (currentlevel - amount)
        elseif reason == "add" then
            NewLevel = (currentlevel + amount)
        else
            if Config.FuelDebug then print("Reason is not a valid string! It should be 'add' or 'remove'!") end
        end
        if Config.FuelDebug then print('Attempting to '..reason..' '..amount..' to / from Location #'..location.."'s Reserves!") end
        MySQL.Async.execute('UPDATE fuel_stations SET fuel = ? WHERE `location` = ?', {NewLevel, location})
        if Config.FuelDebug then print('Successfully executed the previous SQL Update!') end
    end)

    RegisterNetEvent('cdn-fuel:station:server:updatebalance', function(reason, amount, StationBalance, location, FuelPrice)
        if Config.FuelDebug then print("Amount: "..amount) end
        local Price = (FuelPrice * tonumber(amount))
        local StationGetAmount = math.floor(Config.StationFuelSalePercentage * Price)
        if reason == "remove" then
            NewBalance = (StationBalance - StationGetAmount)
        elseif reason == "add" then
            NewBalance = (StationBalance + StationGetAmount)
        else
            if Config.FuelDebug then print("Reason is not a valid string! It should be 'add' or 'remove'!") end
        end
        if Config.FuelDebug then print('Attempting to '..reason..' '..StationGetAmount..' to / from Location #'..location.."'s Balance!") end
        MySQL.Async.execute('UPDATE fuel_stations SET balance = ? WHERE `location` = ?', {NewBalance, location})
        if Config.FuelDebug then print('Successfully executed the previous SQL Update!') end
    end)

    RegisterNetEvent('cdn-fuel:stations:server:buyreserves', function(location, price, amount)
        local location = location
        local price = price
        local amount = amount
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local result = MySQL.Sync.fetchAll('SELECT * FROM fuel_stations WHERE `location` = ?', {location})
        if result then
            if Config.FuelDebug then print("Result Fetched!") end
            for k, v in pairs(result) do
                local gasstationinfo = json.encode(v)
                if Config.FuelDebug then print(gasstationinfo) print(v.fuel) end
                if v.fuel + amount > Config.MaxFuelReserves then
                    ReserveBuyPossible = false
                    if Config.FuelDebug then print("Purchase is not possible, as reserves will be greater than the maximum amount!") end
                    TriggerClientEvent('QBCore:Notify', src, Lang:t("stations.station_reserves_over_max"), 'error')
                elseif v.fuel + amount <= Config.MaxFuelReserves then
                    ReserveBuyPossible = true
                    OldAmount = v.fuel
                    NewAmount = OldAmount + amount
                    if Config.FuelDebug then print("Purchase is possible, as reserves will be below or equal to the maximum amount!") end
                else
                    if Config.FuelDebug then print('error fetching v.fuel') end
                end
            end
        else
            if Config.FuelDebug then print("No Result Fetched!!") end
        end
        if Config.FuelDebug then print("Attempting Sale Server Side for location: #"..location.." for Price: $"..price) end
        if ReserveBuyPossible and Player.Functions.RemoveMoney("bank", price, "Purchased"..amount.."L of Reserves for: "..Config.GasStations[location].label.." @ $"..Config.FuelReservesPrice.." / L!") then
            MySQL.Async.execute('UPDATE fuel_stations SET fuel = ? WHERE `location` = ?', {NewAmount, location})
            if Config.FuelDebug then print("SQL Execute Update: fuel_station level to: "..NewAmount.. " Math: ("..amount.." + "..OldAmount.." = "..NewAmount) end
        elseif ReserveBuyPossible then
            TriggerClientEvent('QBCore:Notify', src, Lang:t("fuel.not_enough_money"), 'error')
        end
    end)

    RegisterNetEvent('cdn-fuel:station:server:updatelocationname', function(newName, location)
        local src = source
        if Config.FuelDebug then print('Attempting to set name for Location #'..location..' to: '..newName) end
        MySQL.Async.execute('UPDATE fuel_stations SET label = ? WHERE `location` = ?', {newName, location})
        if Config.FuelDebug then print('Successfully executed the previous SQL Update!') end
        TriggerClientEvent('QBCore:Notify', src, Lang:t("stations.station_name_change_success")..newName.."!", 'success')
        TriggerClientEvent('cdn-fuel:client:updatestationlabels', -1, location, newName)
    end)

    -- Callbacks 
    QBCore.Functions.CreateCallback('cdn-fuel:server:locationpurchased', function(source, cb, location)
        if Config.FuelDebug then print("Working on it.") end
        local result = MySQL.Sync.fetchAll('SELECT * FROM fuel_stations WHERE `location` = ?', {location})
        if result then
            for k, v in pairs(result) do
                local gasstationinfo = json.encode(v)
                if Config.FuelDebug then print(gasstationinfo) end
                local owned = false
                if Config.FuelDebug then print(v.owned) end
                if v.owned == 1 then
                    owned = true
                    if Config.FuelDebug then print("Owned Status: True") end
                elseif v.owned == 0 then
                    owned = false
                    if Config.FuelDebug then print("Owned Status: False") end
                else
                    if Config.FuelDebug then print("Owned State (v.owned ~= 1 or 0) It must be 1 or 0! 1 = True, 0 = False!") end
                end
                cb(owned)
            end
        else
            if Config.FuelDebug then print("No Result Fetched!!") end
        end
	end)

    QBCore.Functions.CreateCallback('cdn-fuel:server:isowner', function(source, cb, location)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local citizenid = Player.PlayerData.citizenid
        if Config.FuelDebug then print("working on it.") end
        local result = MySQL.Sync.fetchAll('SELECT * FROM fuel_stations WHERE `owner` = ? AND location = ?', {citizenid, location})
        if result then
            if Config.FuelDebug then print("Got result!") print("Result: "..json.encode(result)) end
            for _, v in pairs(result) do
                if Config.FuelDebug then print("Owned State: "..v.owned) print("Owner: "..v.owner) end
                if v.owner == citizenid and v.owned == 1 then
                    cb(true) if Config.FuelDebug then print(citizenid.." is the owner.. owner state == "..v.owned) end
                else
                    cb(false) if Config.FuelDebug then print("The owner is: "..v.owner) end
                end
            end
        else
            if Config.FuelDebug then print("No Result Sadge!") end
            cb(false)
        end
	end)

    QBCore.Functions.CreateCallback('cdn-fuel:server:fetchinfo', function(source, cb, location)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if Config.FuelDebug then print("Fetching Information for Location: "..location) end
        MySQL.Async.fetchAll('SELECT * FROM fuel_stations WHERE location = ?', {location}, function(result)
            if result then
                cb(result)
                if Config.FuelDebug then print(json.encode(result)) end
            else
                cb(false)
            end
	    end)
	end)

    QBCore.Functions.CreateCallback('cdn-fuel:server:checkshutoff', function(source, cb, location)
        if Config.FuelDebug then print("Fetching Shutoff State for Location: "..location) end
        cb(Config.GasStations[location].shutoff)
	end)
    
    QBCore.Functions.CreateCallback('cdn-fuel:server:fetchlabel', function(source, cb, location)
        if Config.FuelDebug then print("Fetching Shutoff State for Location: "..location) end
        MySQL.Async.fetchAll('SELECT label FROM fuel_stations WHERE location = ?', {location}, function(result)
            if result then
                cb(result)
                if Config.FuelDebug then print(result) end
            else
                cb(false)
            end
	    end)
	end)

    -- Startup Process
    local function Startup()
        if Config.FuelDebug then print("Startup process...") end
        local location = 0
        for value in ipairs(Config.GasStations) do
            location = location + 1
            
            UpdateStationLabel(location)
        end
    end

    AddEventHandler('onResourceStart', function(resource)
        if resource == GetCurrentResourceName() then
            Startup()
        end
    end)

end -- For Config.PlayerOwnedGasStationsEnabled check, don't remove!