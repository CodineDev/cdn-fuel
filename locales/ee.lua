local Translations = {
    -- Fuel
    set_fuel_debug = "Kütuse tax määratud:",
    cancelled = "Tegevus katkestatud.",
    not_enough_money = "Sul ei ole piisavalt raha!",
    not_enough_money_in_bank = "Sul ei ole piisavalt raha arvel!",
    not_enough_money_in_cash = "Näib, et sul ei ole piisavalt sularaha kaasas!",
    more_than_zero = "Kütuse koguse määramisel, peab kogus olema üle 0L!",
    emergency_shutoff_active = "Praegu on pumbad välja lülitatud hädaseiskamissüsteemi kaudu.",
    nozzle_cannot_reach = "Kütuse otsik ei ulatu nii kaugele!",
    station_no_fuel = "Näib, et sellest tanklast on kütus otsa saanud!",
    station_not_enough_fuel = "Tanklas ei ole nii palju kütust, kui te määrasite!",
    show_input_key_special = "Vajuta [G] tankida sõidukit mis lähedal on!",
    tank_cannot_fit = "See ei käi siia!",
    tank_already_full = "Sinu sõiduk on täis juba!",
    need_electric_charger = "Elektri auto jaoks, peaksid sa minema laadimispunkti!",
    cannot_refuel_inside = "Sa ei saa tankida sõidukit, kui ise seal sees istud!",
    
    -- 2.1.2 -- Reservi kogumine ---
    fuel_order_ready = "Teie kütuse tellimus on saadaval kogumiseks! Vaadake oma GPS-i, et leida kogumiskoht!",
    draw_text_fuel_dropoff = "[E] Jäta veok maha",
    fuel_pickup_success = "Teie reservuaarid on täidetud: %sL",
    fuel_pickup_failed = "Ron Oil on just teie jaama kütust maha toimetanud!",
    trailer_too_far = "Haagis pole veokiga ühendatud või on liiga kaugel!",

    -- 2.1.0
    no_nozzle = "Sul ei ole kütuse otsikut!",
    vehicle_is_damaged = "Sõiduk on liiga katki, et seda tankida!",
    vehicle_too_far = "Oled liiga kaugel, et seda sõidukit tankida!",
    inside_vehicle = "Sa ei saa tankida sõidukit, kui ise seal sees istud!",
    you_are_discount_eligible = "Kui sa alustad tööpäeva, siis sulle on määratud "..Config.EmergencyServicesDiscount['discount'].."% allahindlus tanklates!",
    no_fuel = "Kütus otsas..",

    -- Electric
    electric_more_than_zero = "Pead laadima rohkem, kui: 0KW!",
    electric_vehicle_not_electric = "See sõiduk pole elektri auto!",
    electric_no_nozzle = "See sõiduk pole elektri auto!",

    -- Phone --
    electric_phone_header = "Laadimispunkt",
    electric_phone_notification = "Kogu maksumus: $",
    fuel_phone_header = "Tankla",
    phone_notification = "Kogu maksumus: $",
    phone_refund_payment_label = "Tagasimakse @ Tankla!",

    -- Stations
    station_per_liter = " / L!",
    station_already_owned = "Keegi omab seda tanklat juba!",
    station_cannot_sell = "Sa ei saa müüa seda tanklat!",
    station_sold_success = "Müüsite edukalt maha tankla!",
    station_not_owner = "See tankla ei kuulu sinule!",
    station_amount_invalid = "Ebakorrektne kogus!",
    station_more_than_one = "Pead ostma rohkem, kui 1L!",
    station_price_too_high = "Hind on liiga kõrge!",
    station_price_too_low = "Hind on liiga madal!",
    station_name_invalid = "Nimi on ebakorrektne!",
    station_name_too_long = "Nimi ei saa olla pikem, kui "..Config.NameChangeMaxChar.." tähemärki.",
    station_name_too_short = "Nimi peab olema pikem, kui "..Config.NameChangeMinChar.." tähemärki.",
    station_withdraw_too_much = "Sa ei saa väljasta rohkem, kui tanklas on!", 
    station_withdraw_too_little = "Sa ei saa väljastad vähem, kui $1!",
    station_success_withdrew_1 = "Edukalt väljastatud: $",
    station_success_withdrew_2 = " tankla arvelt!", -- Leave the space @ the front!
    station_deposit_too_much = "Sa ei saa sisestada rohkem, kui sul endal on arvel!", 
    station_deposit_too_little = "Sa ei saa sisestada vähem, kui $1!",
    station_success_deposit_1 = "Edukalt sisestatud: $",
    station_success_deposit_2 = " tankla arvele!", -- Leave the space @ the front!
    station_cannot_afford_deposit = "Te ei saa endale sissemakset lubada: $",
    station_shutoff_success = "Selle asukoha sulgventiili oleku muutmine õnnestus!",
    station_fuel_price_success = "Kütusehinna muutmine õnnestus, hind: $",
    station_reserve_cannot_fit = "Reservi, ei mahu nii palju!",
    station_reserves_over_max =  "Te ei saa seda kogust osta, kuna see on suurem kui maksimaalne kogus "..Config.MaxFuelReserves.." liitrit",
    station_name_change_success = "Edukalt muudetud nime, uus nimi: ", -- Leave the space @ the end!
    station_purchased_location_payment_label = "Edukalt ostetud tankla: ",
    station_sold_location_payment_label = "Edukalt müüdud tankla: ",
    station_withdraw_payment_label = "Edukalt väljastatud raha tankla arvelt. Asukoht: ",
    station_deposit_payment_label = "Edukalt sisestatud arvelt tankla arvele. Asukoht: ",
    -- All Progress Bars
    prog_refueling_vehicle = "Tangid..",
    prog_electric_charging = "Laed..",
    prog_jerry_can_refuel = "Täidad kütusekanistrit..",
    prog_syphoning = "Süfoonid kütust..",

    -- Menus
    
    menu_header_cash = "Sularaha",
    menu_header_bank = "Pangakonto",
    menu_header_close = "Katkesta",
    menu_pay_with_cash = "Maksa sularahas. \nSul on: $",
    menu_pay_with_bank = "Maksa pangakaardiga.", 
    menu_refuel_header = "Tankla",
    menu_refuel_accept = "Tankima.",
    menu_refuel_cancel = "Katkesta.",
    menu_pay_label_1 = "Tankla @ ",
    menu_pay_label_2 = " / L",
    menu_header_jerry_can = "Kütusekanister",
    menu_header_refuel_jerry_can = "Tangi autot",
    menu_header_refuel_vehicle = "Tangi sõidukit",

    menu_electric_cancel = "Katkesta.",
    menu_electric_header = "Laadimispunkt",
    menu_electric_accept = "Laadima.",
    menu_electric_payment_label_1 = "Elektrit @ ",
    menu_electric_payment_label_2 = " / KW",


    -- Station Menus

    menu_ped_manage_location_header = "Redigeeri tanklat",
    menu_ped_manage_location_footer = "Kui sa oled omanik, siis sul on võimalus siin tanklas asju teha.",

    menu_ped_purchase_location_header = "Osta tankla",
    menu_ped_purchase_location_footer = "Kui keegi seda tanklat ei oma siis on sul võimalus see omale osta.",

    menu_ped_emergency_shutoff_header = "Lülita hädaabiseiskamis süsteem sisse",
    menu_ped_emergency_shutoff_footer = "",
    
    menu_ped_close_header = "Sulge menüü",
    menu_ped_close_footer = "Mai soovi enam sinuga midagi rääkida...",

    menu_station_reserves_header = "Osta reserve ",
    menu_station_reserves_purchase_header = "Osta reserve, hinnaga: $",
    menu_station_reserves_purchase_footer = "Jah, ma soovin osta kütuse reserve, hinnaga: $",
    menu_station_reserves_cancel_footer = "Mõtlesin ümber, ei soovi ikka osta!",
    
    menu_purchase_station_header_1 = "Kogu maksumus on: $",
    menu_purchase_station_header_2 = " sisse lisatud ka maksud.",
    menu_purchase_station_confirm_header = "Kinnita",
    menu_purchase_station_confirm_footer = "Soovin osta selle tankla, hinnaga: $",
    menu_purchase_station_cancel_footer = "Mõtlesin ümber, enam küll ei taha seda tanklat osta, hind on liiga kirves!",

    menu_sell_station_header = "Müü ",
    menu_sell_station_header_accept = "Müü tanklat",
    menu_sell_station_footer_accept = "Jah, ma soovin müüa tankla maha, hinnaga: $",
    menu_sell_station_footer_close = "Mõtlesin ümber, ei soovi ikka müüa.",

    menu_manage_header = "Juhtimine ",
    menu_manage_reserves_header = "Kütuse reservid  \n",
    menu_manage_reserves_footer_1 =  " L praegu, ennem: ",
    menu_manage_reserves_footer_2 =  " L  \nSaad osta kütust juurde alt poolt!",
    
    menu_manage_purchase_reserves_header = "Kütuse reservi ost",
    menu_manage_purchase_reserves_footer = "Soovin osta rohkem kütusevarusid, hinnaga: $",
    menu_manage_purchase_reserves_footer_2 = " / L!",

    menu_alter_fuel_price_header = "Muuda kütusehinda",
    menu_alter_fuel_price_footer_1 = "Soovin muuta oma Tankla kütuse hinda! \nPraegu on: $",
    
    menu_manage_company_funds_header = "Hallake ettevõtte vahendeid",
    menu_manage_company_funds_footer = "Tahan hallata selle tankla arveldust.",
    menu_manage_company_funds_header_2 = "Arve haldamine ",
    menu_manage_company_funds_withdraw_header = "Väljasta arvelt",
    menu_manage_company_funds_withdraw_footer = "Tankla arvelt raha välja võtmine.",
    menu_manage_company_funds_deposit_header = "Sisesta arvele",
    menu_manage_company_funds_deposit_footer = "Tankla arvele raha sisestamine.",
    menu_manage_company_funds_return_header = "Tagasi",
    menu_manage_company_funds_return_footer = "Raha otsas :kappa:!",

    menu_manage_change_name_header = "Muuda tankla nime",
    menu_manage_change_name_footer = "Soov muuta tankla nime.",

    menu_manage_sell_station_footer = "Müü oma tankla maha, hinnaga: $",

    menu_manage_close = "Ei taha sellest enam rääkida!", 

    -- Jerry Can Menus 
    menu_jerry_can_purchase_header = "Osta kütusekanister, hinnaga: $",
    menu_jerry_can_footer_full_gas = "Sinu kütusekanister on täis!",
    menu_jerry_can_footer_refuel_gas = "Täida oma kütusekanistrit!",
    menu_jerry_can_footer_use_gas = "Täida oma kütusekanistrit kütusega!",
    menu_jerry_can_footer_no_gas = "Sul ei ole kütust kütusekanistris!",
    menu_jerry_can_footer_close = "Mõtlesin ümber, ei soovi osta enam kütusekanistrit.",
    menu_jerry_can_close = "Ma ei soovi ikka kütusekanistrit kasutada.",

    -- Syphon Kit Menus
    menu_syphon_kit_full = "Teie sifoonikomplekt on täis! Sinna mahub ainult " .. Config.SyphonKitCap .. "L!",
    menu_syphon_vehicle_empty = "Selle sõiduki kütusepaak on tühi.",
    menu_syphon_allowed = "Varasta pahaaimamatult ohvrilt kütust, tema sõidukist!",
    menu_syphon_refuel = "Pange varastatud bensiin kasutusele ja tankige autot!",
    menu_syphon_empty = "Pange varastatud bensiin kasutusele ja tankige autot!",
    menu_syphon_cancel = "Tegelikult ma ei taha seda enam kasutada. Olen pööranud uue lehe oma elus!",
    menu_syphon_header = "Sifoonimine",
    menu_syphon_refuel_header = "Tangi",


    -- Input --
    input_select_refuel_header = "Määra kui mitu L soovid tankida.",
    input_refuel_submit = "Tangi sõidukit",
    input_refuel_jerrycan_submit = "Täida kütusekanistrit",
    input_max_fuel_footer_1 = "Võimalik on: ",
    input_max_fuel_footer_2 = "L kütust.",
    input_insert_nozzle = "Tangi", -- Used for Target as well!

    input_purchase_reserves_header_1 = "Osta reserve  \nHetkene hind: $",
    input_purchase_reserves_header_2 = Config.FuelReservesPrice .. " / L  \nHetkel olemas olevad reservid: ",
    input_purchase_reserves_header_3 = " L  \nReservide täitmiseks läheb maksma: $",
    input_purchase_reserves_submit_text = "Osta reserve",
    input_purchase_reserves_text = 'Osta kütuse reserve.',

    input_alter_fuel_price_header_1 = "Muuda kütuse hinda  \nHetkene hind: $",
    input_alter_fuel_price_header_2 = " / L",
    input_alter_fuel_price_submit_text = "Muuda kütuse hinda ja ole pede nagu eesti riik",

    input_change_name_header_1 = "Muuda ",
    input_change_name_header_2 = "'s nime.",
    input_change_name_submit_text = "Kinnita nime muutus",
    input_change_name_text = "Uus nimi..",

    input_withdraw_funds_header = "Väljasta arvelt  \nArvel on: $",
    input_withdraw_submit_text = "Väljasta",
    input_withdraw_text = "",

    input_deposit_funds_header = "Sisesta arvele  \nArvel on: $",
    input_deposit_submit_text = "Sisesta",
    input_deposit_text = "",

    -- Target
    grab_electric_nozzle = "Haara laadimis otsik",
    insert_electric_nozzle = "Lae sõidukit",
    grab_nozzle = "Haara kütuse otsik",
    return_nozzle = "Tagasta otsik",
    grab_special_nozzle = "Haara spetsiaalne otsik",
    return_special_nozzle = "Tagasta otsik",
    buy_jerrycan = "Osta kütusekanister",
    station_talk_to_ped = "Räägi tankla omanikuga",

    -- Jerry Can
    jerry_can_full = "Sinu kütusekanister on täis!",
    jerry_can_refuel = "Kütusekanistri täitmine!",
    jerry_can_not_enough_fuel = "Kütusekanistris pole nii palju kütust!",
    jerry_can_not_fit_fuel = "Kütusekanistrisse ei mahu nii palju kütust!",
    jerry_can_success = "Edukalt täidetud kütusekanister!",
    jerry_can_success_vehicle = "Edukalt tangitud sõidukit, kütusekanistriga!",
    jerry_can_payment_label = "Ostsid edukalt kütusekanistri omale.",

    -- Syphoning
    syphon_success = "Edukalt sifoonitud sõidukist kütust!",
    syphon_success_vehicle = "Tankisid sõidukit sifoonitud kütusega!",
    syphon_electric_vehicle = "See on elektri auto, mees!",
    syphon_no_syphon_kit = "Sul on vaja midagi millega saad sifoonida kütust teistest sõidukitest.",
    syphon_inside_vehicle = "Sa ei saa sifoonida, kui oled sõidukis sees!",
    syphon_more_than_zero = "Kogus peab olema määratud suurem kui 0L!",
    syphon_kit_cannot_fit_1 = "Sa ei saa sifoonida nii palju, ei mahu ära! Mahub ainult: ",
    syphon_kit_cannot_fit_2 = " L",
    syphon_not_enough_gas = "Sul ei ole piisavalt kütust, et panna nii palju!",
    syphon_dispatch_string = "(10-90) - KÜTUSE VARGUS",
}
Lang = Locale:new({phrases = Translations, warnOnMissing = true})