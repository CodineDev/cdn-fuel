local Translations = {
    notify = {
        ["no_money"] = "Vous n'avez pas assez d'argent",
        ["refuel_cancel"] = "Ravitaillement annulé",
        ["vehicle_full"] = "Ce véhicule est déjà plein",
        ["already_full"] = "Le jerrican est déjà plein",
        ["negative_amount"] = "You can't refuel a negative amount!",
        ["need_nozzle"] = "You should get the fuel nozzle first!",
    }
}
Lang = Locale:new({phrases = Translations, warnOnMissing = true})
