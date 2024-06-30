RegisterCommand('items:give_items', function(source, args, rawCommand)
    local player = utils.fw.get_player(source)
    if player then
        local items = {
            {item_id = 'old_bread', action = 'add', quantity = 10},
            {item_id = 'old_cheese', action = 'add', quantity = 10}
        }
        utils.fw.adjust_inventory(source, {
            items = items, 
            note = 'Test add items command', 
            should_save = true
        })
    end
end, false)