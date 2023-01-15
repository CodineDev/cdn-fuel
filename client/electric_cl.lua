if Config.ElectricVehicleCharging then
    -- Variables   
    local QBCore = exports['qb-core']:GetCoreObject()
    HoldingElectricNozzle = false
    local RefuelPossible = false
    local RefuelPossibleAmount = 0 
    local RefuelCancelled = false
    local RefuelPurchaseType = 'bank'
    -- Start
    AddEventHandler('onResourceStart', function(resource)
        if resource == GetCurrentResourceName() then
            Wait(100)
            DeleteObject(ElectricNozzle)
            HoldingElectricNozzle = false
        end
    end)

    -- Functions
    function IsHoldingElectricNozzle()
        return HoldingElectricNozzle
    end exports('IsHoldingElectricNozzle', IsHoldingElectricNozzle)
    
    function SetElectricNozzle(state)
        if state == "putback" then
            LoadAnimDict("pickup_object")
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "putbackcharger", 0.4)
            Wait(250)
            if Config.FuelTargetExport then exports['qb-target']:AllowRefuel(false, true) end
            DeleteObject(ElectricNozzle)
            HoldingElectricNozzle = false
        elseif state == "pickup" then    
            TriggerEvent('cdn-fuel:client:grabelectricnozzle')
            HoldingElectricNozzle = true
        else
            if Config.FuelDebug then print("State is not valid, it must be pickup or putback.") end
        end
    end exports('SetElectricNozzle', SetElectricNozzle)

    
    -- Events
    RegisterNetEvent('cdn-fuel:client:electric:FinalMenu', function(purchasetype)
        local money = nil
        if purchasetype == "bank" then money = QBCore.Functions.GetPlayerData().money['bank'] elseif purchasetype == 'cash' then money = QBCore.Functions.GetPlayerData().money['cash'] end
        FuelPrice = (1 * Config.ElectricChargingPrice)
        local vehicle = QBCore.Functions.GetClosestVehicle()
        local curfuel = GetFuel(vehicle)
        local finalfuel
        if curfuel < 10 then finalfuel = string.sub(curfuel, 1, 1) else finalfuel = string.sub(curfuel, 1, 2) end
        local maxfuel = (100 - finalfuel - 1)
        local wholetankcost = (FuelPrice * maxfuel)
        local wholetankcostwithtax = math.ceil(FuelPrice * maxfuel + GlobalTax(wholetankcost))
        Electricity = exports['qb-input']:ShowInput({
            header = "Select the Amount of Fuel<br>Current Price: $" ..
            FuelPrice .. " / KWh <br> Current Charge: " .. finalfuel .. " KWh <br> Full Charge Cost: $" ..
            wholetankcostwithtax .. "",
            submitText = "Insert Charger",
            inputs = {{
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = 'The Battery Can Hold ' .. maxfuel .. ' More KWh.'
            }}
        })	
        if Electricity then
            if not Electricity.amount then print("Electricity.amount is invalid!") return end
            if not HoldingElectricNozzle then QBCore.Functions.Notify(Lang:t("electric_no_nozzle"), 'error', 7500) return end
            if (Electricity.amount + finalfuel) >= 100 then
                QBCore.Functions.Notify(Lang:t("tank_already_full"), "error")
            else
                if GlobalTax(Electricity.amount * FuelPrice) + (Electricity.amount * FuelPrice) <= money then
                    local totalcost = (Electricity.amount * FuelPrice)
                    TriggerServerEvent('cdn-fuel:server:electric:OpenMenu', totalcost, IsInGasStation(), false, purchasetype, FuelPrice)
                else
                    QBCore.Functions.Notify(Lang:t("not_enough_money"), 'error', 7500)
                end
            end
        end
    end)
    
    RegisterNetEvent('cdn-fuel:client:electric:SendMenuToServer', function()
        local vehicle = QBCore.Functions.GetClosestVehicle()
        local vehiclename = GetEntityModel(vehicle)
        AwaitingElectricCheck = true
        FoundElectricVehicle = false
        :: ChargingMenu :: -- Register the starting point for the goto
        if not AwaitingElectricCheck then if Config.FuelDebug then print("Attempting to go to Charging Menu") end end
        if not AwaitingElectricCheck and FoundElectricVehicle then
            local CurFuel = GetVehicleFuelLevel(vehicle)
            local playercashamount = QBCore.Functions.GetPlayerData().money['cash']
            if not IsHoldingElectricNozzle() then QBCore.Functions.Notify(Lang:t("electric_no_nozzle"), 'error', 7500)  return end
            if CurFuel < 95 then
                exports['qb-menu']:openMenu({
                    {
                        header = Config.GasStations[FetchCurrentLocation()].label,
                        isMenuHeader = true,
                        icon = "fas fa-bolt",
                    },
                    {
                        header = Lang:t("menu_header_cash"),
                        txt = Lang:t("menu_pay_with_cash") .. playercashamount,
                        icon = "fas fa-usd",
                        params = {
                            event = "cdn-fuel:client:electric:FinalMenu",
                            args = 'cash',
                        }
                    },
                    {
                        header = Lang:t("menu_header_bank"),
                        txt = Lang:t("menu_pay_with_bank"),
                        icon = "fas fa-credit-card",
                        params = {
                            event = "cdn-fuel:client:electric:FinalMenu",
                            args = 'bank',
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
            else
                QBCore.Functions.Notify(Lang:t("tank_already_full"), 'error')
            end
        else
            if Config.FuelDebug then print("Checking") end
            if AwaitingElectricCheck then
                for i = 1, #Config.ElectricVehicles do
                    if AwaitingElectricCheck then
                        if Config.FuelDebug then print(i) end
                        local current = GetHashKey(Config.ElectricVehicles[i])
                        if Config.FuelDebug then print("^5Current Search: ^2"..current.." ^5Player's Vehicle: ^2"..vehiclename) end
                        if current == vehiclename then
                            AwaitingElectricCheck = false
                            FoundElectricVehicle = true
                            if Config.FuelDebug then print("^2"..current.. "^5 has been found. It ^2matches ^5the Player's Vehicle: ^2"..vehiclename..". ^5This means charging will be allowed.") end
                            Wait(50)
                            goto ChargingMenu -- Attempt to go to the charging menu, now that we have found that there was an electric vehicle.
                        elseif i == #Config.ElectricVehicles then
                            FoundElectricVehicle = false
                            AwaitingElectricCheck = false
                            Wait(50)
                            if Config.FuelDebug then print("^2An electric vehicle^5 has NOT been found. ^5This means charging will not be allowed.") end
                            goto ChargingMenu -- Attempt to go to the charging menu, now that we have not found that there was an electric vehicle.
                        end
                    else
                        if Config.FuelDebug then print('Search ended..') end
                    end
                end
            else
                QBCore.Functions.Notify(Lang:t("electric_vehicle_not_electric"), 'error', 7500)
            end
        end
    end)

    RegisterNetEvent('cdn-fuel:client:electric:ChargeVehicle', function(data)
       if Config.FuelDebug then print("Charging Vehicle") end
        if not Config.RenewedPhonePayment then 
            purchasetype = data.purchasetype 
        elseif data.purchasetype == "cash" then 
            purchasetype = "cash"
        else
            purchasetype = RefuelPurchaseType
        end
        if Config.FuelDebug then print("Purchase Type: "..purchasetype) end
        if not Config.RenewedPhonePayment then 
            amount = data.fuelamounttotal 
        elseif data.purchasetype == "cash" then
            amount = data.fuelamounttotal
        elseif not data.fuelamounttotal then
            amount = RefuelPossibleAmount 
        end
        if not HoldingElectricNozzle then return end
        if amount < 1 then return end
        if amount < 10 then fuelamount = string.sub(amount, 1, 1) else fuelamount = string.sub(amount, 1, 2) end
        local refillCost = (amount * FuelPrice)
        local vehicle = QBCore.Functions.GetClosestVehicle()
        local ped = PlayerPedId()
        local time = amount * Config.RefuelTime
        if amount < 10 then time = 10 * Config.RefuelTime end
        local vehicleCoords = GetEntityCoords(vehicle)
        if IsInGasStation() then
            if isCloseVeh() then
                RequestAnimDict(Config.RefuelAnimationDictionary)
                while not HasAnimDictLoaded('timetable@gardener@filling_can') do Wait(100) end
                if GetIsVehicleEngineRunning(vehicle) and Config.VehicleBlowUp then
                    local Chance = math.random(1, 100)
                    if Chance <= Config.BlowUpChance then
                        AddExplosion(vehicleCoords, 5, 50.0, true, false, true)
                        return
                    end
                end
                TaskPlayAnim(ped, Config.RefuelAnimationDictionary, Config.RefuelAnimation, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
                refueling = true
                Refuelamount = 0
                CreateThread(function()
                    while refueling do
                        if Refuelamount == nil then Refuelamount = 0 end
                        Wait(Config.RefuelTime)
                        Refuelamount = Refuelamount + 1
                        if Cancelledrefuel then
                            local finalrefuelamount = math.floor(Refuelamount)
                            local refillCost = (finalrefuelamount * FuelPrice)
                            if Config.RenewedPhonePayment and purchasetype == "bank" then
                                local remainingamount = (amount - Refuelamount)
                                MoneyToGiveBack = (GlobalTax(remainingamount) + (remainingamount * FuelPrice))
                                TriggerServerEvent("cdn-fuel:server:phone:givebackmoney", MoneyToGiveBack)
                            else
                                TriggerServerEvent('cdn-fuel:server:PayForFuel', refillCost, purchasetype, FuelPrice)
                            end
                            local curfuel = GetFuel(vehicle)
                            local finalfuel = (curfuel + Refuelamount)
                            if finalfuel >= 98 and finalfuel < 100 then
                                SetFuel(vehicle, 100)
                            else
                                SetFuel(vehicle, finalfuel)
                            end
                            if Config.RenewedPhonePayment then
                                RefuelCancelled = true
                                RefuelPossibleAmount = 0
                                RefuelPossible = false
                            end
                            Cancelledrefuel = false
                        end
                    end
                end)
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "charging", 0.3)
                QBCore.Functions.Progressbar("charge-car", Lang:t("prog_electric_charging"), time, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function()
                    refueling = false
                    if not Config.RenewedPhonePayment or purchasetype == 'cash' then TriggerServerEvent('cdn-fuel:server:PayForFuel', refillCost, purchasetype, FuelPrice) end
                    local curfuel = GetFuel(vehicle)
                    local finalfuel = (curfuel + fuelamount)
                    if finalfuel > 99 and finalfuel < 100 then
                        SetFuel(vehicle, 100)
                    else
                        SetFuel(vehicle, finalfuel)
                    end
                    if Config.RenewedPhonePayment then
                        RefuelCancelled = true
                        RefuelPossibleAmount = 0
                        RefuelPossible = false
                    end
                    StopAnimTask(ped, Config.RefuelAnimationDictionary, Config.RefuelAnimation, 3.0, 3.0, -1, 2, 0, 0, 0, 0)
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "chargestop", 0.4)
                end, function()
                    refueling = false
                    Cancelledrefuel = true
                    StopAnimTask(ped, Config.RefuelAnimationDictionary, Config.RefuelAnimation, 3.0, 3.0, -1, 2, 0, 0, 0, 0)
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "chargestop", 0.4)
                end, "fas fa-charging-station")
            end
        else return end
    end)

    RegisterNetEvent('cdn-fuel:client:grabelectricnozzle', function()
        local ped = PlayerPedId()
        if HoldingElectricNozzle then return end
        LoadAnimDict("anim@am_hold_up@male")
        TaskPlayAnim(ped, "anim@am_hold_up@male", "shoplift_high", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "pickupnozzle", 0.4)
        Wait(300)
        StopAnimTask(ped, "anim@am_hold_up@male", "shoplift_high", 1.0)
        ElectricNozzle = CreateObject(GetHashKey('electric_nozzle'), 1.0, 1.0, 1.0, true, true, false)
        local lefthand = GetPedBoneIndex(ped, 18905)
        AttachEntityToEntity(ElectricNozzle, ped, lefthand, 0.24, 0.10, -0.052 --[[FWD BWD]], -45.0 --[[ClockWise]], 120.0 --[[Weird Middle Axis]], 75.00 --[[Counter Clockwise]], 0, 1, 0, 1, 0, 1)
        local grabbedelectricnozzlecoords = GetEntityCoords(ped)
        HoldingElectricNozzle = true
        Citizen.CreateThread(function()
            while HoldingElectricNozzle do
                local currentcoords = GetEntityCoords(ped)
                local dist = #(grabbedelectricnozzlecoords - currentcoords)
                if not TargetCreated then if Config.FuelTargetExport then exports['qb-target']:AllowRefuel(true, true) end end
                TargetCreated = true
                if dist > 7.5 then
                    if TargetCreated then if Config.FuelTargetExport then exports['qb-target']:AllowRefuel(false, true) end end
                    TargetCreated = true
                    HoldingElectricNozzle = false
                    DeleteObject(ElectricNozzle)
                    QBCore.Functions.Notify(Lang:t("nozzle_cannot_reach"), 'error')
                end
                Wait(2500)
            end
        end)
    end)    

    RegisterNetEvent('cdn-fuel:client:electric:RefuelMenu', function()
        if Config.RenewedPhonePayment then
            if not RefuelPossible then 
                TriggerEvent('cdn-fuel:client:electric:SendMenuToServer')
            else 
                if Config.RenewedPhonePayment then
                    if not Cancelledrefuel and not RefuelCancelled then
                        if RefuelPossibleAmount then
                            local purchasetype = "bank"
                            local fuelamounttotal = tonumber(RefuelPossibleAmount)
                            if Config.FuelDebug then print("Attempting to charge vehicle.") end
                            TriggerEvent('cdn-fuel:client:electric:ChargeVehicle', purchasetype, fuelamounttotal) 
                        else
                            QBCore.Functions.Notify(Lang:t("electric_more_than_zero"), 'error', 7500)
                        end
                    end
                end
            end
        else
            TriggerEvent("cdn-fuel:client:electric:SendMenuToServer")
        end
    end)

    if Config.RenewedPhonePayment then
        RegisterNetEvent('cdn-fuel:client:electric:phone:PayForFuel', function(amount)
            FuelPrice = Config.ElectricChargingPrice
            local cost = amount * FuelPrice
            local tax = GlobalTax(cost)
            local total = math.ceil(cost + tax)
            local success = exports['qb-phone']:PhoneNotification(Lang:t("electric_phone_header"), Lang:t("electric_phone_notification")..total, 'fas fa-bolt', '#9f0e63', "NONE", 'fas fa-check-circle', 'fas fa-times-circle')
            if success then
                if QBCore.Functions.GetPlayerData().money['bank'] <= (GlobalTax(amount) + amount) then
                    QBCore.Functions.Notify(Lang:t("not_enough_money_in_bank"), "error")
                else
                    TriggerServerEvent('cdn-fuel:server:PayForFuel', total, "bank", FuelPrice, true)
                    RefuelPossible = true
                    RefuelPossibleAmount = amount
                    RefuelPurchaseType = "bank"
                    RefuelCancelled = false
                end
            end
        end)
    end

    -- Threads 

    if Config.ElectricChargerModel then
        CreateThread(function()
            for i = 1, #Config.GasStations do
                if Config.GasStations[i].electricchargercoords ~= nil then
                    if Config.FuelDebug then print(i) end
                    local heading = Config.GasStations[i].electricchargercoords[4] - 180
                    RequestModel('electric_charger')
                    while not HasModelLoaded('electric_charger') do
                        Wait(50)
                        if Config.FuelDebug then
                            print("Loading Electric Charger Model.")
                        end
                    end
                    Config.GasStations[i].electriccharger = CreateObject('electric_charger', Config.GasStations[i].electricchargercoords.x, Config.GasStations[i].electricchargercoords.y, Config.GasStations[i].electricchargercoords.z, false, true, true)
                    if Config.FuelDebug then print("Created Electric Charger @ Location #"..i) end
                    SetEntityHeading(Config.GasStations[i].electriccharger, heading)
                    FreezeEntityPosition(Config.GasStations[i].electriccharger, 1)
                end	
            end
        end)
    end

    -- Resource Stop

    AddEventHandler('onResourceStop', function(resource)
        if resource == GetCurrentResourceName() then
            for i = 1, #Config.GasStations do
                if Config.GasStations[i].electricchargercoords ~= nil then
                    DeleteEntity(Config.GasStations[i].electriccharger)
                    if IsHoldingElectricNozzle() then DeleteEntity(ElectricNozzle) end
                end	
            end
        end
    end)

    -- Target

    exports['qb-target']:AddTargetModel('electric_charger', {
        options = {
            {
                num = 1,
                type = "client",
                event = "cdn-fuel:client:grabelectricnozzle",
                icon = "fas fa-bolt",
                label = Lang:t("grab_electric_nozzle"),
                canInteract = function()
                    if not IsHoldingElectricNozzle() and not IsPedInAnyVehicle(PlayerPedId()) then
                        return true
                    end
                end
            },
            {
                num = 2,
                type = "client",
                event = "cdn-fuel:client:returnnozzle",
                icon = "fas fa-hand",
                label = Lang:t("return_nozzle"),
                canInteract = function()
                    if IsHoldingElectricNozzle() and not refueling then
                        return true
                    end
                end
            },
        },
        distance = 2.0
    })
end