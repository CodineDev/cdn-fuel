local Translations = {
    notify = {
        ["no_money"] = "Ich habe nicht genug Geld",
        ["refuel_cancel"] = "Tanken abgebrochen",
        ["vehicle_full"] = "Dieses Fahrzeug ist bereits voll",
        ["already_full"] = "Gas Can is already full",
        ["negative_amount"] = "You can't refuel a negative amount!",
        ["need_nozzle"] = "You should get the fuel nozzle first!",
    }
}
Lang = Locale:new({phrases = Translations, warnOnMissing = true})
