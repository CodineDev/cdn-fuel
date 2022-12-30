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
                        label = Lang:t("station_talk_to_ped"),
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
            QBCore.Functions.Notify(Lang:t("station_already_owned"), 'error', 7500)
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
                QBCore.Functions.Notify(Lang:t("station_not_owner"), 'error', 7500)
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
            QBCore.Functions.Notify(Lang:t("station_cannot_sell"), 'error', 7500)
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
                QBCore.Functions.Notify(Lang:t("station_not_owner"), 'error', 7500)
                if Config.FuelDebug then print("The Location: "..location.." is not owned by ID: "..CitizenID) end
                CanOpen = false
            end
        end, location)
        Wait(100)
        if CanOpen then
            if Config.FuelDebug then print("Price: "..price.."<br> Amount: "..amount.." <br> Location: "..location) end
            exports['qb-menu']:openMenu({
                {
                    header = Lang:t("menu_station_reserves_header")..Config.GasStations[location].label,
                    isMenuHeader = true,
                    icon = "fas fa-gas-pump",
                },
                {
                    header = Lang:t("menu_station_reserves_purchase_header")..price,
                    txt = Lang:t("menu_station_reserves_purchase_footer")..price.."!", 
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
                    header = Lang:t("menu_header_close"),
                    txt = Lang:t("menu_station_reserves_cancel_footer"), 
                    icon = "fas fa-times-circle",
                    params = {
                        event = "qb-menu:closeMenu",
                    }
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
                QBCore.Functions.Notify(Lang:t("station_not_owner"), 'error', 7500)
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is not owned by ID: "..CitizenID) end
                CanOpen = false
            end
        end, location)
        Wait(100)
        if CanOpen then
            local bankmoney = QBCore.Functions.GetPlayerData().money['bank']
            if Config.FuelDebug then print("Showing Input for Reserves!") end
            local reserves = exports['qb-input']:ShowInput({
                header = Lang:t("input_purchase_reserves_header_1") .. Lang:t("input_purchase_reserves_header_2") .. Currentreserveamount .. Lang:t("input_purchase_reserves_header_3") ..
                GlobalTax((Config.MaxFuelReserves - Currentreserveamount) * Config.FuelReservesPrice) + ((Config.MaxFuelReserves - Currentreserveamount) * Config.FuelReservesPrice) .. "",
                submitText = Lang:t("input_purchase_reserves_submit_text"),
                inputs = { {
                    type = 'number',
                    isRequired = true,
                    name = 'amount',
                    text = Lang:t("input_purchase_reserves_text")
                }}
            })
            if reserves then
                if Config.FuelDebug then print("Attempting to buy reserves!") end
                Wait(100)
                local amount = reserves.amount
                if not reserves.amount then QBCore.Functions.Notify(Lang:t("station_amount_invalid"), 'error', 7500) return end
                Reservebuyamount = tonumber(reserves.amount)
                if Reservebuyamount < 1 then QBCore.Functions.Notify(Lang:t("station_more_than_one"), 'error', 7500) return end
                if (Reservebuyamount + Currentreserveamount) > Config.MaxFuelReserves then
                    QBCore.Functions.Notify(Lang:t("station_reserve_cannot_fit"), "error")
                else
                    if GlobalTax(Reservebuyamount * Config.FuelReservesPrice) + (Reservebuyamount * Config.FuelReservesPrice) <= bankmoney then
                        local price = GlobalTax(Reservebuyamount * Config.FuelReservesPrice) + (Reservebuyamount * Config.FuelReservesPrice)
                        if Config.FuelDebug then print("Price: "..price) end
                        TriggerEvent("cdn-fuel:stations:client:purchasereserves:final", location, price, amount)
                        
                    else
                        QBCore.Functions.Notify(Lang:t("not_enough_money_in_bank"), 'error', 7500)
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
                QBCore.Functions.Notify(Lang:t("station_not_owner"), 'error', 7500)
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is not owned by ID: "..CitizenID) end
                CanOpen = false
            end
        end, location)
        Wait(100)
        if CanOpen then
            if Config.FuelDebug then print("Showing Input for Fuel Price Change!") end
            local fuelprice = exports['qb-input']:ShowInput({
                header = Lang:t("input_alter_fuel_price_header_1")..StationFuelPrice..Lang:t("input_alter_fuel_price_header_2"),
                submitText = Lang:t("input_alter_fuel_price_submit_text"),
                inputs = { {
                    type = 'number',
                    isRequired = true,
                    name = 'price',
                    text = Lang:t("input_alter_fuel_price_submit_text")
                }}
            })
            if fuelprice then
                if Config.FuelDebug then print("Attempting to change fuel price!") end
                Wait(100)
                if not fuelprice.price then QBCore.Functions.Notify(Lang:t("station_amount_invalid"), 'error', 7500) return end
                NewFuelPrice = tonumber(fuelprice.price)
                if NewFuelPrice < Config.MinimumFuelPrice then QBCore.Functions.Notify(Lang:t("station_price_too_low"), 'error', 7500) return end
                if NewFuelPrice > Config.MaxFuelPrice then
                    QBCore.Functions.Notify(Lang:t("station_price_too_high"), "error")
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
                QBCore.Functions.Notify(Lang:t("station_not_owner"), 'error', 7500)
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
                    header = Lang:t("menu_sell_station_header")..Config.GasStations[location].label,
                    isMenuHeader = true,
                    icon = "fas fa-gas-pump",
                },
                {
                    header = Lang:t("menu_sell_station_header_accept"),
                    txt = Lang:t("menu_sell_station_footer_accept")..SalePrice..".", 
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
                    header = Lang:t("menu_header_close"),
                    txt = Lang:t("menu_sell_station_footer_close"), 
                    icon = "fas fa-times-circle",
                    params = {
                        event = "qb-menu:closeMenu",
                    }
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
                QBCore.Functions.Notify(Lang:t("station_not_owner"), 'error', 7500)
                if Config.FuelDebug then print("The Location: "..CurrentLocation.." is not owned by ID: "..CitizenID) end
                CanOpen = false
            end
        end, CurrentLocation)
        Wait(100)
        if CanOpen then
            if Config.FuelDebug then print("Showing Input for name Change!") end
            local NewName = exports['qb-input']:ShowInput({
                header = Lang:t("input_change_name_header_1")..Config.GasStations[CurrentLocation].label..Lang:t("input_change_name_header_2"),
                submitText = Lang:t("input_change_name_submit_text"),
                inputs = { {
                    type = 'text',
                    isRequired = true,
                    name = 'newname',
                    text = Lang:t("input_change_name_text")
                }}
            })
            if NewName then
                if Config.FuelDebug then print("Attempting to alter stations name!") end
                if not NewName.newname then QBCore.Functions.Notify(Lang:t("station_name_invalid"), 'error', 7500) return end
                NewName = NewName.newname
                if type(NewName) ~= "string" then QBCore.Functions.Notify(Lang:t("station_name_invalid"), 'error') return end
                if Config.ProfanityList[NewName] then QBCore.Functions.Notify(Lang:t("station_name_invalid"), 'error', 7500) 
                    -- You can add logs for people that put prohibited words into the name changer if wanted, and here is where you would do it.
                    return 
                end
                if string.len(NewName) > Config.NameChangeMaxChar then QBCore.Functions.Notify(Lang:t("station_name_too_long"), 'error') return end
                if string.len(NewName) < Config.NameChangeMinChar then QBCore.Functions.Notify(Lang:t("station_name_too_short"), 'error') return end
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
                QBCore.Functions.Notify(Lang:t("station_not_owner"), 'error', 7500)
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
                    header = Lang:t("menu_manage_header")..Config.GasStations[location].label,
                    isMenuHeader = true,
                    icon = "fas fa-gas-pump",
                },
                {
                    header = Lang:t("menu_manage_reserves_header"),
                    icon = "fas fa-info-circle",
                    isMenuHeader = true,
                    txt = ReserveLevels..Lang:t("menu_manage_reserves_footer_1")..Config.MaxFuelReserves..Lang:t("menu_manage_reserves_footer_2"),
                },
                {
                    header = Lang:t("menu_manage_purchase_reserves_header"),
                    icon = "fas fa-usd",
                    txt = Lang:t("menu_manage_purchase_reserves_footer")..Config.FuelReservesPrice..Lang:t("menu_manage_purchase_reserves_footer_2") ,
                    params = {
                        event = "cdn-fuel:stations:client:purchasereserves",
                        args = {
                            location = location, 
                        }
                    },
                    disabled = ReservesNotBuyable,
                },
                {
                    header = Lang:t("menu_alter_fuel_price_header"),
                    icon = "fas fa-usd",
                    txt = "I want to change the price of fuel at my Gas Station! <br> Currently, it is $"..StationFuelPrice..Lang:t("input_alter_fuel_price_header_2") ,
                    params = {
                        event = "cdn-fuel:stations:client:changefuelprice",
                        args = {
                            location = location, 
                        }
                    },
                    disabled = CanNotChangeFuelPrice,
                },
                {
                    header = Lang:t("menu_manage_company_funds_header"),
                    icon = "fas fa-usd",
                    txt = Lang:t("menu_manage_company_funds_footer"),
                    params = {
                        event = "cdn-fuel:stations:client:managefunds",
                    },
                },
                {
                    header = Lang:t("menu_manage_change_name_header"),
                    icon = "fas fa-pen",
                    txt = Lang:t("menu_manage_change_name_footer"),
                    disabled = not Config.GasStationNameChanges,
                    params = {
                        event = "cdn-fuel:stations:client:changestationname",
                    },
                },
                {
                    header = Lang:t("menu_sell_station_header_accept"),
                    txt = Lang:t("menu_manage_sell_station_footer")..math.percent(Config.GasStationSellPercentage, GasStationCost), 
                    icon = "fas fa-usd",
                    params = {
                        event = "cdn-fuel:stations:client:sellstation:menu",
                        args = {
                            location = location, 
                        }
                    },
                },
                {
                    header = Lang:t("menu_header_close"),
                    txt = Lang:t("menu_manage_close"), 
                    icon = "fas fa-times-circle",
                    params = {
                        event = "qb-menu:closeMenu",
                    }
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
                QBCore.Functions.Notify(Lang:t("station_not_owner"), 'error', 7500)
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
                    header = Lang:t("menu_manage_company_funds_header_2")..Config.GasStations[CurrentLocation].label,
                    isMenuHeader = true,
                    icon = "fas fa-gas-pump",
                },
                {
                    header = Lang:t("menu_manage_company_funds_withdraw_header"),
                    icon = "fas fa-arrow-left",
                    txt = Lang:t("menu_manage_company_funds_withdraw_footer"),
                    params = {
                        event = "cdn-fuel:stations:client:WithdrawFunds",
                        args = {
                            location = location, 
                        }
                    },
                },
                {
                    header = Lang:t("menu_manage_company_funds_deposit_header"),
                    icon = "fas fa-arrow-right",
                    txt = Lang:t("menu_manage_company_funds_deposit_footer"),
                    params = {
                        event = "cdn-fuel:stations:client:DepositFunds",
                        args = {
                            location = location, 
                        }
                    },
                },
                {
                    header = Lang:t("menu_manage_company_funds_return_header"),
                    txt = Lang:t("menu_manage_company_funds_return_footer"), 
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
                QBCore.Functions.Notify(Lang:t("station_not_owner"), 'error', 7500)
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
                header = Lang:t("input_withdraw_funds_header") ..StationBalance,
                submitText = Lang:t("input_withdraw_submit_text"),
                inputs = { {
                    type = 'number',
                    isRequired = true,
                    name = 'amount',
                    text = Lang:t("input_withdraw_text")
                }}
            })
            if Withdraw then
                if Config.FuelDebug then print("Attempting to Withdraw!") end
                Wait(100)
                local amount = tonumber(Withdraw.amount)
                if not Withdraw.amount then QBCore.Functions.Notify(Lang:t("station_amount_invalid"), 'error', 7500) return end
                if amount < 1 then QBCore.Functions.Notify(Lang:t("station_withdraw_too_little"), 'error', 7500) return end
                if amount > StationBalance then QBCore.Functions.Notify(Lang:t("station_withdraw_too_much"), 'error', 7500) return end
                WithdrawAmount = tonumber(amount)
                if (StationBalance - WithdrawAmount) < 0 then
                    QBCore.Functions.Notify(Lang:t("station_withdraw_too_much"), 'error', 7500)
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
                QBCore.Functions.Notify(Lang:t("station_not_owner"), 'error', 7500)
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
                header = Lang:t("input_deposit_funds_header") ..StationBalance,
                submitText = Lang:t("input_deposit_submit_text"),
                inputs = { {
                    type = 'number',
                    isRequired = true,
                    name = 'amount',
                    text = Lang:t("input_deposit_text")
                }}
            })
            if Deposit then
                if Config.FuelDebug then print("Attempting to Deposit!") end
                Wait(100)
                local amount = tonumber(Deposit.amount)
                if not Deposit.amount then QBCore.Functions.Notify(Lang:t("station_amount_invalid"), 'error', 7500) return end
                if amount < 1 then QBCore.Functions.Notify(Lang:t("station_deposit_too_little"), 'error', 7500) return end
                DepositAmount = tonumber(amount)
                if (DepositAmount) > bankmoney then
                    QBCore.Functions.Notify(Lang:t("station_deposity_too_much"), "error")
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
            QBCore.Functions.Notify(Lang:t("not_enough_money_in_bank").." $"..costofstation, 'error', 7500) return
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
                txt = Lang:t("menu_purchase_station_header_1")..costofstation..Lang:t("menu_purchase_station_header_2"),
            },
            {
                header = Lang:t("menu_purchase_station_confirm_header"),
                icon = "fas fa-check-circle",
                txt = Lang:t("menu_purchase_station_confirm_footer")..costofstation..'!' ,
                params = {
                    event = "cdn-fuel:stations:client:purchaselocation",
                    args = {
                        location = location, 
                    }
                }
            },
            {
                header = Lang:t("menu_header_close"),
                txt = Lang:t("menu_purchase_station_cancel_footer"), 
                icon = "fas fa-times-circle",
                params = {
                    event = "qb-menu:closeMenu",
                }
            },
        })
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
                header = Lang:t("menu_ped_manage_location_header"),
                txt = Lang:t("menu_ped_manage_location_footer"),
                icon = "fas fa-usd",
                params = {
                    event = "cdn-fuel:stations:client:managemenu",
                    args = CurrentLocation,
                },
                disabled = DisableOwnerMenu,
            },
            {
                header = Lang:t("menu_ped_purchase_location_header"),
                txt = Lang:t("menu_ped_purchase_location_footer"),
                icon = "fas fa-usd",
                params = {
                    event = "cdn-fuel:stations:client:purchasemenu",
                    args = CurrentLocation,
                },
                disabled = DisablePurchase,
            },
            {
                header = Lang:t("menu_ped_emergency_shutoff_header"),
                txt = Lang:t("menu_ped_emergency_shutoff_footer")..PumpState,
                icon = "fas fa-gas-pump",
                params = {
                    event = "cdn-fuel:stations:client:Shutoff",
                    args = CurrentLocation,
                },
                disabled = ShutOffDisabled,
            },
            {
                header = Lang:t("menu_ped_close_header"),
                txt = Lang:t("menu_ped_close_footer"),
                icon = "fas fa-times-circle",
                params = {
                    event = "qb-menu:closeMenu",
                }
            },
        })
    end)

    -- Threads
    CreateThread(function() -- Spawn the Peds for Gas Stations when the resource starts.
        SpawnGasStationPeds()
    end)
end -- For Config.PlayerOwnedGasStationsEnabled check, don't remove!
