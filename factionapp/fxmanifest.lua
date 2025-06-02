shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield



fx_version "cerulean"
game "gta5"

description "Business App"
author "Prime"

client_script "client.lua"
server_scripts {
	'@mysql-async/lib/MySQL.lua',
    "server.lua"
}

files {
    'ui/index.html',
    'ui/*.*',
    'ui/fonts/css/*.*',
    'ui/fonts/*.*',
    'ui/icons/*.*',
    'ui/assets/*.*',
}


ui_page 'ui/index.html'
