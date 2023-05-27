local Translations = {
    -- Fuel
    set_fuel_debug = "Establecer Carga:",
    cancelled = "Cancelado.",
    not_enough_money = "No tienes suficiente Dinero!",
    not_enough_money_in_bank = "No tienes tanto dinero en tu Banco!",
    not_enough_money_in_cash = "No tienes tanto dinero en tu bolsillo!",
    more_than_zero = "Tienes que cargar mas de 0L!",
    emergency_shutoff_active = "Las bombas de Gasolina están cerradas.",
    nozzle_cannot_reach = "La boquilla no llega tan lejos!",
    station_no_fuel = "Está Estación no tiene Combustible!",
    station_not_enough_fuel = "Está Estación no tiene tanto Combustible!",
    tank_cannot_fit = "Tu tanque no puede almacenar esta cantidad!",
    tank_already_full = "Tu vehiculo ya está lleno!",
    need_electric_charger = "Debo ir a un cargador Eléctrico!",
    cannot_refuel_inside = "No puedes repostar desde el interior del Vehiculo!",
    vehicle_is_damaged = "El vehiculo está demasiado dañado para repostarlo!",

    -- 2.1.2 -- Recogida de reservas ---
    fuel_order_ready = "¡Tu pedido de combustible está disponible para recoger! ¡Consulta tu GPS para encontrar el lugar de recogida!",
    draw_text_fuel_dropoff = "[E] Dejar camión",
    fuel_pickup_success = "Tus reservas se han llenado con: %sL",
    fuel_pickup_failed = "¡Ron Oil acaba de entregar el combustible a tu estación!",
    trailer_too_far = "¡El remolque no está enganchado al camión o está demasiado lejos!",

    -- 2.1.0
    no_nozzle = "¡No tienes la boquilla!",
    vehicle_too_far = "¡Estás demasiado lejos para repostar este vehículo!",
    inside_vehicle = "¡No puedes repostar desde el interior del vehículo!",
    you_are_discount_eligible = "Si entras en servicio, podrías recibir un descuento del "..Config.EmergencyServicesDiscount['discount'].."%!",
    no_fuel = "Sin combustible..",

    -- Electric
    electric_more_than_zero = "Debes cargar mas de 0KW!",
    electric_vehicle_not_electric = "Tu vehiculo no es Eléctrico!",
    electric_no_nozzle = "Tu vehiculo no es Eléctrico!",

    -- Phone --
    electric_phone_header = "Carga Eléctrica",
    fuel_phone_header = "Estación de Gasolina",
    electric_phone_notification = "Coste total de electricidad: $",
    phone_notification = "Coste total: $",
    phone_refund_payment_label = "Reembolsar @ Estación de Gasolina!",

    -- Stations
    station_per_liter = " / Litro!",
    station_already_owned = "Esta Ubicación ya tiene dueño!",
    station_cannot_sell = "No puedes vender esta Ubicación!",
    station_sold_success = "Vendiste está Ubicación!",
    station_not_owner = "No eres dueño de esta Ubicación!",
    station_amount_invalid = "La cantidad es invalida!",
    station_more_than_one = "Debes comprar mas de 1L!",
    station_price_too_high = "El precio es demasiado bajo!",
    station_price_too_low = "El precio es demasiado bajo!",
    station_name_invalid = "Este nombre es invalido!",
    station_name_too_long = "EL nombre no puede ser mas largo de "..Config.NameChangeMaxChar.." characters.",
    station_name_too_short = "El nombre debe ser mas largo que "..Config.NameChangeMinChar.." characters.",
    station_withdraw_too_much = "No puedes retirar mas de lo que tiene la Estación!", 
    station_withdraw_too_little = "No puedes retirar menos de $1!",
    station_success_withdrew_1 = "Retiraste $",
    station_success_withdrew_2 = " desde el balance de esta Estación!", -- Leave the space @ the front!
    station_deposit_too_much = "No puedes depositar mas de lo que tienes!", 
    station_deposit_too_little = "No puedes depositar menos de $1!",
    station_success_deposit_1 = "Depositaste $",
    station_success_deposit_2 = " dentro del balance de esta Estación!", -- Leave the space @ the front!
    station_cannot_afford_deposit = "No teienes suficiente para depositar $",
    station_shutoff_success = "Activaste la válvula de cierre para esta Ubicación!",
    station_fuel_price_success = "Cambiaste el precio del Combustible a $",
    station_reserve_cannot_fit = "Las reservas no se ajustan a esto!",
    station_reserves_over_max =  "No puedes comprar esta cantidad ya que será mayor a la cantidad máxima de "..Config.MaxFuelReserves.." Liters",
    station_name_change_success = "Cambiaste el nombre a: ", -- Leave the space @ the end!
    station_purchased_location_payment_label = "Comprar una Estación de Gasolina: ",
    station_sold_location_payment_label = "Vender una Estación de Servicio: ",
    station_withdraw_payment_label = "Retirar dinero de la Estación de Gasolina. Ubicación: ",
    station_deposit_payment_label = "Depositar dinero en la Estación de Gasolina. Ubicación: ",
    -- All Progress Bars
    prog_refueling_vehicle = "Repostando Vehiculo..",
    prog_electric_charging = "Cargando..",
    prog_jerry_can_refuel = "Rellenando Bidón..",
    prog_syphoning = "Extrayendo Combustible..",

    -- Menus
    
    menu_header_cash = "Dinero",
    menu_header_bank = "Banco",
    menu_header_close = "Cancelar",
    menu_pay_with_cash = "Pagar con Dinero. <br> Tienes: $", 
    menu_pay_with_bank = "Pagar con Banco.", 
    menu_refuel_header = "Estación de Gasolina",
    menu_refuel_accept = "Quisiera comprar el Combustible.",
    menu_refuel_cancel = "En realidad ya no quiero el Combustible.",
    menu_pay_label_1 = "Gasolina @ ",
    menu_pay_label_2 = " / L",
    menu_header_jerry_can = "Bidón",
    menu_header_refuel_jerry_can = "Rellenar Bidón",
    menu_header_refuel_vehicle = "Repostar Vehiculo",

    menu_electric_cancel = "En realidad no quiero cargar más mi Vehiculo.",
    menu_electric_header = "Carga Eléctrica",
    menu_electric_accept = "Quisiera pagar por la Electricidad.",
    menu_electric_payment_label_1 = "Electricidad @ ",
    menu_electric_payment_label_2 = " / KW",


    -- Station Menus

    menu_ped_manage_location_header = "Administrar esta Ubicación",
    menu_ped_manage_location_footer = "Si eres el dueño, puedes administrar esta Ubicación.",

    menu_ped_purchase_location_header = "Comprar esta Ubicación",
    menu_ped_purchase_location_footer = "Si nadie posee esta Ubicación, puedes comprarla.",

    menu_ped_emergency_shutoff_header = "Activar cierre de Emergencia",
    menu_ped_emergency_shutoff_footer = "Cierra la llave del Combustible en caso de Emergencia <br> Las bombas actualmente están ",
    
    menu_ped_close_header = "Terminar conversación",
    menu_ped_close_footer = "En realidad ya no quiero hablar mas.",

    menu_station_reserves_header = "Comprar reservas para ",
    menu_station_reserves_purchase_header = "Comprar reservas por: $",
    menu_station_reserves_purchase_footer = "Si, quiero comprar las reservas de Combustible por $",
    menu_station_reserves_cancel_footer = "En realidad no quiero comprar mas reservas!",
    
    menu_purchase_station_header_1 = "El costo total será de: $",
    menu_purchase_station_header_2 = " Incluyendo impuestos.",
    menu_purchase_station_confirm_header = "Confirmar",
    menu_purchase_station_confirm_footer = "Quiero comprar esta Ubicación por $",
    menu_purchase_station_cancel_footer = "En realidad ya no quiero comprar esta Ubicación. El precio es demaciado alto!",

    menu_sell_station_header = "Vender ",
    menu_sell_station_header_accept = "Vender Estación de Gasolina",
    menu_sell_station_footer_accept = "Si, quiero vender esta Ubicación por $",
    menu_sell_station_footer_close = "En realidad no tengo nada mas de que hablar.",

    menu_manage_header = "Mantenimiento de ",
    menu_manage_reserves_header = "Reservas de Combustible <br> ",
    menu_manage_reserves_footer_1 =  " Litros de ",
    menu_manage_reserves_footer_2 =  " litros <br> Puedes comprar más reservas a continuación!",
    
    menu_manage_purchase_reserves_header = "Comprar mas reservas de Combustible",
    menu_manage_purchase_reserves_footer = "Quiero comprar mas reservas de Combustible por $",
    menu_manage_purchase_reserves_footer_2 = " / L!",

    menu_alter_fuel_price_header = "Alterar precio del Combustible",
    menu_alter_fuel_price_footer_1 = "Quiero cambiar el precio del Combustible en mi Estación de Gasolina! <br> Actualmente es $",
    
    menu_manage_company_funds_header = "Administrar Fondos de la Compañia",
    menu_manage_company_funds_footer = "Quiero Administrar los fondos de esta Ubicación.",
    menu_manage_company_funds_header_2 = "Gestión de Fondos de",
    menu_manage_company_funds_withdraw_header = "Retirar Fondos",
    menu_manage_company_funds_withdraw_footer = "Retirar Fondos desde la cuenta de la Estación.",
    menu_manage_company_funds_deposit_header = "Depositar Fondos",
    menu_manage_company_funds_deposit_footer = "Depositar Fondos en la cuenta de la Estación.",
    menu_manage_company_funds_return_header = "Regresar",
    menu_manage_company_funds_return_footer = "Quiero hablar de otra cosa!",

    menu_manage_change_name_header = "Cambiar el nombre de la Ubicación",
    menu_manage_change_name_footer = "Quiero cambiar el nombre de esta Ubicación.",

    menu_manage_sell_station_footer = "Vender tu Estación de Galosina por $",

    menu_manage_close = "En realidad no tengo nada mas que hablar!", 

    -- Jerry Can Menus 
    menu_jerry_can_purchase_header = "Comprar Bidón por $",
    menu_jerry_can_footer_full_gas = "Tu Bidón está lleno!",
    menu_jerry_can_footer_refuel_gas = "Rellena tu Bidón!",
    menu_jerry_can_footer_use_gas = "Ponga su gasolina a usar y reposte el vehículo!",
    menu_jerry_can_footer_no_gas = "No tienes Combustible en tu Bidón!",
    menu_jerry_can_footer_close = "En ya no quiero un Bidón.",
    menu_jerry_can_close = "En realidad ya no quiero usar esto.",

    -- Syphon Kit Menus
    menu_syphon_kit_full = "Tu Kit Extractor está lleno! Solo tiene capacidad para " .. Config.SyphonKitCap .. "L!",
    menu_syphon_vehicle_empty = "El tanque de este vehiculo está vacío.",
    menu_syphon_allowed = "Roba Combustible de una víctima desprevenida",
    menu_syphon_refuel = "Ponga su gasolina robada para usar y reposte el vehículo!",
    menu_syphon_empty = "Ponga su gasolina robada para usar y reposte el vehículo!",
    menu_syphon_cancel = "En realidad ya no quiero usar esto.",
    menu_syphon_header = "Extractor",
    menu_syphon_refuel_header = "Repostar",


    -- Input --
    input_select_refuel_header = "Seleccionar cuanta Gasolina para repostar.",
    input_refuel_submit = "Reopostar",
    input_refuel_jerrycan_submit = "Rellenar Bidón",
    input_max_fuel_footer_1 = "Hasta ",
    input_max_fuel_footer_2 = "L de Gasolina.",
    input_insert_nozzle = "Insertar Boquilla en el auto", -- Used for Target as well!

    input_purchase_reserves_header_1 = "Comprar reservas<br>Precio actual: $",
    input_purchase_reserves_header_2 = Config.FuelReservesPrice .. " / Litro <br> Reservas actuales: ",
    input_purchase_reserves_header_3 = " Litros <br> Todas las reservas cuestan: $",
    input_purchase_reserves_submit_text = "Comprar reservas",
    input_purchase_reserves_text = 'Comprar reservas de Combustible.',

    input_alter_fuel_price_header_1 = "Alterar precio del Combustible <br>Precio actual: $",
    input_alter_fuel_price_header_2 = " / Litro",
    input_alter_fuel_price_submit_text = "Cambiar precio del Combustible",

    input_change_name_header_1 = "Cambiar ",
    input_change_name_header_2 = " nombre.",
    input_change_name_submit_text = "Actualizar cambio de Nombre",
    input_change_name_text = "Nombre Nuevo..",

    input_withdraw_funds_header = "Retirar Fondos<br>Balance Actual: $",
    input_withdraw_submit_text = "Retirar",
    input_withdraw_text = "Retirar Fondos",

    input_deposit_funds_header = "Depositar Fondos<br>Balance Actual: $",
    input_deposit_submit_text = "Depositar",
    input_deposit_text = "Depositar Fondos",

    -- Target
    grab_electric_nozzle = "Tomar Boquilla Eléctrica",
    insert_electric_nozzle = "Dejar Boquilla Eléctrica",
    grab_nozzle = "Tomar Boquilla",
    return_nozzle = "Dejar Boquila",
    grab_special_nozzle = "Tomar Boquilla Especial",
    return_special_nozzle = "Devolver Boquilla Especial",
    buy_jerrycan = "Comprar Bidón",
    station_talk_to_ped = "Hablar sobre la Estación",

    -- Jerry Can
    jerry_can_full = "Tu Bidón está lleno!",
    jerry_can_refuel = "Rellena tu Bidón!",
    jerry_can_not_enough_fuel = "El Bidón no tiene esa cantidad de Combustible!",
    jerry_can_not_fit_fuel = "El Bidón no puede almacenar tanto Combustible!",
    jerry_can_success = "Exito al llenar el Bidón!",
    jerry_can_success_vehicle = "Repostaste con exito el vehiculo con el Bidón!",
    jerry_can_payment_label = "Compraste un Bidón.",

    -- Syphoning
    syphon_success = "Éxito al extraer!",
    syphon_success_vehicle = "Repostaste con exito el vehiculo con el Kit Extractor!",
    syphon_electric_vehicle = "Este vehiculo es eléctrico!",
    syphon_no_syphon_kit = "Necesitas algo con lo que extraer la Gasolina.",
    syphon_inside_vehicle = "No puedes extraer desde dentro del vehiculo!",
    syphon_more_than_zero = "Debes robar más de 0L!",
    syphon_kit_cannot_fit_1 = "No puedes extraer tanto, tu bidón no tiene esa capacidad! Puedes almacenar: ",
    syphon_kit_cannot_fit_2 = " Litros.",
    syphon_not_enough_gas = "No tienes suficiente Gasolina para esa cantidad!",
    syphon_dispatch_string = "(10-90) - Ladrón de Gasolina",
}
Lang = Locale:new({phrases = Translations, warnOnMissing = true})