--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                              | |                                                                                
                              |_|                 ITEMS
]]

--- @section Tables

--- Config table.
config = config or {}

--- Target System
config.target = 'boii_target' -- Target resource. Options: boii_target, qb-target, ox_target

--- Item list table.
item_list = item_list or {}

--- @section Dependencies
--- Import utility library from a shared resource.
utils = exports.boii_utils:get_utils()

--- @section Global functions.

--- Handles debug logging.
-- @function debug_log
-- @param type string: The type of debug message.
-- @param message string: The debug message.
function debug_log(type, message)
    if config.debug and utils.debug[type] then
        utils.debug[type](message)
    end
end

--- Send notifications.
-- @function send_notification
-- @param header string: Notification header.
-- @param message string: Notification message.
-- @param type string: Notification type.
-- @param duration number: Notification duration in (ms).
function send_notification(header, message, type, duration)
    utils.ui.notify({
        header = header,
        message = message,
        type = type,
        duration = duration
    })
end

--- @section Callbacks

--- Fetches and sets up target zones upon callback.
-- @param config table: The configuration data for targets received from the server.
utils.callback.cb('boii_items:sv:request_config', {}, function(client_config, client_items)
    config = client_config
    item_list = client_items
end)