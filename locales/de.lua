-- Thanks to: https://github.com/AbrahamMoody for the German Translations!
-- PR: https://github.com/CodineDev/cdn-fuel/pull/27

local Translations = {
    -- Fuel
    set_fuel_debug = "Kraftstoff einstellen auf:",
    cancelled = "Abgebrochen.",
    not_enough_money = "Du hast nicht genug Geld!",
    not_enough_money_in_bank = "Du hast nicht genug Geld auf der Bank!",
    not_enough_money_in_cash = "Du hast nicht genug Geld in deiner Tasche!",
    more_than_zero = "Du musst mehr als 0 Liter tanken!",
    emergency_shutoff_active = "Die Pumpen werden derzeit über das Notabschaltsystem abgeschaltet..",
    nozzle_cannot_reach = "Der Zapfhan reicht nicht soweit!",
    station_no_fuel = "Diese Tankstelle hat keinen Kraftstoff mehr!",
    station_not_enough_fuel = "Die Tankstelle verfügt nicht über so viel Treibstoff!",
    tank_cannot_fit = "Das passt nicht in Ihren Tank!",
    tank_already_full = "Ihr Fahrzeug ist bereits voll!",
    need_electric_charger = "Ich muss eine elektrische Ladesäule benutzen!!",
    cannot_refuel_inside = "Sie können nicht aus dem Fahrzeuginneren tanken!",
    vehicle_is_damaged = "Das Fahrzeug ist zu beschädigt zum Tanken!",

    -- 2.1.2 -- Reservenabholung ---
    fuel_order_ready = "Ihre Kraftstoffbestellung ist abholbereit! Schauen Sie auf Ihrem GPS nach, um die Abholstelle zu finden!",
    draw_text_fuel_dropoff = "[E] LKW abstellen",
    fuel_pickup_success = "Ihre Reserven wurden aufgefüllt: %sL",
    fuel_pickup_failed = "Ron Oil hat gerade den Kraftstoff an Ihre Tankstelle geliefert!",
    trailer_too_far = "Der Anhänger ist nicht mit dem LKW verbunden oder zu weit entfernt!",

    -- 2.1.0
    no_nozzle = "Sie haben keine Zapfpistole!",
    vehicle_too_far = "Sie sind zu weit entfernt, um dieses Fahrzeug zu betanken!",
    inside_vehicle = "Sie können nicht von innen tanken!",
    you_are_discount_eligible = "Wenn Sie im Dienst sind, können Sie einen Rabatt von "..Config.EmergencyServicesDiscount['discount'].."% erhalten!",
    no_fuel = "Kein Treibstoff..",

    -- Electric
    electric_more_than_zero = "Sie müssen mehr als 0 KW laden!",
    electric_vehicle_not_electric = "Ihr Fahrzeug ist kein Elektrofahrzeug!",
    electric_no_nozzle = "Ihr Fahrzeug ist kein Elektrofahrzeug!",

    -- Phone --
    electric_phone_header = "Elektrische Ladesäule",
    electric_phone_notification = "Elektrizität Gesamtkosten: $",
    fuel_phone_header = "Tankstelle",
    phone_notification = "Gesamtkosten: $",
    phone_refund_payment_label = "Refund @ Gas Station!",

    -- Stations
    station_per_liter = " / Liter!",
    station_already_owned = "Diese Tankstelle wurde bereits gekauft!",
    station_cannot_sell = "Du kannst diese Tankstelle nicht verkaufen!",
    station_sold_success = "Du hast diese Tankstelle erfolgreich verkauft!",
    station_not_owner = "Dir gehört diese Tankstelle nicht!",
    station_amount_invalid = "Menge ist ungültig!",
    station_more_than_one = "Du musst mehr als 1 Liter tanken!",
    station_price_too_high = "Der Preis ist zu hoch!",
    station_price_too_low = "Der Preis ist zu niedrig!",
    station_name_invalid = "Dieser Name ist ungültig!",
    station_name_too_long = "Der Name darf nicht länger sein als "..Config.NameChangeMaxChar.." Zeichen.",
    station_name_too_short = "Der Name muss länger sein als "..Config.NameChangeMinChar.." Zeichen.",
    station_withdraw_too_much = "Du kannst nicht mehr abheben, als die Tankstelle hat!", 
    station_withdraw_too_little = "Du kannst nicht weniger als $1 abheben!",
    station_success_withdrew_1 = "Erfolgreich abgehoben $",
    station_success_withdrew_2 = " vom Tankstellenkonto!", -- Leave the space @ the front!
    station_deposit_too_much = "Du kannst nicht mehr einzahlen, als Du besitzt.!", 
    station_deposit_too_little = "Du musst mehr als $1 einzahlen!",
    station_success_deposit_1 = "Erfolgreich eingezahlt $",
    station_success_deposit_2 = " auf das Tankstellenkonto!", -- Leave the space @ the front!
    station_cannot_afford_deposit = "Du kannst Dir keine Einzahlung leisten $",
    station_shutoff_success = "Erfolgreich den Zustand des Absperrventils für diesen Standort geändert!",
    station_fuel_price_success = "Erfolgreiche Änderung des Kraftstoffpreises auf $",
    station_reserve_cannot_fit = "Die Reserven können dies nicht ausgleichen!",
    station_reserves_over_max =  "Du kannst diesen Betrag nicht kaufen, da er größer ist als der Höchstbetrag von "..Config.MaxFuelReserves.." Liters",
    station_name_change_success = "Erfolgreich den Namen geändert in: ", -- Leave the space @ the end!
    station_purchased_location_payment_label = "Kauf eines Tankstellenstandortes: ",
    station_sold_location_payment_label = "Verkauf eines Tankstellenstandortes: ",
    station_withdraw_payment_label = "Geld von der Tankstelle abgehoben. Standort: ",
    station_deposit_payment_label = "Geld bei der Tankstelle hinterlegt. Standort: ",
    -- All Progress Bars
    prog_refueling_vehicle = "Fahrzeug wird betankt..",
    prog_electric_charging = "Lade auf..",
    prog_jerry_can_refuel = "Kanister wird aufgetankt..",
    prog_syphoning = "Kraftstoff absaugen..",

    -- Menus
    
    menu_header_cash = "Bargeld",
    menu_header_bank = "Bank",
    menu_header_close = "Abbrechen",
    menu_pay_with_cash = "Bezahle mit Bargeld. <br> Du hast: $", 
    menu_pay_with_bank = "Bezahle per Bank.", 
    menu_refuel_header = "Tankstelle",
    menu_refuel_accept = "Ich möchte den Kraftstoff kaufen.",
    menu_refuel_cancel = "Ich will eigentlich keinen Kraftstoff mehr.",
    menu_pay_label_1 = "Kraftstoff @ ",
    menu_pay_label_2 = " / L",
    menu_header_jerry_can = "Kraftstoffkanister",
    menu_header_refuel_jerry_can = "Kanister auftanken",
    menu_header_refuel_vehicle = "Fahrzeug auftanken",

    menu_electric_cancel = "Eigentlich möchte ich mein Auto nicht mehr aufladen..",
    menu_electric_header = "Elektrisches Ladegsäule",
    menu_electric_accept = "Ich möchte für den Strom bezahlen.",
    menu_electric_payment_label_1 = "Elektrizität @ ",
    menu_electric_payment_label_2 = " / KW",


    -- Station Menus

    menu_ped_manage_location_header = "Diesen Standort verwalten",
    menu_ped_manage_location_footer = "Wenn Sie der Eigentümer sind, können Sie diesen Standort verwalten.",

    menu_ped_purchase_location_header = "Diesen Tankstelle kaufen",
    menu_ped_purchase_location_footer = "Wenn dieser Ort niemandem gehört, können Sie ihn kaufen.",

    menu_ped_emergency_shutoff_header = "Notabschaltung umschalten",
    menu_ped_emergency_shutoff_footer = "Im Notfall den Kraftstoff abstellen. <br> Die Pumpen sind derzeit ",
    
    menu_ped_close_header = "Gespräch abbrechen",
    menu_ped_close_footer = "Ich will eigentlich gar nichts mehr diskutieren.",

    menu_station_reserves_header = "Kaufen Sie Reserven für ",
    menu_station_reserves_purchase_header = "Kaufen Sie Reserven für: $",
    menu_station_reserves_purchase_footer = "Ja, ich möchte Kraftstoffreserven kaufen $",
    menu_station_reserves_cancel_footer = "Reserven will ich eigentlich garnicht nicht kaufen!",
    
    menu_purchase_station_header_1 = "Die Gesamtkosten betragen: $",
    menu_purchase_station_header_2 = " einschließlich Steuern.",
    menu_purchase_station_confirm_header = "Bestätigen",
    menu_purchase_station_confirm_footer = "Ich möchte diesen Standort kaufen für $",
    menu_purchase_station_cancel_footer = "Ich möchte diesen Standort eigentlich nicht mehr kaufen. Dieser Preis ist verrückt!",

    menu_sell_station_header = "Verkaufen ",
    menu_sell_station_header_accept = "Tankstelle verkaufen",
    menu_sell_station_footer_accept = "Ja, ich möchte diesen Standort für verkaufen $",
    menu_sell_station_footer_close = "Ich habe eigentlich nichts mehr zu besprechen.",

    menu_manage_header = "Verwaltung von ",
    menu_manage_reserves_header = "Kraftstoffreserven <br> ",
    menu_manage_reserves_footer_1 =  " Liter aus ",
    menu_manage_reserves_footer_2 =  " LLiter <br> Unten kannst Du weitere Reserven kaufen!",
    
    menu_manage_purchase_reserves_header = "Kaufe mehr Treibstoff für Reserven",
    menu_manage_purchase_reserves_footer = "Ich möchte mehr Kraftstoffreserven kaufen für $",
    menu_manage_purchase_reserves_footer_2 = " / L!",

    menu_alter_fuel_price_header = "Kraftstoffpreis ändern",
    menu_alter_fuel_price_footer_1 = "Ich möchte den Kraftstoffpreis an meiner Tankstelle ändern! <br> Derzeit sind es $",
    
    menu_manage_company_funds_header = "Unternehmensgelder verwalten",
    menu_manage_company_funds_footer = "Ich möchte die Gelder dieses Standorts verwalten.",
    menu_manage_company_funds_header_2 = "Unternehmensgelder verwalten von ",
    menu_manage_company_funds_withdraw_header = "Auszahlungen",
    menu_manage_company_funds_withdraw_footer = "Geld vom Konto der Tankstelle abheben.",
    menu_manage_company_funds_deposit_header = "Geld einzahlen",
    menu_manage_company_funds_deposit_footer = "Zahlen Sie Geld auf das Konto der Tankstelle ein.",
    menu_manage_company_funds_return_header = "Zurück",
    menu_manage_company_funds_return_footer = "Ich möchte etwas anderes besprechen!",

    menu_manage_change_name_header = "Ortsnamen ändern",
    menu_manage_change_name_footer = "Ich möchte den Ortsnamen ändern.",

    menu_manage_sell_station_footer = "Verkaufen Sie Ihre Tankstelle für $",

    menu_manage_close = "Ich habe eigentlich nichts mehr zu besprechen!", 

    -- Jerry Can Menus 
    menu_jerry_can_purchase_header = "Kaufen einen Kanister für $",
    menu_jerry_can_footer_full_gas = "Dein Kanister ist voll!",
    menu_jerry_can_footer_refuel_gas = "Tanken Deinen Kanister auf!",
    menu_jerry_can_footer_use_gas = "Nutzen Sie Ihr Benzin und tanken Sie das Fahrzeug auf!",
    menu_jerry_can_footer_no_gas = "Du hast kein Benzin in Deinem Kanister!",
    menu_jerry_can_footer_close = "Ich will eigentlich keinen Kanister mehr.",
    menu_jerry_can_close = "Ich möchte das eigentlich nicht mehr benutzen..",

    -- Syphon Kit Menus
    menu_syphon_kit_full = "Ihr Syphon Kit ist voll! Es passt nur " .. Config.SyphonKitCap .. "L!",
    menu_syphon_vehicle_empty = "Der Kraftstofftank dieses Fahrzeugs ist leer.",
    menu_syphon_allowed = "Stehle Kraftstoff von einem ahnungslosen Opfer!",
    menu_syphon_refuel = "Nutze das gestohlene Benzin und tanken das Fahrzeug auf!",
    menu_syphon_empty = "Nutze das gestohlene Benzin und tanken das Fahrzeug auf!",
    menu_syphon_cancel = "Ich möchte das eigentlich nicht mehr benutzen. Ich habe ein neues Blatt aufgeschlagen!",
    menu_syphon_header = "Syphon",
    menu_syphon_refuel_header = "Auftanken",


    -- Input --
    input_select_refuel_header = "Wähle aus, wie viel Benzin Du tanken möchtest.",
    input_refuel_submit = "Fahrzeug betanken",
    input_refuel_jerrycan_submit = "Benzinkanister auftanken",
    input_max_fuel_footer_1 = "Bis zu ",
    input_max_fuel_footer_2 = "Liter Kraftstoff.",
    input_insert_nozzle = "Zapfhahn einsetzen", -- Used for Target as well!

    input_purchase_reserves_header_1 = "Kaufreserven<br>Aktueller Preis: $",
    input_purchase_reserves_header_2 = Config.FuelReservesPrice .. " / Liter <br> Aktuelle Reserven: ",
    input_purchase_reserves_header_3 = " Liter <br> Kosten für volle Reserven: $",
    input_purchase_reserves_submit_text = "Kaufe Reserven",
    input_purchase_reserves_text = 'Kraftstoffreserven kaufen.',

    input_alter_fuel_price_header_1 = "Kraftstoffpreis ändern <br>Aktueller Preis: $",
    input_alter_fuel_price_header_2 = " / Liter",
    input_alter_fuel_price_submit_text = "Kraftstoffpreis ändern",

    input_change_name_header_1 = "Ändern ",
    input_change_name_header_2 = "'s Name.",
    input_change_name_submit_text = "Namensänderung bestätigen",
    input_change_name_text = "Neuer Name..",

    input_withdraw_funds_header = "Geld abheben<br>Aktuelles Guthaben: $",
    input_withdraw_submit_text = "Abheben",
    input_withdraw_text = "Auszahlungen",

    input_deposit_funds_header = "Geld einzahlen<br>Aktueller Kontostand: $",
    input_deposit_submit_text = "Einzahlen",
    input_deposit_text = "Geld einzahlen",

    -- Target
    grab_electric_nozzle = "Schnappe Dir den elektrische Zapfhahn",
    insert_electric_nozzle = "Elektrischen Zapfhahn einsetzen",
    grab_nozzle = "Zapfhahn nehmen",
    return_nozzle = "Zapfhahn zurück hängen",
    grab_special_nozzle = "Sonderdüse greifen",
    return_special_nozzle = "Sonderdüse zurückgeben",
    buy_jerrycan = "Kanister kaufen",
    station_talk_to_ped = "Diskutieren Sie über Tankstelle",

    -- Jerry Can
    jerry_can_full = "Dein Kanister ist voll!",
    jerry_can_refuel = "Tanken Sie Ihren Kanister auf!",
    jerry_can_not_enough_fuel = "Der Kanister hat nicht so viel Sprit!",
    jerry_can_not_fit_fuel = "So viel Kraftstoff passt nicht in den Kanister!",
    jerry_can_success = "Den Kanister erfolgreich gefüllt!",
    jerry_can_success_vehicle = "Das Fahrzeug erfolgreich mit dem Kanister betankt!",
    jerry_can_payment_label = "Kanister gekauft.",

    -- Syphoning
    syphon_success = "Fahrzeug erfolgreich abgesaugt!",
    syphon_success_vehicle = "Das Fahrzeug erfolgreich mit dem Siphon-Kit betankt!",
    syphon_electric_vehicle = "Dieses Fahrzeug ist elektrisch!",
    syphon_no_syphon_kit = "Du brauchst etwas, mit dem Du den Kraftstoff absaugen kannst.",
    syphon_inside_vehicle = "Du kannst nicht aus dem Fahrzeuginnenraum saugen!",
    syphon_more_than_zero = "Du musst mehr als stehlen 0 L!",
    syphon_kit_cannot_fit_1 = "Du kannst nicht so viel absaugen, In Ihr Kanister passt nicht hinein! Sie können nur: ",
    syphon_kit_cannot_fit_2 = " Liters.",
    syphon_not_enough_gas = "YSie haben nicht genug Benzin, um so viel zu tanken!",
    syphon_dispatch_string = "(10-90) - Benzindiebstahl",
}
Lang = Locale:new({phrases = Translations, warnOnMissing = true})