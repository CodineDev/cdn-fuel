if Config.PlayerOwnedGasStationsEnabled then -- This is so Player Owned Gas Stations are a Config Option, instead of forced. Set this option in shared/config.lua!
    
    -- Variables
    local QBCore = exports['qb-core']:GetCoreObject()
    local PedsSpawned = false

    -- Functions
    function math.percent(percent, maxvalue)
        if tonumber(percent) and tonumber(maxvalue) then
            return (maxvalue*percent)/100
        end
        return false
    end

    local function UpdateStationInfo(info)
        if Config.FuelDebug then print("Fetching Information for Location #" ..CurrentLocation) end
        QBCore.Functions.TriggerCallback('cdn-fuel:server:fetchinfo', function(result)
            if result then
                for _, v in pairs(result) do
                    -- Reserves --
                    if info == "all" or info == "reserves" then
                        if Config.FuelDebug then print("Fetched Reserve Levels: "..v.fuel.." Liters!") end
                        Currentreserveamount = v.fuel
                        ReserveLevels = Currentreserveamount
                        if Currentreserveamount < Config.MaxFuelReserves then
                            ReservesNotBuyable = false
                        else
                            ReservesNotBuyable = true
                        end
                        if Config.UnlimitedFuel then ReservesNotBuyable = true if Config.FuelDebug then print("Reserves are not buyable, because Config.UnlimitedFuel is set to true.") end end
                    end
                    -- Fuel Price --
                    if info == "all" or info == "fuelprice" then
                        StationFuelPrice = v.fuelprice
                    end
                    -- Fuel Station's Balance --
                    if info == "all" or info == "balance" then
                        StationBalance = v.balance
                        if Config.FuelDebug then print("Successfully Fetched: Balance") end 
                    end
                    ----------------
                end
            end
        end, CurrentLocation)
    end exports(UpdateStationInfo, UpdateStationInfo) 

    local function SpawnGasStationPeds()
        if not Config.GasStations or not next(Config.GasStations) or PedsSpawned then return end
        for i = 1, #Config.GasStations do
            local current = Config.GasStations[i]
            current.pedmodel = type(current.pedmodel) == 'string' and GetHashKey(current.pedmodel) or current.pedmodel
            RequestModel(current.pedmodel)
            while not HasModelLoaded(current.pedmodel) do
                Wait(0)
            end
            local ped = CreatePed(0, current.pedmodel, current.pedcoords.x, current.pedcoords.y, current.pedcoords.z, current.pedcoords.h, false, false)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            exports['qb-target']:AddTargetEntity(ped, {
                options = {
                    {
                        type = "client",
                        label = "Discuss Gas Station",
                        icon = "fas fa-building",
                        action = function()
                            TriggerEvent('cdn-fuel:stations:openmenu', CurrentLocation)
                        end,
                    },
                },
                distance = 2.0
            })
        end
        PedsSpawned = true
    end

    -- Events 
    RegisterNetEvent('cdn-fuel:stations:updatelocation', function(updatedlocation)
        if Config.FuelDebug then if CurrentLocation == nil then CurrentLocation = 0 end print('Location: '..CurrentLocation..' has been replaced with a new location: ' ..updatedlocation) end
        CurrentLocation = updatedlocation
    end)

    RegisterNetEvent('cdn-fuel:stations:client:buyreserves', function(data)
        local location = data.location
        local price = data.price
        local amount = data.amount
        TriggerServerEvent('cdn-fuel:stations:server:buyreserves', location, price, amount)
        if Config.FuelDebug then print("^5Attempting Purchase of ^2"..amount.. "^5 Fuel Reserves for location #"..location.."! Purchase Price: ^2"..price) end
    end)

    RegisterNetEvent('cdn-fuel:stations:client:purchaselocation', function(data)
        local location = data.location
        local CitizenID = QBCore.Functions.GetPlayerData().citizenid
        CanOpen = false
        Wait(5)
        QBCore.Functions.TriggerCallback('cdn-fuel:server:locationpurchased', function(result)
            if result then
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is owned!") end
                IsOwned = true
            else
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is not owned.") end
                IsOwned = false
            end
        end, CurrentLocation)
        Wait(100)
        if not IsOwned then
            TriggerServerEvent('cdn-fuel:server:buyStation', location, CitizenID)
        elseif IsOwned then 
            QBCore.Functions.Notify('This location is!', 'error', 7500)
        end
    end)

    RegisterNetEvent('cdn-fuel:stations:client:sellstation', function(data)
        local location = data.location
        local SalePrice = data.SalePrice
        local CitizenID = QBCore.Functions.GetPlayerData().citizenid
        CanSell = false
        Wait(5)
        QBCore.Functions.TriggerCallback('cdn-fuel:server:isowner', function(result)
            if result then
                if Config.FuelDebug then print("The Location: "..location.." is owned by ID: "..CitizenID) end
                CanSell = true
            else
                QBCore.Functions.Notify('You do not own this location or work here!', 'error', 7500)
                if Config.FuelDebug then print("The Location: "..location.." is not owned by ID: "..CitizenID) end
                CanSell = false
            end
        end, location)
        Wait(100)
        if CanSell then
            if Config.FuelDebug then print("Attempting to sell for: $"..SalePrice) end
            TriggerServerEvent('cdn-fuel:stations:server:sellstation', location)
            if Config.FuelDebug then print("Event Triggered") end
        else
            QBCore.Functions.Notify('You cannot sell this location!', 'error', 7500)
        end
    end)

    RegisterNetEvent('cdn-fuel:stations:client:purchasereserves:final', function(location, price, amount) -- Menu, seens after selecting the "purchase reserves" option.
        local location = location
        local price = price
        local amount = amount
        CanOpen = false
        Wait(5)
        if Config.FuelDebug then print("checking ownership of "..location) end
        QBCore.Functions.TriggerCallback('cdn-fuel:server:isowner', function(result)
            local CitizenID = QBCore.Functions.GetPlayerData().citizenid
            if result then
                if Config.FuelDebug then print("The Location: "..location.." is owned by ID: "..CitizenID) end
                CanOpen = true
            else
                QBCore.Functions.Notify('You do not own this location or work here!', 'error', 7500)
                if Config.FuelDebug then print("The Location: "..location.." is not owned by ID: "..CitizenID) end
                CanOpen = false
            end
        end, location)
        Wait(100)
        if CanOpen then
            if Config.FuelDebug then print("Price: "..price.."<br> Amount: "..amount.." <br> Location: "..location) end
            exports['qb-menu']:openMenu({
                {
                    header = "Buy Reserves for "..Config.GasStations[location].label,
                    isMenuHeader = true,
                    icon = "fas fa-gas-pump",
                },
                {
                    header = "Buy reserves for: $"..price,
                    txt = "Yes I want to buy fuel reserves for $"..price.."!", 
                    icon = "fas fa-usd",
                    params = {
                        event = "cdn-fuel:stations:client:buyreserves",
                        args = {
                            location = location,
                            price = price, 
                            amount = amount, 
                        },
                    },
                },
                {
                    header = "Cancel",
                    txt = "I actually don't want to buy more reserves!", 
                    icon = "fas fa-times-circle",
                },
            })
        else
            if Config.FuelDebug then print("Not showing menu, as the player doesn't have proper permissions.") end
        end
    end)

    RegisterNetEvent('cdn-fuel:stations:client:purchasereserves', function(data)
        CanOpen = false
        local location = data.location
        QBCore.Functions.TriggerCallback('cdn-fuel:server:isowner', function(result)
            local CitizenID = QBCore.Functions.GetPlayerData().citizenid
            if result then
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is owned by ID: "..CitizenID) end
                CanOpen = true
            else
                QBCore.Functions.Notify('You do not own this location or work here!', 'error', 7500)
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is not owned by ID: "..CitizenID) end
                CanOpen = false
            end
        end, location)
        Wait(100)
        if CanOpen then
            local bankmoney = QBCore.Functions.GetPlayerData().money['bank']
            if Config.FuelDebug then print("Showing Input for Reserves!") end
            local reserves = exports['qb-input']:ShowInput({
                header = "Purchase Reserves<br>Current Price: $" ..
                Config.FuelReservesPrice .. " / Liter <br> Current Reserves: " .. Currentreserveamount .. " Liters <br> Full Reserve Cost: $" ..
                GlobalTax((Config.MaxFuelReserves - Currentreserveamount) * Config.FuelReservesPrice) + ((Config.MaxFuelReserves - Currentreserveamount) * Config.FuelReservesPrice) .. "",
                submitText = "Buy Reserves",
                inputs = { {
                    type = 'number',
                    isRequired = true,
                    name = 'amount',
                    text = 'Purchase Fuel Reserves.'
                }}
            })
            if reserves then
                if Config.FuelDebug then print("Attempting to buy reserves!") end
                Wait(100)
                local amount = reserves.amount
                if not reserves.amount then QBCore.Functions.Notify('Invalid Amount', 'error', 7500) return end
                Reservebuyamount = tonumber(reserves.amount)
                if Reservebuyamount < 1 then QBCore.Functions.Notify('You cannot buy less than 1 Liter!', 'error', 7500) return end
                if (Reservebuyamount + Currentreserveamount) > Config.MaxFuelReserves then
                    QBCore.Functions.Notify("The reserve cannot fit this!", "error")
                else
                    if GlobalTax(Reservebuyamount * Config.FuelReservesPrice) + (Reservebuyamount * Config.FuelReservesPrice) <= bankmoney then
                        local price = GlobalTax(Reservebuyamount * Config.FuelReservesPrice) + (Reservebuyamount * Config.FuelReservesPrice)
                        if Config.FuelDebug then print("Price: "..price) end
                        TriggerEvent("cdn-fuel:stations:client:purchasereserves:final", location, price, amount)
                        
                    else
                        QBCore.Functions.Notify("You can't afford this!", 'error', 7500)
                    end
                end    
            end
        end
    end)

    RegisterNetEvent('cdn-fuel:stations:client:changefuelprice', function(data) 
        CanOpen = false
        local location = data.location
        QBCore.Functions.TriggerCallback('cdn-fuel:server:isowner', function(result)
            local CitizenID = QBCore.Functions.GetPlayerData().citizenid
            if result then
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is owned by ID: "..CitizenID) end
                CanOpen = true
            else
                QBCore.Functions.Notify('You do not own this location or work here!', 'error', 7500)
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is not owned by ID: "..CitizenID) end
                CanOpen = false
            end
        end, location)
        Wait(100)
        if CanOpen then
            if Config.FuelDebug then print("Showing Input for Fuel Price Change!") end
            local fuelprice = exports['qb-input']:ShowInput({
                header = "Alter Fuel Price <br>Current Price: $"..StationFuelPrice.." / Liter",
                submitText = "Change Fuel Price",
                inputs = { {
                    type = 'number',
                    isRequired = true,
                    name = 'price',
                    text = 'Change Price'
                }}
            })
            if fuelprice then
                if Config.FuelDebug then print("Attempting to change fuel price!") end
                Wait(100)
                if not fuelprice.price then QBCore.Functions.Notify('Invalid Amount', 'error', 7500) return end
                NewFuelPrice = tonumber(fuelprice.price)
                if NewFuelPrice < Config.MinimumFuelPrice then QBCore.Functions.Notify('You cannot make your price this low!', 'error', 7500) return end
                if NewFuelPrice > Config.MaxFuelPrice then
                    QBCore.Functions.Notify("This price is too much!", "error")
                else
                    TriggerServerEvent("cdn-fuel:station:server:updatefuelprice", NewFuelPrice, CurrentLocation)
                end    
            end
        end
    end)

    RegisterNetEvent('cdn-fuel:stations:client:sellstation:menu', function(data) -- Menu, seen after selecting the Sell this Location option.
        local location = data.location
        local CitizenID = QBCore.Functions.GetPlayerData().citizenid
        QBCore.Functions.TriggerCallback('cdn-fuel:server:isowner', function(result)
            if result then
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is owned by ID: "..CitizenID) end
                CanOpen = true
            else
                QBCore.Functions.Notify('You do not own this location or work here!', 'error', 7500)
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is not owned by ID: "..CitizenID) end
                CanOpen = false
            end
        end, CurrentLocation)
        Wait(100)
        if CanOpen then
            local GasStationCost = Config.GasStations[location].cost + GlobalTax(Config.GasStations[location].cost)
            local SalePrice = math.percent(Config.GasStationSellPercentage, GasStationCost)
            exports['qb-menu']:openMenu({
                {
                    header = "Sell "..Config.GasStations[location].label,
                    isMenuHeader = true,
                    icon = "fas fa-gas-pump",
                },
                {
                    header = "Sell Gas Station",
                    txt = "Yes, I want to sell this location for $"..SalePrice.."?", 
                    icon = "fas fa-usd",
                    params = {
                        event = "cdn-fuel:stations:client:sellstation",
                        args = {
                            location = location,
                            SalePrice = SalePrice,
                        }
                    },
                },
                {
                    header = "Cancel",
                    txt = "I actually don't have anything more to discuss.", 
                    icon = "fas fa-times-circle",
                },
            })
            TriggerServerEvent("cdn-fuel:stations:server:stationsold", location)
        end
    end)

    RegisterNetEvent('cdn-fuel:stations:client:changestationname', function() -- Menu for changing the label of the owned station.
        CanOpen = false
        QBCore.Functions.TriggerCallback('cdn-fuel:server:isowner', function(result)
            local CitizenID = QBCore.Functions.GetPlayerData().citizenid
            if result then
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is owned by ID: "..CitizenID) end
                CanOpen = true
            else
                QBCore.Functions.Notify('You do not own this location or work here!', 'error', 7500)
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is not owned by ID: "..CitizenID) end
                CanOpen = false
            end
        end, CurrentLocation)
        Wait(100)
        if CanOpen then
            if Config.FuelDebug then print("Showing Input for name Change!") end
            local NewName = exports['qb-input']:ShowInput({
                header = "Change "..Config.GasStations[CurrentLocation].label.."'s Name.",
                submitText = "Submit Name Change",
                inputs = { {
                    type = 'text',
                    isRequired = true,
                    name = 'newname',
                    text = 'New Name..'
                }}
            })
            if NewName then
                if Config.FuelDebug then print("Attempting to alter stations name!") end
                if not NewName.newname then QBCore.Functions.Notify('Invalid Name.', 'error', 7500) return end
                NewName = NewName.newname
                if type(NewName) ~= "string" then QBCore.Functions.Notify('Name invalid.', 'error') return end
                if Config.ProfanityList[NewName] then QBCore.Functions.Notify(NewName..' is prohibited. Try another name.', 'error', 7500) 
                    -- You can add logs for people that put prohibited words into the name changer if wanted, and here is where you would do it.
                    return 
                end
                if string.len(NewName) > Config.NameChangeMaxChar then QBCore.Functions.Notify('Name cannot be longer than '..Config.NameChangeMaxChar..' characters.', 'error') return end
                if string.len(NewName) < Config.NameChangeMinChar then QBCore.Functions.Notify('Name must be longer than '..Config.NameChangeMinChar..' characters.', 'error') return end
                Wait(100)
                TriggerServerEvent("cdn-fuel:station:server:updatelocationname", NewName, CurrentLocation) 
            end
        end
    end)

    RegisterNetEvent('cdn-fuel:stations:client:managemenu', function(location) -- Menu, seen after selecting the Manage this Location Option.
        location = CurrentLocation
        QBCore.Functions.TriggerCallback('cdn-fuel:server:isowner', function(result)
            local CitizenID = QBCore.Functions.GetPlayerData().citizenid
            if result then
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is owned by ID: "..CitizenID) end
                CanOpen = true
            else
                QBCore.Functions.Notify('You do not own this location or work here!', 'error', 7500)
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is not owned by ID: "..CitizenID) end
                CanOpen = false
            end
        end, CurrentLocation)
        UpdateStationInfo("all")
        if Config.PlayerControlledFuelPrices then CanNotChangeFuelPrice = false else CanNotChangeFuelPrice = true end
        Wait(5)
        Wait(100)
        if CanOpen then
            local GasStationCost = (Config.GasStations[location].cost + GlobalTax(Config.GasStations[location].cost))
            exports['qb-menu']:openMenu({
                {
                    header = "Management of "..Config.GasStations[location].label,
                    isMenuHeader = true,
                    icon = "fas fa-gas-pump",
                },
                {
                    header = "Fuel Reserves <br> ",
                    icon = "fas fa-info-circle",
                    isMenuHeader = true,
                    txt = ""..ReserveLevels.." Liters out of "..Config.MaxFuelReserves.." Liters <br> You can purchase more reserves below!",
                },
                {
                    header = "Purchase More Fuel for Reserves",
                    icon = "fas fa-usd",
                    txt = 'I want to purchase more fuel reserves for $'..Config.FuelReservesPrice..' / L!' ,
                    params = {
                        event = "cdn-fuel:stations:client:purchasereserves",
                        args = {
                            location = location, 
                        }
                    },
                    disabled = ReservesNotBuyable,
                },
                {
                    header = "Alter Fuel Price",
                    icon = "fas fa-usd",
                    txt = "I want to change the price of fuel at my Gas Station! <br> Currently, it is $"..StationFuelPrice.." / Liter" ,
                    params = {
                        event = "cdn-fuel:stations:client:changefuelprice",
                        args = {
                            location = location, 
                        }
                    },
                    disabled = CanNotChangeFuelPrice,
                },
                {
                    header = "Manage Company Funds",
                    icon = "fas fa-usd",
                    txt = "I want to manage this locations funds." ,
                    params = {
                        event = "cdn-fuel:stations:client:managefunds",
                    },
                },
                {
                    header = "Change Location Name",
                    icon = "fas fa-pen",
                    txt = "I want to change the location name." ,
                    disabled = not Config.GasStationNameChanges,
                    params = {
                        event = "cdn-fuel:stations:client:changestationname",
                    },
                },
                {
                    header = "Sell Gas Station",
                    txt = "Sell your gas station for $"..math.percent(Config.GasStationSellPercentage, GasStationCost), 
                    icon = "fas fa-usd",
                    params = {
                        event = "cdn-fuel:stations:client:sellstation:menu",
                        args = {
                            location = location, 
                        }
                    },
                },
                {
                    header = "Cancel",
                    txt = "I actually don't have anything more to discuss!", 
                    icon = "fas fa-times-circle",
                },
            })
        end
    end)

    RegisterNetEvent('cdn-fuel:stations:client:managefunds', function(location) -- Menu, seen after selecting the Manage this Location Option.
        QBCore.Functions.TriggerCallback('cdn-fuel:server:isowner', function(result)
            local CitizenID = QBCore.Functions.GetPlayerData().citizenid
            if result then
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is owned by ID: "..CitizenID) end
                CanOpen = true
            else
                QBCore.Functions.Notify('You do not own this location or work here!', 'error', 7500)
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is not owned by ID: "..CitizenID) end
                CanOpen = false
            end
        end, CurrentLocation)
        UpdateStationInfo("all")
        Wait(5)
        Wait(100)
        if CanOpen then
            exports['qb-menu']:openMenu({
                {
                    header = "Funds Management of "..Config.GasStations[CurrentLocation].label,
                    isMenuHeader = true,
                    icon = "fas fa-gas-pump",
                },
                {
                    header = "Withdraw Funds",
                    icon = "fas fa-arrow-left",
                    txt = "Withdraw funds from the Station's account.",
                    params = {
                        event = "cdn-fuel:stations:client:WithdrawFunds",
                        args = {
                            location = location, 
                        }
                    },
                },
                {
                    header = "Deposit Funds",
                    icon = "fas fa-arrow-right",
                    txt = "Deposit funds to the Station's account.",
                    params = {
                        event = "cdn-fuel:stations:client:DepositFunds",
                        args = {
                            location = location, 
                        }
                    },
                },
                {
                    header = "Return",
                    txt = "I want to discuss something else!", 
                    icon = "fas fa-circle-left",
                    params = {
                        event = "cdn-fuel:stations:client:managemenu",
                        args = {
                            location = location, 
                        }
                    },
                },
            })
        end
    end)

    RegisterNetEvent('cdn-fuel:stations:client:WithdrawFunds', function(data)
        if Config.FuelDebug then print("Triggered Event for: Withdraw!") end
        CanOpen = false
        local location = CurrentLocation
        QBCore.Functions.TriggerCallback('cdn-fuel:server:isowner', function(result)
            local CitizenID = QBCore.Functions.GetPlayerData().citizenid
            if result then
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is owned by ID: "..CitizenID) end
                CanOpen = true
            else
                QBCore.Functions.Notify('You do not own this location or work here!', 'error', 7500)
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is not owned by ID: "..CitizenID) end
                CanOpen = false
            end
        end, CurrentLocation)
        Wait(100)
        if CanOpen then
            if Config.FuelDebug then print("Showing Input for Withdraw!") end
            UpdateStationInfo("balance")
            Wait(50)
            local Withdraw = exports['qb-input']:ShowInput({
                header = "Withdraw Funds<br>Current Balance: $" ..StationBalance,
                submitText = "Withdraw",
                inputs = { {
                    type = 'number',
                    isRequired = true,
                    name = 'amount',
                    text = 'Withdraw Funds.'
                }}
            })
            if Withdraw then
                if Config.FuelDebug then print("Attempting to Withdraw!") end
                Wait(100)
                local amount = tonumber(Withdraw.amount)
                if not Withdraw.amount then QBCore.Functions.Notify('Invalid Amount', 'error', 7500) return end
                if amount < 1 then QBCore.Functions.Notify('You cannot withdraw less than 1!', 'error', 7500) return end
                if amount > StationBalance then QBCore.Functions.Notify('You cannot withdraw more than the station has!', 'error', 7500) return end
                WithdrawAmount = tonumber(amount)
                if (StationBalance - WithdrawAmount) < 0 then
                    QBCore.Functions.Notify('You cannot withdraw more than the station has!', 'error', 7500)
                else
                    TriggerServerEvent('cdn-fuel:station:server:Withdraw', amount, location, StationBalance)
                end    
            end
        end
    end)

    RegisterNetEvent('cdn-fuel:stations:client:DepositFunds', function(data)
        if Config.FuelDebug then print("Triggered Event for: Deposit!") end
        CanOpen = false
        local location = CurrentLocation
        QBCore.Functions.TriggerCallback('cdn-fuel:server:isowner', function(result)
            local CitizenID = QBCore.Functions.GetPlayerData().citizenid
            if result then
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is owned by ID: "..CitizenID) end
                CanOpen = true
            else
                QBCore.Functions.Notify('You do not own this location or work here!', 'error', 7500)
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is not owned by ID: "..CitizenID) end
                CanOpen = false
            end
        end, CurrentLocation)
        Wait(100)
        if CanOpen then
            local bankmoney = QBCore.Functions.GetPlayerData().money['bank']
            if Config.FuelDebug then print("Showing Input for Deposit!") end
            UpdateStationInfo("balance")
            Wait(50)
            local Deposit = exports['qb-input']:ShowInput({
                header = "Deposit Funds<br>Current Balance: $" ..StationBalance,
                submitText = "Deposit",
                inputs = { {
                    type = 'number',
                    isRequired = true,
                    name = 'amount',
                    text = 'Deposit Funds.'
                }}
            })
            if Deposit then
                if Config.FuelDebug then print("Attempting to Deposit!") end
                Wait(100)
                local amount = tonumber(Deposit.amount)
                if not Deposit.amount then QBCore.Functions.Notify('Invalid Amount', 'error', 7500) return end
                if amount < 1 then QBCore.Functions.Notify('You cannot deposit less than 1!', 'error', 7500) return end
                DepositAmount = tonumber(amount)
                if (DepositAmount) > bankmoney then
                    QBCore.Functions.Notify("You cannot deposit more than you have!", "error")
                else
                    TriggerServerEvent('cdn-fuel:station:server:Deposit', amount, location, StationBalance)
                end    
            end
        end
    end)

    RegisterNetEvent('cdn-fuel:stations:client:Shutoff', function(location)
        TriggerServerEvent("cdn-fuel:stations:server:Shutoff", location)
    end)

    RegisterNetEvent('cdn-fuel:stations:client:purchasemenu', function(location) -- Menu, seen after selecting the purchase this location option.
        local bankmoney = QBCore.Functions.GetPlayerData().money['bank']
        local costofstation = Config.GasStations[location].cost + GlobalTax(Config.GasStations[location].cost)
        if bankmoney < costofstation then
            QBCore.Functions.Notify('You are a broke loser! You cannot afford this!', 'error', 7500) return
        end

        exports['qb-menu']:openMenu({
            {
                header = Config.GasStations[location].label,
                isMenuHeader = true,
                icon = "fas fa-gas-pump",
            },
            {
                header = "",
                icon = "fas fa-info-circle",
                isMenuHeader = true,
                txt = 'The total cost is going to be: $'..costofstation..' including taxes.' ,
            },
            {
                header = "Confirm",
                icon = "fas fa-check-circle",
                txt = 'I want to purchase this location for $'..costofstation..'!' ,
                params = {
                    event = "cdn-fuel:stations:client:purchaselocation",
                    args = {
                        location = location, 
                    }
                }
            },
            {
                header = "Cancel",
                txt = "I actually don't want to buy this location anymore. That price is bonkers!", 
                icon = "fas fa-times-circle",
            },
        })
    end)

    RegisterNetEvent('cdn-fuel:client:updatestationlabels', function(location, newLabel)
        if not location then if Config.FuelDebug then print('location is nil') end return end
        if not newLabel then if Config.FuelDebug then print('newLabel is nil') end return end
        if Config.FuelDebug then print("Changing Label for Location #"..location..' to '..newLabel) end
        Config.GasStations[location].label = newLabel
    end)

    RegisterNetEvent('cdn-fuel:stations:openmenu', function() -- Menu #1, the first menu you see.
        DisablePurchase = true
        DisableOwnerMenu = true
        ShutOffDisabled = false

        QBCore.Functions.TriggerCallback('cdn-fuel:server:locationpurchased', function(result)
            if result then
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is owned.") end
                DisablePurchase = true
            else
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is not owned.") end
                DisablePurchase = false
                DisableOwnerMenu = true
            end
        end, CurrentLocation)

        QBCore.Functions.TriggerCallback('cdn-fuel:server:isowner', function(result)
            local CitizenID = QBCore.Functions.GetPlayerData().citizenid
            if result then
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is owned by ID: "..CitizenID) end
                DisableOwnerMenu = false
            else
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is not owned by ID: "..CitizenID) end
                DisableOwnerMenu = true
            end
        end, CurrentLocation)

        if Config.EmergencyShutOff then
            QBCore.Functions.TriggerCallback('cdn-fuel:server:checkshutoff', function(result)
                if result == true then
                    PumpState = "disabled."
                elseif result == false then
                    PumpState = "enabled."
                else
                    PumpState = "nil"
                end

                if Config.FuelDebug then print("The result from Callback: Config.GasStations["..CurrentLocation.."].shutoff = "..PumpState) end
            end, CurrentLocation)
        else
            PumpState = "enabled."
            ShutOffDisabled = true
        end

        Wait(100)
        exports['qb-menu']:openMenu({
            {
                header = Config.GasStations[CurrentLocation].label,
                isMenuHeader = true,
                icon = "fas fa-gas-pump", 
            },
            {
                header = "Manage This Location",
                txt = "If you are the owner, you can manage this location.",
                icon = "fas fa-usd",
                params = {
                    event = "cdn-fuel:stations:client:managemenu",
                    args = CurrentLocation,
                },
                disabled = DisableOwnerMenu,
            },
            {
                header = "Purchase This Location",
                txt = "If no one owns this location, you can purchase it.",
                icon = "fas fa-usd",
                params = {
                    event = "cdn-fuel:stations:client:purchasemenu",
                    args = CurrentLocation,
                },
                disabled = DisablePurchase,
            },
            {
                header = "Toggle Emergency Shutoff",
                txt = "Shut off the fuel in case of an emergency. <br> The pumps are currently "..PumpState,
                icon = "fas fa-gas-pump",
                params = {
                    event = "cdn-fuel:stations:client:Shutoff",
                    args = CurrentLocation,
                },
                disabled = ShutOffDisabled,
            },
            {
                header = "Cancel Conversation",
                txt = "I actually don't want to discuss anything anymore.",
                icon = "fas fa-times-circle",
            },
        })
    end)

    -- Threads
    CreateThread(function() -- Spawn the Peds for Gas Stations when the resource starts.
        SpawnGasStationPeds()
    end)

end -- For Config.PlayerOwnedGasStationsEnabled check, don't remove!