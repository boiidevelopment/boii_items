--- Utilities
--- @script shared/scripts/utils.lua

items = items or {}

--- @section Local functions

--- Gets all items
--- @return table|nil: The items data. Nil if no items found
local function get_items()
    return item_list or nil
end

items.get_items = get_items
exports('get_items', get_items)

--- Gets a specific item in the item_list by its ID.
--- @param item string: The unique identifier of the item to find.
--- @return table|nil: The items data if found within any category. Nil if the item is not found.
local function get_item(item)
    for category_name, category_items in pairs(item_list) do
        if category_items[item] then
            return category_items[item]
        end
    end
    return nil
end

items.get_item = get_item
exports('get_item', get_item)

--- Gets all available categories.
--- @return table: A table containing the names of all available categories.
local function get_categories()
    local categories = {}
    for category_name in pairs(items) do
        categories[#categories + 1] = category_name
    end
    return categories
end

items.get_categories = get_categories
exports('get_categories', get_categories)

--- Gets all items in a specific category.
--- @param category_name string: The name of the category to find items in.
--- @return table: A table containing all items in the specified category. Returns an empty table if the category is not found.
local function get_category_items(category_name)
    if items[category_name] then
        return items[category_name]
    else
        return {}
    end
end

items.get_category_items = get_category_items
exports('get_category_items', get_category_items)

--- Returns if an item is droppable.
--- @param item_id string: The id of the item.
--- @return true|false boolean: True or false for droppable or default to false.
local function can_drop(item_id)
    local item_data = get_item(item_id)
    return item_data.droppable or false
end

items.can_drop = can_drop
exports('can_drop', can_drop)