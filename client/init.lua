--- @section Global tables

config = config or {}
items = items or {}
item_list = item_list or {}
effects = effects or {}
buffs = buffs or {}
debuffs = debuffs or {}
equipped_clothing = {}
current_weapon = {}

--- @section Global constants

USE_TARGET = nil
TARGET = nil 

--- @section Dependencies
--- Import utility library from a shared resource.
utils = exports.boii_utils:get_utils()

--- @section Global functions

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
--- @function send_notification
--- @param header string: Notification header.
--- @param message string: Notification message.
--- @param type string: Notification type.
--- @param duration number: Notification duration in (ms).
function send_notification(header, message, type, duration)
    utils.ui.notify({ header = header, message = message, type = type, duration = duration })
end

--- @section Callbacks

--- Fetches and sets up target zones upon callback.
-- @param config table: The configuration data for targets received from the server.
utils.callback.cb('boii_items:sv:request_config', {}, function(client_config, client_items)
    config = client_config
    item_list = client_items
end)

--- @section Threads

CreateThread(function()
    while not (config and config.target or not config.use_target) do
        Wait(100)
    end
    USE_TARGET = config.use_target
    TARGET = config.target
    print('Target has been set.')
end)