local Translations = {
    -- Fuel
    set_fuel_debug = "Benzine gezet naar:",
    cancelled = "Geannuleerd.",
    not_enough_money = "Je hebt niet genoeg geld!",
    not_enough_money_in_bank = "Je hebt niet genoeg geld op de bank!",
    not_enough_money_in_cash = "Je hebt niet genoeg geld bij je!",
    more_than_zero = "Je moet meer dan 0L tanken!",
    emergency_shutoff_active = "Het tankstation is momenteel gesloten, ga naar een ander tankstation.",
    nozzle_cannot_reach = "Het vulpistool kan niet zo ver!",
    station_no_fuel = "Dit tankstation heeft geen benzine meer!",
    station_not_enough_fuel = "Dit tankstation heeft niet zoveel benzine meer!",
    show_input_key_special = "Druk op [G] als je bij het voertuig bent dat je wilt tanken!",
    tank_cannot_fit = "Zoveel benzine past niet in je tank!",
    tank_already_full = "Je voertuig is al vol getankt!",
    need_electric_charger = "Je moet je voertuig opladen bij een laadpunt!",
    cannot_refuel_inside = "Je kan niet tanken vanuit een voertuig!",
    
    -- 2.1.2 -- Reserves Pickup ---
    fuel_order_ready = "Je kan je bestelde benzine ophalen! Bekijk de GPS om de bestelling te vinden!",
    draw_text_fuel_dropoff = "[E] Vrachtwagen inleveren",
    fuel_pickup_success = "Je voorraad is bijgevuld naar: %sL",
    fuel_pickup_failed = "Ron Oil heeft de benzine afgeleverd bij je tankstation!",
    trailer_too_far = "De trailer is niet gekoppeld aan de vrachtwagen of is te ver weg!",

    -- 2.1.0
    no_nozzle = "Je hebt geen vulpistool!",
    vehicle_is_damaged = "Voertuig is te beschadigd om te tanken!",
    vehicle_too_far = "Je bent te ver van het voertuig vandaan om te tanken!",
    inside_vehicle = "Je kan niet tanken vanuit een voertuig!",
    you_are_discount_eligible = "Als je in dienst gaat kan je een korting krijgen van "..Config.EmergencyServicesDiscount['discount'].."%!",
    no_fuel = "Er is niet genoeg benzine..",

    -- Electric
    electric_more_than_zero = "Je moet meer dan 0KW laden!",
    electric_vehicle_not_electric = "Je voertuig is niet elektrisch!",
    electric_no_nozzle = "Je voertuig is niet elektrisch!",

    -- Phone --
    electric_phone_header = "Laadpaal",
    electric_phone_notification = "Totale kosten: €",
    fuel_phone_header = "Tankstation",
    phone_notification = "Totale kosten: €",
    phone_refund_payment_label = "Refund van het tankstation!",

    -- Stations
    station_per_liter = " / Liter!",
    station_already_owned = "Dit tankstation is al in bezit van iemand!",
    station_cannot_sell = "Je kan dit tankstation niet verkopen!",
    station_sold_success = "Je hebt het tankstation verkocht!",
    station_not_owner = "Je bent geen eigenaar van dit tankstation!",
    station_amount_invalid = "Aantal is ongeldig!",
    station_more_than_one = "Je moet meer dan 1L kopen!",
    station_price_too_high = "De prijs is te hoog!",
    station_price_too_low = "De prijs is te laag!",
    station_name_invalid = "Deze naam is ongeldig!",
    station_name_too_long = "De naam van het tankstation kan niet langer zijn dan "..Config.NameChangeMaxChar.." tekens.",
    station_name_too_short = "De naam moet langer zijn dan "..Config.NameChangeMinChar.." tekens.",
    station_withdraw_too_much = "Je kan niet meer opnemen dan dat het tankstation heeft!", 
    station_withdraw_too_little = "Je kan niet minder dan €1 opnemen!",
    station_success_withdrew_1 = "Je hebt €",
    station_success_withdrew_2 = " opgenomen van je tankstation!", -- Leave the space @ the front!
    station_deposit_too_much = "Je kan niet meer storten dan je hebt!", 
    station_deposit_too_little = "Je kan niet minder dan €1 storten!",
    station_success_deposit_1 = "Je hebt €",
    station_success_deposit_2 = " gestort op de rekening van je tankstation!", -- Leave the space @ the front!
    station_cannot_afford_deposit = "Zoveel kan je niet storten!",
    station_shutoff_success = "Je hebt de pomp uitgeschakeld!",
    station_fuel_price_success = "Je hebt de prijs per liter veranderd naar €",
    station_reserve_cannot_fit = "Zoveel benzine kan je niet bijkopen!",
    station_reserves_over_max =  "Je kan niet zoveel benzine bijkopen, het maximale is "..Config.MaxFuelReserves.." liter",
    station_name_change_success = "Je hebt de naam van het tankstation veranderd naar: ", -- Leave the space @ the end!
    station_purchased_location_payment_label = "Je hebt een tankstation gekocht: ",
    station_sold_location_payment_label = "Je hebt een tankstation verkocht: ",
    station_withdraw_payment_label = "Je hebt geld opgenomen bij tankstation: ",
    station_deposit_payment_label = "Je hebt geld gestort bij tankstation: ",
    -- All Progress Bars
    prog_refueling_vehicle = "Voertuig tanken..",
    prog_electric_charging = "Voertuig opladen..",
    prog_jerry_can_refuel = "Jerrycan vullen..",
    prog_syphoning = "Benzine stelen..",

    -- Menus
    
    menu_header_cash = "Contant",
    menu_header_bank = "Bank",
    menu_header_close = "Annuleer",
    menu_pay_with_cash = "Contant betalen.  \nJe hebt €",
    menu_pay_with_bank = "Betalen met de bank.", 
    menu_refuel_header = "Tankstation",
    menu_refuel_accept = "Ik wil graag betalen voor de benzine.",
    menu_refuel_cancel = "Ik hoef niet meer te tanken.",
    menu_pay_label_1 = "Benzine voor ",
    menu_pay_label_2 = " / L",
    menu_header_jerry_can = "Jerrycan",
    menu_header_refuel_jerry_can = "Jerrycan bijvullen",
    menu_header_refuel_vehicle = "Voertuig tanken",

    menu_electric_cancel = "Sluit het menu.",
    menu_electric_header = "Elektrische lader",
    menu_electric_accept = "Bevestig.",
    menu_electric_payment_label_1 = "Stroom voor ",
    menu_electric_payment_label_2 = " / KW",


    -- Station Menus

    menu_ped_manage_location_header = "Tankstation beheren",
    menu_ped_manage_location_footer = "Als je de eigenaar bent van dit tankstation kan je hem hier beheren.",

    menu_ped_purchase_location_header = "Tankstation kopen",
    menu_ped_purchase_location_footer = "Als nog niemand de eigenaar is van dit tankstation kan je hem kopen.",

    menu_ped_emergency_shutoff_header = "Tankstation sluiten",
    menu_ped_emergency_shutoff_footer = "Sluit het tankstion af.   \n De pomp is momenteel ",
    
    menu_ped_close_header = "Annuleren",
    menu_ped_close_footer = "Sluit het menu.",

    menu_station_reserves_header = "Benzine kopen ",
    menu_station_reserves_purchase_header = "Bevestig",
    menu_station_reserves_purchase_footer = "Koop benzine voor €",
    menu_station_reserves_cancel_footer = "Sluit het menu.",
    
    menu_purchase_station_header_1 = "Het totaal bedrag is €",
    menu_purchase_station_header_2 = " inclusief belasting.",
    menu_purchase_station_confirm_header = "Bevestig",
    menu_purchase_station_confirm_footer = "Koop dit tankstation voor €",
    menu_purchase_station_cancel_footer = "Sluit het menu.",

    menu_sell_station_header = "Verkoop ",
    menu_sell_station_header_accept = "Tankstation verkopen",
    menu_sell_station_footer_accept = "Ja ik wil dit tankstation verkopen voor €",
    menu_sell_station_footer_close = "Er is niks meer om te bespreken.",

    menu_manage_header = "Beheer van ",
    menu_manage_reserves_header = "Benzine voorraad  \n",
    menu_manage_reserves_footer_1 =  " liter van de ",
    menu_manage_reserves_footer_2 =  " liter!",
    
    menu_manage_purchase_reserves_header = "Benzine kopen",
    menu_manage_purchase_reserves_footer = "Koop benzine bij voor €",
    menu_manage_purchase_reserves_footer_2 = " per liter!",

    menu_alter_fuel_price_header = "Prijs beheren",
    menu_alter_fuel_price_footer_1 = "Verander de prijs van je tankstation!  \nHuidige prijs: €",
    
    menu_manage_company_funds_header = "Bedrijfsrekening",
    menu_manage_company_funds_footer = "Bekijk de financiën van je tankstation.",
    menu_manage_company_funds_header_2 = "Bedrijfsrekening van ",
    menu_manage_company_funds_withdraw_header = "Geld opnemen",
    menu_manage_company_funds_withdraw_footer = "Neem geld op van de bedrijfsrekening.",
    menu_manage_company_funds_deposit_header = "Geld storten",
    menu_manage_company_funds_deposit_footer = "Stort geld op de bedrijfsrekening.",
    menu_manage_company_funds_return_header = "Terug",
    menu_manage_company_funds_return_footer = "Ga terug naar het vorige menu.",

    menu_manage_change_name_header = "Naam veranderen",
    menu_manage_change_name_footer = "Verander je naam van het tankstation.",

    menu_manage_sell_station_footer = "Verkoop je tankstation voor €",

    menu_manage_close = "Sluit het menu.", 

    -- Jerry Can Menus 
    menu_jerry_can_purchase_header = "Koop een jerrycan voor €",
    menu_jerry_can_footer_full_gas = "Je jerrycan is al vol!",
    menu_jerry_can_footer_refuel_gas = "Jerrycan vullen!",
    menu_jerry_can_footer_use_gas = "Gebruik je jerrycan om het voertuig te tanken!",
    menu_jerry_can_footer_no_gas = "Er zit geen benzine in je jerrycan!",
    menu_jerry_can_footer_close = "Sluit het menu.",
    menu_jerry_can_close = "Sluit het menu.",

    -- Syphon Kit Menus
    menu_syphon_kit_full = "Je hevelpomp zit vol, er past maar " .. Config.SyphonKitCap .."L in!",
    menu_syphon_vehicle_empty = "De benzinetank van dit voertuig is leeg.",
    menu_syphon_allowed = "Steel benzine van een onschuldig slachtoffer!",
    menu_syphon_refuel = "Gebruik je gestolen benzine om je eigen voertuig te hervullen!",
    menu_syphon_empty = "Gebruik je gestolen benzine om je eigen voertuig te hervullen!",
    menu_syphon_cancel = "Ik hoef dit niet meer te doen, laat maar zitten!",
    menu_syphon_header = "Hevelpomp",
    menu_syphon_refuel_header = "Bijvullen",


    -- Input --
    input_select_refuel_header = "Hoeveel benzine wil je tanken.",
    input_refuel_submit = "Bevestig",
    input_refuel_jerrycan_submit = "Bevestig",
    input_max_fuel_footer_1 = "Je kan tot ",
    input_max_fuel_footer_2 = "L benzine.",
    input_insert_nozzle = "Voertuig tanken", -- Used for Target as well!

    input_purchase_reserves_header_1 = "Benzine kopen  \nHuidige prijs: €",
    input_purchase_reserves_header_2 = Config.FuelReservesPrice .. " / Liter  \nHuidige voorraad: ",
    input_purchase_reserves_header_3 = " Liter  \nCompleet bijvullen kost €",
    input_purchase_reserves_submit_text = "Bevestig",
    input_purchase_reserves_text = 'Benzine bijkopen.',

    input_alter_fuel_price_header_1 = "Verander de benzine prijs   \nHuidige prijs: €",
    input_alter_fuel_price_header_2 = " per liter",
    input_alter_fuel_price_submit_text = "Bevestig",

    input_change_name_header_1 = "Verander ",
    input_change_name_header_2 = "'s naam.",
    input_change_name_submit_text = "Bevestig",
    input_change_name_text = "Nieuwe naam..",

    input_withdraw_funds_header = "Geld opnemen  \nHuidig saldo: €",
    input_withdraw_submit_text = "Opnemen",
    input_withdraw_text = "Geld opnemen",

    input_deposit_funds_header = "Geld storten  \nHuidig saldo: €",
    input_deposit_submit_text = "Storten",
    input_deposit_text = "Geld storten",

    -- Target
    grab_electric_nozzle = "Lader pakken",
    insert_electric_nozzle = "Laden",
    grab_nozzle = "Vulpistool pakken",
    return_nozzle = "Vulpistool terug hangen",
    grab_special_nozzle = "Vulpistool pakken",
    return_special_nozzle = "Vulpistool terug hangen",
    buy_jerrycan = "Jerrycan kopen",
    station_talk_to_ped = "Tankstation beheren",

    -- Jerry Can
    jerry_can_full = "Je jerrycan is vol!",
    jerry_can_refuel = "Jerrycan bijvullen!",
    jerry_can_not_enough_fuel = "Je jerrycan heeft niet zoveel benzine!",
    jerry_can_not_fit_fuel = "Er past niet zoveel benzine in je jerrycan!",
    jerry_can_success = "Je hebt je jerrycan gevuld!",
    jerry_can_success_vehicle = "Je hebt je voertuig getankt met je jerrycan!",
    jerry_can_payment_label = "Je hebt een jerrycan gekocht.",

    -- Syphoning
    syphon_success = "Je hebt benzine geheveld van het voertuig!",
    syphon_success_vehicle = "Je hebt het voertuig gevuld met benzine uit de hevelpomp!",
    syphon_electric_vehicle = "Dit is een elektrisch voertuig!",
    syphon_no_syphon_kit = "Je hebt geen hevelpomp bij je.",
    syphon_inside_vehicle = "Je kan niet hevelen als je in/op een voertuig zit!",
    syphon_more_than_zero = "Je moet meer dan 0L stelen!",
    syphon_kit_cannot_fit_1 = "Je kan niet zoveel benzine hevelen, je hebt nog ruimte voor : ",
    syphon_kit_cannot_fit_2 = " Liter.",
    syphon_not_enough_gas = "Je hebt niet genoeg benzine om bij te vullen!",
    syphon_dispatch_string = "(10-90) - Benzine Diefstal",
}

if GetConvar('qb_locale', 'en') == 'nl' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
