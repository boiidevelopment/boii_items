--- Drops an item from the player's inventory and creates an item in the world.
--- @param _src number: The source player identifier.
--- @param item_id string: The ID of the item being dropped.
--- @param amount number: The quantity of the item to drop.
local function drop_item(_src, item_id, amount)
    local item_data = items.get_item(item_id)
    if not item_data then
        send_notification(_src, 'ITEMS', 'Item not found for item_id:', item_id, 'error', 3500)
        return
    end
    if not item_data.droppable then
        send_notification(_src, 'ITEMS', 'Item is not droppable:', item_id, 'error', 3500)
        return
    end
    if not utils.fw.has_item(_src, item_id, amount) then
        send_notification(_src, 'ITEMS', 'Couldn\'t find the item to drop it. Make sure it is in your inventory.', 'error', 3500)
        return
    end
    local drop_position = GetEntityCoords(GetPlayerPed(_src))
    local drop_allowed = true
    for _, existing_drop in pairs(dropped_items) do
        local distance = utils.maths.calculate_distance(drop_position, existing_drop.position)
        if distance < 1.0 then
            drop_allowed = false
            break
        end
    end
    if not drop_allowed then
        send_notification(_src, 'ITEMS', 'Too many items nearby. Please move and try again', 'error', 3500)
        return
    end
    local item_details = utils.fw.get_item(_src, item_id)
    local item_meta = item_details.data or item_details.metadata or item_details.info or {}
    utils.fw.adjust_inventory(_src, {
        items = {{ item_id = item_id, action = 'remove', quantity = amount, data = item_meta }},
        note = 'Dropping an item.',
        should_save = true
    })
    local unique_id = 'dropped_item_' .. math.random(1000000, 9999999)
    while dropped_items[unique_id] do
        unique_id = 'dropped_item_' .. math.random(1000000, 9999999)
    end
    local drop_data = {
        model = item_data.model or 'prop_paper_bag_small',
        position = drop_position,
        item_id = item_id,
        label = item_data.label,
        amount = amount,
        category = item_data.category,
        data = item_meta,
        unique_id = unique_id
    }
    dropped_items[unique_id] = drop_data
    add_drop(unique_id, _src, drop_data)
    TriggerClientEvent('boii_items:cl:drop_item', -1, _src, drop_data)
    send_notification(_src, 'ITEMS', 'You dropped ' .. amount .. 'x ' .. item_data.label .. ' on the ground.', 'success', 3500)
end

exports('drop_item', drop_item)
items.drop_item = drop_item

--- Adds drop data.
--- @param _src number: Players source ID.
--- @param id string: Unique ID for the drop.
--- @param drop_data table: Table of data for the drop.
local function add_drop_data(_src, id, drop_data)
    local player_id = utils.fw.get_player_id(_src)
    if not id or not drop_data then
        send_notification(_src, 'ITEMS', 'Invalid drop data or ID provided.', 'error', 3500)
        return
    end
    dropped_items[id] = drop_data
    add_drop(id, player_id, drop_data)
end

exports('add_drop_data', add_drop_data)
items.add_drop_data = add_drop_data

--- Executes the pick up process, including inventory adjustment and object removal.
--- @param _src number: Source player.
--- @param net_id number: Network ID of the object.
--- @param unique_id string: Unique ID for the drop.
local function pick_up_item(_src, net_id, unique_id)
    get_drop(unique_id, function(drop_data)
        if not drop_data then
            send_notification(_src, 'ITEMS', 'The drop could not be found.', 'error', 3500)
            return
        end
        utils.fw.adjust_inventory(_src, {
            items = {{ item_id = drop_data.item_id, action = 'add', quantity = drop_data.amount, data = drop_data.data }},
            validation_data = {
                location = drop_data.position,
                distance = 5.0,
                drop_player = false
            },
            note = 'Picking up an item.',
            should_save = true
        })
        send_notification(_src, 'ITEMS', 'You picked up ' .. drop_data.amount .. 'x ' .. drop_data.label .. '!', 'success', 3500)
        remove_drop(unique_id)
        TriggerClientEvent('boii_items:cl:pick_up_item', -1, _src, net_id, unique_id)
    end)
end

exports('pick_up_item', pick_up_item)
items.pick_up_item = pick_up_item

--- @section Events

--- Triggers an item drop.
--- @param params table: Parameters received.
RegisterServerEvent('boii_items:sv:drop', function(params)
    local _src = source
    local item_id = params.item
    local amount = params.amount or 1
    drop_item(_src, item_id, amount)
end)

--- Picks up an item.
--- @param params table: Parameters received.
RegisterServerEvent('boii_items:sv:pick_up_item', function(params)
    local _src = source
    local net_id = params.net_id
    local unique_id = params.unique_id
    pick_up_item(_src, net_id, unique_id)
end)

--- @section Testing

RegisterCommand('items:test_drop', function(source, args, raw)
    local item_id = tostring(args[1])
    local amount = tonumber(args[2])
    drop_item(source, item_id, amount)
end)