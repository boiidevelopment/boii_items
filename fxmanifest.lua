--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                              | |                                                                                
                              |_|              ITEM SYSTEM
]]

fx_version 'cerulean'
games { 'gta5', 'rdr3' }

name 'boii_items'
version '0.5.0'
description 'BOII | Development - Utility: Item System'
author 'boiidevelopment'
repository 'https://github.com/boiidevelopment/boii_items'
lua54 'yes'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/config.lua',
    'server/init.lua',
    'server/data/*',
    'shared/scripts/utils.lua',
    'server/database.lua',
    'server/scripts/*',
    'server/main.lua'
}

client_scripts {
    'client/init.lua',
    'client/data/*',
    'shared/scripts/utils.lua',
    'client/scripts/*'
}

escrow_ignore {
    'client/*',
    'server/**/*'
}