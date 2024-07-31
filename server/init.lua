--- @section Dependencies
--- Import utility library from a shared resource.
utils = exports.boii_utils:get_utils()

--- @section Version check

--- Version check options
--- @field resource_name: The name of the resource to check, you can set a value here or use the current resource.
--- @field url_path: The path to your json file.
--- @field callback: Callback to invoking resource version check details *optional*
local opts = {
    resource_name = 'boii_items_new',
    url_path = 'boiidevelopment/fivem_resource_versions/main/versions.json',
}
utils.version.check(opts)

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
function send_notification(_src, header, message, type, duration)
    utils.ui.notify(_src, { header = header, message = message, type = type, duration = duration })
end

--- @section Callbacks

--- Callback filtered config to client.
-- @param _src number: The player's server ID.
-- @param data table: Request data (unused but included for callback pattern consistency).
-- @param cb function: Callback function to return the configuration data.
utils.callback.register('boii_items:sv:request_config', function(_src, data, cb)
    local client_config = {}
    client_config.debug = config.debug
    client_config.target = config.target
    local client_items = item_list
    cb(client_config, client_items)
end)