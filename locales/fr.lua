-- Thank you to: https://github.com/Mat40, for the French Locales.
-- PR: https://github.com/CodineDev/cdn-fuel/pull/28/files#diff-7121f3a825660bdad39054bf931e5e1ead1d7f612424d0cae18b40aee4b6082f

local Translations = {
    -- Fuel
    set_fuel_debug = "Réglez le carburant sur:",
    cancelled = "Annulé.",
    not_enough_money = "Vous n'avez pas assez d'argent!",
    not_enough_money_in_bank = "Vous n'avez pas assez d'argent dans votre banque!",
    not_enough_money_in_cash = "Vous n'avez pas assez d'argent dans votre poche!",
    more_than_zero = "Il faut faire plus de 0L de carburant !",
    emergency_shutoff_active = "Les pompes sont actuellement arrêtées via le système d'arrêt d'urgence.",
    nozzle_cannot_reach = "La buse ne peut pas aller aussi loin!",
    station_no_fuel = "Cette station est en panne de carburant!",
    station_not_enough_fuel = "La station n'a pas autant de carburant!",
    tank_cannot_fit = "Votre réservoir ne peut pas s'adapter à cela!",
    tank_already_full = "Votre véhicule est déjà plein !",
    need_electric_charger = "Vous avez besoin d'aller à un chargeur électrique!",
    cannot_refuel_inside = "Vous ne pouvez pas faire le plein depuis l'intérieur du véhicule!",
    vehicle_is_damaged = "Le véhicule est trop endommagé pour faire le plein!",

    -- 2.1.2 -- Récupération des réserves ---
    fuel_order_ready = "Votre commande de carburant est disponible pour récupération ! Consultez votre GPS pour trouver l'endroit de récupération !",
    draw_text_fuel_dropoff = "[E] Déposer le camion",
    fuel_pickup_success = "Vos réserves ont été remplies à hauteur de : %sL",
    fuel_pickup_failed = "Ron Oil vient de livrer le carburant à votre station !",
    trailer_too_far = "La remorque n'est pas attachée au camion ou est trop éloignée !",

    -- 2.1.0
    no_nozzle = "Vous n'avez pas de buse !",
    vehicle_too_far = "Vous êtes trop loin pour ravitailler ce véhicule !",
    inside_vehicle = "Vous ne pouvez pas faire le plein depuis l'intérieur du véhicule !",
    you_are_discount_eligible = "Si vous êtes en service, vous pourriez bénéficier d'une réduction de "..Config.EmergencyServicesDiscount['discount'].."% !",
    no_fuel = "Sans carburant..",

    -- Electric
    electric_more_than_zero = "Vous devez charger plus de 0KW!",
    electric_vehicle_not_electric = "Votre véhicule n'est pas électrique!",
    electric_no_nozzle = "Votre véhicule n'est pas électrique!",

    -- Phone --
    electric_phone_header = "Chargeur électrique",
    electric_phone_notification = "Électricité Coût total: $",
    fuel_phone_header = "Station-essence",
    phone_notification = "Coût total: $",
    phone_refund_payment_label = "Remboursement @ Gas Station!",


    -- Stations
    station_per_liter = " / Litre!",
    station_already_owned = "Cet emplacement est déja pris!",
    station_cannot_sell = "Vous ne pouvez pas vendre cet emplacement!",
    station_sold_success = "Vous avez vendu cet emplacement avec succès!",
    station_not_owner = "Vous n'êtes pas propriétaire de l'emplacement!",
    station_amount_invalid = "Le montant n'est pas valide!",
    station_more_than_one = "Vous devez acheter plus de 1L!",
    station_price_too_high = "Ce prix est trop élevé!",
    station_price_too_low = "Ce prix est trop bas !",
    station_name_invalid = "Ce nom est invalide!",
    station_name_too_long = "Le nom ne peut pas dépasser "..Config.NameChangeMaxChar.." caractères.",
    station_name_too_short = "Le nom doit être plus court que "..Config.NameChangeMinChar.." de caractères.",
    station_withdraw_too_much = "Vous ne pouvez pas retirer plus que ce que la station a !",
    station_withdraw_too_little = "Vous ne pouvez pas retirer moins de 1$!",
    station_success_withdrew_1 = "Retrait réussi de $",
    station_success_withdrew_2 = " du solde de cette station!", -- Leave the space @ the front!
    station_deposit_too_much = "Vous ne pouvez pas déposer plus que ce que vous avez!",
    station_deposit_too_little = "Vous ne pouvez pas déposer moins de 1$!",
    station_success_deposit_1 = "$ déposé avec succès",
    station_success_deposit_2 = " dans l'équilibre de cette station!", -- Leave the space @ the front!
    station_cannot_afford_deposit = "Vous ne pouvez pas vous permettre de déposer $",
    station_shutoff_success = "Modification réussie de l'état de la vanne d'arrêt pour cet emplacement!",
    station_fuel_price_success = "Le prix du carburant a été modifié avec succès $",
    station_reserve_cannot_fit = "Les réserves ne peuvent pas s'adapter à cela!",
    station_reserves_over_max =  "Vous ne pouvez pas acheter ce montant car il sera supérieur au montant maximum de "..Config.MaxFuelReserves.." Litres",
    station_name_change_success = "Successfully changed name to: ", -- Leave the space @ the end!
    station_purchased_location_payment_label = "Acheté un emplacement de station-service: ",
    station_sold_location_payment_label = "Vendu une station-service ",
    station_withdraw_payment_label = "A retiré de l'argent de la station-service. Lieu: ",
    station_deposit_payment_label = "Dépôt d'argent à la station-service. Lieu: ",

    -- All Progress Bars
    prog_refueling_vehicle = "Ravitaillement du véhicule..",
    prog_electric_charging = "Chargement du véhicule..",
    prog_jerry_can_refuel = "Ravitaillement du jerrican..",
    prog_syphoning = "Siphonnage du carburant..",
    -- Menus
    menu_header_cash = "Espèces",
    menu_header_bank = "Banque",
    menu_header_close = "Annuler",
    menu_pay_with_cash = "Payez en espèces. Vous avez: $",
    menu_pay_with_bank = "Payer avec la banque.",
    menu_refuel_header = "Station-essence",
    menu_refuel_accept = "Je voudrais acheter le carburant.",
    menu_refuel_cancel = "En fait, je ne veux plus de carburant.",
    menu_pay_label_1 = "De l'essence @ ",
    menu_pay_label_2 = " / L",
    menu_header_jerry_can = "Jerrican",
    menu_header_refuel_jerry_can = "Faire le plein de jerrycan",
    menu_header_refuel_vehicle = "Ravitaillement du véhicule",

    menu_electric_cancel = "En fait, je ne veux plus recharger ma voiture.",
    menu_electric_header = "Chargeur électrique",
    menu_electric_accept = "Je voudrais payer l'électricité.",
    menu_electric_payment_label_1 = "Électricité @ ",
    menu_electric_payment_label_2 = " / KW",


    -- Station Menus

    menu_ped_manage_location_header = "Gérer cet emplacement",
    menu_ped_manage_location_footer = "Si vous êtes le propriétaire, vous pouvez gérer cet emplacement.",

    menu_ped_purchase_location_header = "Acheter cet emplacement",
    menu_ped_purchase_location_footer = "Si personne ne possède cet emplacement, vous pouvez l'acheter.",

    menu_ped_emergency_shutoff_header = "Basculer l'arrêt d'urgence",
    menu_ped_emergency_shutoff_footer = "Coupez le carburant en cas d'urgence. Les pompes sont actuellement ",

    menu_ped_close_header = "Annuler la conversation",
    menu_ped_close_footer = "En fait, je ne veux plus discuter de rien.",

    menu_station_reserves_header = "Acheter des réserves pour ",
    menu_station_reserves_purchase_header = "Acheter des réserves pour: $",
    menu_station_reserves_purchase_footer = "Oui, je veux acheter des réserves de carburant pour $",
    menu_station_reserves_cancel_footer = "En fait, je ne veux pas acheter plus de réserves!",

    menu_purchase_station_header_1 = "Le coût total sera: $",
    menu_purchase_station_header_2 = " taxes incluses.",
    menu_purchase_station_confirm_header = "Confirmer",
    menu_purchase_station_confirm_footer = "Je veux acheter cet emplacement pour $",
    menu_purchase_station_cancel_footer = "En fait, je ne veux plus acheter cet endroit. Ce prix est dingue!",

    menu_sell_station_header = "Vendre ",
    menu_sell_station_header_accept = "Vendre une station-service",
    menu_sell_station_footer_accept = "Oui, je veux vendre cet emplacement pour $",
    menu_sell_station_footer_close = "En fait, je n'ai plus rien à discuter.",

    menu_manage_header = "Gestion de ",
    menu_manage_reserves_header = "Réserves de carburant ",
    menu_manage_reserves_footer_1 =  " Litres sur ",
    menu_manage_reserves_footer_2 =  " Litres Vous pouvez acheter plus de réserves ci-dessous!",

    menu_manage_purchase_reserves_header = "Achetez plus de carburant pour les réserves",
    menu_manage_purchase_reserves_footer = "Je veux acheter plus de réserves de carburant pour $",
    menu_manage_purchase_reserves_footer_2 = " / L!",

    menu_alter_fuel_price_header = "Modifier le prix du carburant",
    menu_alter_fuel_price_footer_1 = "Je veux changer le prix du carburant à ma station-service! Actuellement, c'est $",

    menu_manage_company_funds_header = "Gérer les fonds de l'entreprise",
    menu_manage_company_funds_footer = "Je veux gérer les fonds de ces emplacements.",
    menu_manage_company_funds_header_2 = "Gestion des fonds de ",
    menu_manage_company_funds_withdraw_header = "Retirer des fonds",
    menu_manage_company_funds_withdraw_footer = "Retirer des fonds du compte de la Station.",
    menu_manage_company_funds_deposit_header = "Fonds de dépôt",
    menu_manage_company_funds_deposit_footer = "Déposez des fonds sur le compte de la Station.",
    menu_manage_company_funds_return_header = "Retour",
    menu_manage_company_funds_return_footer = "Je veux discuter d'autre chose !",

    menu_manage_change_name_header = "Modifier le nom de l'emplacement",
    menu_manage_change_name_footer = "Je veux changer le nom de l'emplacement.",

    menu_manage_sell_station_footer = "Vendez votre station-service pour $",

    menu_manage_close = "En fait, je n'ai plus rien à discuter!",

    -- Jerry Can Menus
    menu_jerry_can_purchase_header = "Achetez un jerrican pour $",
    menu_jerry_can_footer_full_gas = "Votre Jerry Can est plein!",
    menu_jerry_can_footer_refuel_gas = "Faites le plein de votre jerrican!",
    menu_jerry_can_footer_use_gas = "Mettez votre essence à utiliser et faites le plein du véhicule!",
    menu_jerry_can_footer_no_gas = "Vous n'avez pas d'essence dans votre Jerry Can!",
    menu_jerry_can_footer_close = "En fait, je ne veux plus de jerrican.",
    menu_jerry_can_close = "En fait, je ne veux plus l'utiliser.",

    -- Syphon Kit Menus

    menu_syphon_kit_full = "Votre Kit Siphon est plein ! Cela ne convient que " .. Config.SyphonKitCap .. "L!",
    menu_syphon_vehicle_empty = "Le réservoir de carburant de ce véhicule est vide.",
    menu_syphon_allowed = "Voler du carburant à une victime sans méfiance!",
    menu_syphon_refuel = "Utilisez votre essence volée et faites le plein du véhicule!",
    menu_syphon_empty = "Utilisez votre essence volée et faites le plein du véhicule!",
    menu_syphon_cancel = "En fait, je ne veux plus l'utiliser. J'ai tourné une nouvelle page !",
    menu_syphon_header = "Siphon",
    menu_syphon_refuel_header = "Ravitailler",

    -- Input --
    input_select_refuel_header = "Sélectionnez la quantité d'essence à ravitailler.",
    input_refuel_submit = "Véhicule de ravitaillement",
    input_refuel_jerrycan_submit = "Faire le plein de jerrycan",
    input_max_fuel_footer_1 = "Jusqu'à ",
    input_max_fuel_footer_2 = "L d'essence.",
    input_insert_nozzle = "Insérer la buse", -- Used for Target as well!

    input_purchase_reserves_header_1 = "Acheter des réserves Prix actuel: $",
    input_purchase_reserves_header_2 = Config.FuelReservesPrice .. " / Réserves actuelles en litre: ",
    input_purchase_reserves_header_3 = " Coût total de la réserve en litres: $",
    input_purchase_reserves_submit_text = "Acheter des réserves",
    input_purchase_reserves_text = 'Acheter des réserves de carburant.',

    input_alter_fuel_price_header_1 = "Modifier le prix du carburant au prix actuel: $",
    input_alter_fuel_price_header_2 = " / Litre",
    input_alter_fuel_price_submit_text = "Changer le prix du carburant",

    input_change_name_header_1 = "Nom de la station : ",
    input_change_name_header_2 = "",
    input_change_name_submit_text = "Soumettre le changement de nom",
    input_change_name_text = "Nouveau nom..",
    input_change_name = "Je veux changer le prix du carburant à ma station-service! Actuellement, c'est $",

    input_withdraw_funds_header = "Retirer des fonds Solde actuel: $",
    input_withdraw_submit_text = "Retirer",
    input_withdraw_text = "Retirer des fonds",

    input_deposit_funds_header = "Solde actuel des fonds de dépôt: $",
    input_deposit_submit_text = "Dépôt",
    input_deposit_text = "Fonds de dépôt",

    -- Target
    grab_electric_nozzle = "Prenez la buse électrique",
    insert_electric_nozzle = "Insérer la buse électrique",
    grab_nozzle = "Prendre la buse",
    return_nozzle = "Retourner la buse",
    grab_special_nozzle = "Prendre la buse spéciale",
    return_special_nozzle = "Retourner la buse spéciale",
    buy_jerrycan = "Acheter un jerrican",
    station_talk_to_ped = "Discuter de la station-service",

    -- Jerry Can
    jerry_can_full = "Votre jerrican est plein!",
    jerry_can_refuel = "Faites le plein de votre jerrycan !",
    jerry_can_not_enough_fuel = "Le jerrycan n'a pas autant de carburant!",
    jerry_can_not_fit_fuel = "Le jerrycan ne peut pas contenir autant de carburant!",
    jerry_can_success = "Le jerrican a été rempli avec succès!",
    jerry_can_success_vehicle = "J'ai réussi à ravitailler le véhicule avec le jerrycan!",
    jerry_can_payment_label = "Jerrican acheté.",
    -- Syphoning
    syphon_success = "Véhicule siphonné avec succès!",
    syphon_success_vehicle = "Essence mis avec succès dans le véhicule avec le kit de siphon!",
    syphon_electric_vehicle = "Ce véhicule est électrique !",
    syphon_no_syphon_kit = "Vous avez besoin de quelque chose pour siphonner l'essence avec.",
    syphon_inside_vehicle = "Vous ne pouvez pas siphonner de l'intérieur du véhicule!",
    syphon_more_than_zero = "Vous devez voler plus de 0L!",
    syphon_kit_cannot_fit_1 = "Vous ne pouvez pas siphonner autant, votre canette n'y rentrera pas ! Vous ne pouvez adapter: ",
    syphon_kit_cannot_fit_2 = " Litres.",
    syphon_not_enough_gas = "Vous n'avez pas assez d'essence pour faire le plein!",
    syphon_dispatch_string = "(10-90) - Vol d'essence",
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true,
    fallbackLang = Lang,
})