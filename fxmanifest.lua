fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'NOWAY STORE'
description 'New name, new identity, new person'
version '1.0.0'


escrow_ignore {
   'shared/Config.lua',
   'noway_namechanger',
}

shared_scripts { 
   '@es_extended/imports.lua', 
   '@ox_lib/init.lua' ,
}

server_scripts {
   '@es_extended/locale.lua',
   '@mysql-async/lib/MySQL.lua',
   'shared/Config.lua',
   'server/*.lua'
}

client_scripts {
   '@es_extended/locale.lua',
   'shared/Config.lua',
   'client/*.lua',
}

dependencies {
   'es_extended',
   'ox_lib',
   'ox_target'
}