--- Server configuration.
-- @script server/config.lua

--- Here, you can adjust the core setup for the resource.
-- A copy of the server config will be sent to the client where relevant.

--- @section Tables

config = config or {}
items = items or {}
item_list = item_list or {}
dropped_items = {}

--- @section General settings

--- Debug Toggle
--- @field debug boolean: Enables or disables server-side debug prints for troubleshooting.
config.debug = true

--- Target

--- @field use_target boolean: Enable|Disable use of target system, if disabled script will use DUI for item pickups.
config.use_target = false

--- @field target_resource string: The name of the target resource to use this is sent to the client.
config.target = 'qb-target' -- Options: boii_target, qb-target, ox_target