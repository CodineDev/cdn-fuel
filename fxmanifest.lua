fx_version 'cerulean'
game 'gta5'
author 'https://www.github.com/CodineDev' -- Base Refuelling System from PS (https://www.github.com/Project-Sloth), other code by CodineDev (https://www.github.com/CodineDev). 
description 'cdn-fuel, based upon ps-fuel.'
version '1.0.1'

client_scripts {
    '@PolyZone/client.lua',
	'client/client.lua',
	'client/utils.lua'
}

server_scripts {
	'server/server.lua'
}

shared_scripts {
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
 
provide 'cdn-syphoning' --This is used to override cdn-syphoning(https://github.com/CodineDev/cdn-syphoning) if you have it installed. If you don't have it installed, don't worry about this. If you do, we recommend removing it and using this instead.