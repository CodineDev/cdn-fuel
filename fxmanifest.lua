fx_version 'cerulean'
game 'gta5'
author 'https://www.github.com/CodineDev' -- Base Refueling System from PS (https://www.github.com/Project-Sloth), other code by CodineDev (https://www.github.com/CodineDev). 
description 'cdn-fuel'
version '2.0.0'

client_scripts {
    '@PolyZone/client.lua',
	'client/fuel_cl.lua',
	'client/electric_cl.lua',
	'client/station_cl.lua',
	'client/utils.lua'
}

server_scripts {
	'server/fuel_sv.lua',
	'server/station_sv.lua',
	'server/electric_sv.lua',
	'@oxmysql/lib/MySQL.lua',
}

shared_scripts {
	'shared/config.lua',
	'@qb-core/shared/locale.lua',
	'locales/en.lua', -- English Locales
	-- 'locales/de.lua', -- German / Deutsch Locales
	-- 'locales/fr.lua', -- French / Français Locales
	-- 'locales/es.lua', -- Spanish / Español / Española Locales
}

exports { -- Call with exports['cdn-fuel']:GetFuel or exports['cdn-fuel']:SetFuel
	'GetFuel',
	'SetFuel'
}

lua54 'yes'

dependencies { -- Make sure these are started before cdn-fuel in your server.cfg!
	'qb-target',
	'PolyZone', 
	'qb-input',
	'qb-menu',
	'interact-sound',
}

data_file 'DLC_ITYP_REQUEST' 'stream/[electric_nozzle]/electric_nozzle_typ.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/[electric_charger]/electric_charger_typ.ytyp'

provide 'cdn-syphoning' -- This is used to override cdn-syphoning(https://github.com/CodineDev/cdn-syphoning) if you have it installed. If you don't have it installed, don't worry about this. If you do, we recommend removing it and using this instead.