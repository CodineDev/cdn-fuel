local Translations = {
    -- Fuel
    set_fuel_debug = "Set fuel to:",
    cancelled = "Cancelled.",
    not_enough_money = "You don't have enough money!",
    not_enough_money_in_bank = "You don't have enough money in your bank!",
    not_enough_money_in_cash = "You don't have enough money in your pocket!",
    more_than_zero = "You have to fuel more than 0L!",
    emergency_shutoff_active = "The pumps are currently shut off via the emergency shut off system.",
    nozzle_cannot_reach = "The nozzle can't reach this far!",
    station_no_fuel = "This station is out of fuel!",
    station_not_enough_fuel = "The station does not have this much fuel!",
    show_input_key_special = "Press [G] when near the vehicle to fuel it up!",
    tank_cannot_fit = "Your tank cannot fit this!",
    tank_already_full = "Your vehicle is already full!",
    need_electric_charger = "I need to go to an electric charger!",
    cannot_refuel_inside = "You cannot refuel from inside of the vehicle!",
    
    -- 2.1.2 -- Reserves Pickup ---
    fuel_order_ready = "Your fuel order is available for pickup! Take a look at your GPS to find the pickup!",
    draw_text_fuel_dropoff = "[E] Drop Off Truck",
    fuel_pickup_success = "Your reserves have been filled to: %sL",
    fuel_pickup_failed = "Ron Oil has just dropped off the fuel to your station!",
    trailer_too_far = "The trailer is not attached to the truck or is too far!",

    -- 2.1.0
    no_nozzle = "You do not have the nozzle!",
    vehicle_is_damaged = "Vehicle is too damaged to refuel!",
    vehicle_too_far = "You are too far to fuel this vehicle!",
    inside_vehicle = "You cannot refuel from inside the vehicle!",
    you_are_discount_eligible = "If you go on duty, you could recieve a discount of "..Config.EmergencyServicesDiscount['discount'].."%!",
    no_fuel = "No fuel..",

    -- Electric
    electric_more_than_zero = "You have to charge more than 0KW!",
    electric_vehicle_not_electric = "Your vehicle is not electric!",
    electric_no_nozzle = "Your vehicle is not electric!",

    -- Phone --
    electric_phone_header = "Electric Charger",
    electric_phone_notification = "Electricity Total Cost: $",
    fuel_phone_header = "Gas Station",
    phone_notification = "Total Cost: $",
    phone_refund_payment_label = "Refund @ Gas Station!",

    -- Stations
    station_per_liter = " / Liter!",
    station_already_owned = "This location is already owned!",
    station_cannot_sell = "You cannot sell this location!",
    station_sold_success = "You successfully sold this location!",
    station_not_owner = "You do not own the location!",
    station_amount_invalid = "Amount is invalid!",
    station_more_than_one = "You have to buy more than 1L!",
    station_price_too_high = "This price is too high!",
    station_price_too_low = "This price is too low!",
    station_name_invalid = "This name is invalid!",
    station_name_too_long = "Name cannot be longer than "..Config.NameChangeMaxChar.." characters.",
    station_name_too_short = "Name must be longer than "..Config.NameChangeMinChar.." characters.",
    station_withdraw_too_much = "You cannot withdraw more than the station has!", 
    station_withdraw_too_little = "You cannot withdraw less than $1!",
    station_success_withdrew_1 = "Successfully withdrew $",
    station_success_withdrew_2 = " from this station's balance!", -- Leave the space @ the front!
    station_deposit_too_much = "You cannot deposit more than the you have!", 
    station_deposit_too_little = "You cannot deposit less than $1!",
    station_success_deposit_1 = "Successfully deposited $",
    station_success_deposit_2 = " into this station's balance!", -- Leave the space @ the front!
    station_cannot_afford_deposit = "You cannot afford to deposit $",
    station_shutoff_success = "Successfully altered the shutoff valve state for this location!",
    station_fuel_price_success = "Successfully altered fuel price to $",
    station_reserve_cannot_fit = "The reserves cannot fit this!",
    station_reserves_over_max =  "You cannot purchase this amount as it will be great than the maximum amount of "..Config.MaxFuelReserves.." Liters",
    station_name_change_success = "Successfully changed name to: ", -- Leave the space @ the end!
    station_purchased_location_payment_label = "Purchased a Gas Station Location: ",
    station_sold_location_payment_label = "Sold a Gas Station Location: ",
    station_withdraw_payment_label = "Withdrew money from Gas Station. Location: ",
    station_deposit_payment_label = "Deposited money to Gas Station. Location: ",
    -- All Progress Bars
    prog_refueling_vehicle = "Refueling Vehicle..",
    prog_electric_charging = "Charging..",
    prog_jerry_can_refuel = "Refueling Jerry Can..",
    prog_syphoning = "Syphoning Fuel..",

    -- Menus
    
    menu_header_cash = "Cash",
    menu_header_bank = "Bank",
    menu_header_close = "Cancel",
    menu_pay_with_cash = "Pay with cash.  \nYou have: $",
    menu_pay_with_bank = "Pay with bank.", 
    menu_refuel_header = "Gas Station",
    menu_refuel_accept = "I would like to purchase the fuel.",
    menu_refuel_cancel = "I actually don't want fuel anymore.",
    menu_pay_label_1 = "Gasoline @ ",
    menu_pay_label_2 = " / L",
    menu_header_jerry_can = "Jerry Can",
    menu_header_refuel_jerry_can = "Refuel Jerry Can",
    menu_header_refuel_vehicle = "Refuel Vehicle",

    menu_electric_cancel = "I actually don't want to charge my car anymore.",
    menu_electric_header = "Electric Charger",
    menu_electric_accept = "I would like to pay for electricity.",
    menu_electric_payment_label_1 = "Electricity @ ",
    menu_electric_payment_label_2 = " / KW",


    -- Station Menus

    menu_ped_manage_location_header = "Manage This Location",
    menu_ped_manage_location_footer = "If you are the owner, you can manage this location.",

    menu_ped_purchase_location_header = "Purchase This Location",
    menu_ped_purchase_location_footer = "If no one owns this location, you can purchase it.",

    menu_ped_emergency_shutoff_header = "Toggle Emergency Shutoff",
    menu_ped_emergency_shutoff_footer = "Shut off the fuel in case of an emergency.   \n The pumps are currently ",
    
    menu_ped_close_header = "Cancel Conversation",
    menu_ped_close_footer = "I actually don't want to discuss anything anymore.",

    menu_station_reserves_header = "Buy Reserves for ",
    menu_station_reserves_purchase_header = "Buy reserves for: $",
    menu_station_reserves_purchase_footer = "Yes I want to buy fuel reserves for $",
    menu_station_reserves_cancel_footer = "I actually don't want to buy more reserves!",
    
    menu_purchase_station_header_1 = "The total cost is going to be: $",
    menu_purchase_station_header_2 = " including taxes.",
    menu_purchase_station_confirm_header = "Confirm",
    menu_purchase_station_confirm_footer = "I want to purchase this location for $",
    menu_purchase_station_cancel_footer = "I actually don't want to buy this location anymore. That price is bonkers!",

    menu_sell_station_header = "Sell ",
    menu_sell_station_header_accept = "Sell Gas Station",
    menu_sell_station_footer_accept = "Yes, I want to sell this location for $",
    menu_sell_station_footer_close = "I actually don't have anything more to discuss.",

    menu_manage_header = "Management of ",
    menu_manage_reserves_header = "Fuel Reserves  \n",
    menu_manage_reserves_footer_1 =  " Liters out of ",
    menu_manage_reserves_footer_2 =  " Liters  \nYou can purchase more reserves below!",
    
    menu_manage_purchase_reserves_header = "Purchase More Fuel for Reserves",
    menu_manage_purchase_reserves_footer = "I want to purchase more fuel reserves for $",
    menu_manage_purchase_reserves_footer_2 = " / L!",

    menu_alter_fuel_price_header = "Alter Fuel Price",
    menu_alter_fuel_price_footer_1 = "I want to change the price of fuel at my Gas Station!  \nCurrently, it is $",
    
    menu_manage_company_funds_header = "Manage Company Funds",
    menu_manage_company_funds_footer = "I want to manage this locations funds.",
    menu_manage_company_funds_header_2 = "Funds Management of ",
    menu_manage_company_funds_withdraw_header = "Withdraw Funds",
    menu_manage_company_funds_withdraw_footer = "Withdraw funds from the Station's account.",
    menu_manage_company_funds_deposit_header = "Deposit Funds",
    menu_manage_company_funds_deposit_footer = "Deposit funds to the Station's account.",
    menu_manage_company_funds_return_header = "Return",
    menu_manage_company_funds_return_footer = "I want to discuss something else!",

    menu_manage_change_name_header = "Change Location Name",
    menu_manage_change_name_footer = "I want to change the location name.",

    menu_manage_sell_station_footer = "Sell your gas station for $",

    menu_manage_close = "I actually don't have anything more to discuss!", 

    -- Jerry Can Menus 
    menu_jerry_can_purchase_header = "Purchase Jerry Can for $",
    menu_jerry_can_footer_full_gas = "Your Jerry Can is full!",
    menu_jerry_can_footer_refuel_gas = "Refuel your Jerry Can!",
    menu_jerry_can_footer_use_gas = "Put your gasoline to use and refuel the vehicle!",
    menu_jerry_can_footer_no_gas = "You have no gas in your Jerry Can!",
    menu_jerry_can_footer_close = "I actually don't want a Jerry Can anymore.",
    menu_jerry_can_close = "I actually don't want to use this anymore.",

    -- Syphon Kit Menus
    menu_syphon_kit_full = "Your Syphon Kit is full! It only fits " .. Config.SyphonKitCap .. "L!",
    menu_syphon_vehicle_empty = "This vehicle's fuel tank is empty.",
    menu_syphon_allowed = "Steal fuel from an unsuspecting victim!",
    menu_syphon_refuel = "Put your stolen gasoline to use and refuel the vehicle!",
    menu_syphon_empty = "Put your stolen gasoline to use and refuel the vehicle!",
    menu_syphon_cancel = "I actually don't want to use this anymore. I've turned a new leaf!",
    menu_syphon_header = "Syphon",
    menu_syphon_refuel_header = "Refuel",


    -- Input --
    input_select_refuel_header = "Select how much gas to refuel.",
    input_refuel_submit = "Refuel Vehicle",
    input_refuel_jerrycan_submit = "Refuel Jerry Can",
    input_max_fuel_footer_1 = "Up to ",
    input_max_fuel_footer_2 = "L of gas.",
    input_insert_nozzle = "Insert Nozzle", -- Used for Target as well!

    input_purchase_reserves_header_1 = "Purchase Reserves  \nCurrent Price: $",
    input_purchase_reserves_header_2 = Config.FuelReservesPrice .. " / Liter  \nCurrent Reserves: ",
    input_purchase_reserves_header_3 = " Liters  \nFull Reserve Cost: $",
    input_purchase_reserves_submit_text = "Buy Reserves",
    input_purchase_reserves_text = 'Purchase Fuel Reserves.',

    input_alter_fuel_price_header_1 = "Alter Fuel Price   \nCurrent Price: $",
    input_alter_fuel_price_header_2 = " / Liter",
    input_alter_fuel_price_submit_text = "Change Fuel Price",

    input_change_name_header_1 = "Change ",
    input_change_name_header_2 = "'s Name.",
    input_change_name_submit_text = "Submit Name Change",
    input_change_name_text = "New Name..",

    input_withdraw_funds_header = "Withdraw Funds  \nCurrent Balance: $",
    input_withdraw_submit_text = "Withdraw",
    input_withdraw_text = "Withdraw Funds",

    input_deposit_funds_header = "Deposit Funds  \nCurrent Balance: $",
    input_deposit_submit_text = "Deposit",
    input_deposit_text = "Deposit Funds",

    -- Target
    grab_electric_nozzle = "Grab Electric Nozzle",
    insert_electric_nozzle = "Insert Electric Nozzle",
    grab_nozzle = "Grab Nozzle",
    return_nozzle = "Return Nozzle",
    grab_special_nozzle = "Grab Special Nozzle",
    return_special_nozzle = "Return Special Nozzle",
    buy_jerrycan = "Purchase Jerry Can",
    station_talk_to_ped = "Discuss Gas Station",

    -- Jerry Can
    jerry_can_full = "Your Jerry can is full!",
    jerry_can_refuel = "Refuel your Jerry Can!",
    jerry_can_not_enough_fuel = "The Jerry Can doesn't have this much fuel!",
    jerry_can_not_fit_fuel = "The Jerry Can cannot fit this much fuel!",
    jerry_can_success = "Successfully filled the Jerry Can!",
    jerry_can_success_vehicle = "Successfully fueled the vehicle with the Jerry Can!",
    jerry_can_payment_label = "Purchased Jerry Can.",

    -- Syphoning
    syphon_success = "Successfully syphoned from vehicle!",
    syphon_success_vehicle = "Successfully fueled the vehicle with the Syphon Kit!",
    syphon_electric_vehicle = "This vehicle is electric!",
    syphon_no_syphon_kit = "You need something to syphon gas with.",
    syphon_inside_vehicle = "You cannot syphon from the inside of the vehicle!",
    syphon_more_than_zero = "You have to steal more than 0L!",
    syphon_kit_cannot_fit_1 = "You cannot syphon this much, your can won't fit it! You can only fit: ",
    syphon_kit_cannot_fit_2 = " Liters.",
    syphon_not_enough_gas = "You don't have enough gas to refuel that much!",
    syphon_dispatch_string = "(10-90) - Gasoline Theft",
}
Lang = Locale:new({phrases = Translations, warnOnMissing = true})