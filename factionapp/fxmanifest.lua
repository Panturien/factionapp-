



fx_version "cerulean"
game "gta5"

description "Business App"
author "Jim"

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
