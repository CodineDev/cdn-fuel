local Translations = {
    notify = {
        ["no_money"] = "You don't have enough money",
        ["refuel_cancel"] = "Refueling Canceled",
        ["vehicle_full"] = "This vehicle is already full",
        ["already_full"] = "Gas Can is already full",
        ["negative_amount"] = "You can't refuel a negative amount!",
        ["need_nozzle"] = "You should get the fuel nozzle first!",
    }
}
Lang = Locale:new({phrases = Translations, warnOnMissing = true})
