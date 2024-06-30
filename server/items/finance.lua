--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                              | |                                                                                
                              |_|                  ITEMS
]]

item_list.finance = {
    
    cash = {
        id = 'cash', -- Unique ID for the item, this should match the key.
        category = 'finance', -- Category for the item.
        label = 'Cash', -- Human readable label for the item.
        description = 'Cash moves everything around me..', -- Item description.
        image = 'cash.png', -- Image for the item.
        weight = 1, -- Item weight in grams.
        max_stack = nil, -- Max amount of items allowed per stack *(this will be used in boii_inventory)*.
        unique = false, -- Unique flag for genuinely unique items *(this will be used in boii_inventory)*.
        grid = { width = 1, height = 1 }, -- Grid size settings for boii_inventory
    },

    dirty_cash = {
        id = 'dirty_cash',
        category = 'finance',
        label = 'Dirty Cash',
        description = 'Dirty cash, I want you, dirty cash, I need you..',
        image = 'dirty_cash.png',
        weight = 1,
        max_stack = nil,
        unique = false,
        grid = { width = 1, height = 1 }
    },

}