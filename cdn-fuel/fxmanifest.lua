fx_version 'cerulean'
game 'gta5'

author 'github.com/CodineDev' -- Base Code from PS, other code by CodineDev. 
description 'cdn-fuel, based upon ps-fuel.'
version '1.0'

client_scripts {
    '@PolyZone/client.lua',
	'client/client.lua',
	'client/utils.lua'
}

server_scripts {
	'server/server.lua'
}

shared_scripts {
	'@qb-core/shared/locale.lua',
	'locales/en.lua',	-- Had Trouble with locales, so they are not implemented. Sorry!
	'locales/de.lua',
	'locales/fr.lua',
	'shared/config.lua',
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