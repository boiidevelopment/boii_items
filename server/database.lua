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

--- @section DB Object

db = db or {}

--- @section Database queries

-- SQL query to create a table for dropped items.
local CREATE_DROPS_TABLE = [[
    CREATE TABLE IF NOT EXISTS `dropped_items` (
    `id` VARCHAR(255) NOT NULL,
    `owner` VARCHAR(255) NOT NULL,
    `drop_data` JSON NOT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
]]

-- SQL query to insert a new drop.
local INSERT_DROP = 'INSERT INTO `dropped_items` (`id`, `owner`, `drop_data`) VALUES (?, ?, ?)'

-- SQL query to remove a drop by id.
local DELETE_DROP = 'DELETE FROM `dropped_items` WHERE `id` = ?'

-- SQL query to retrieve a drop by id.
local GET_DROP = 'SELECT `drop_data` FROM `dropped_items` WHERE `id` = ?'

local GET_ALL_DROPS = 'SELECT * FROM `dropped_items`'

--- @section Local functions

--- Creates a table for dropped items if it doesn't exist.
local function create_table()
    MySQL.update(CREATE_DROPS_TABLE, {})
end
create_table()

--- Adds a new drop to the database.
local function add_drop(id, owner, drop_data)
    MySQL.Async.execute(INSERT_DROP, { id, owner, json.encode(drop_data) }, function(rows_changed)
        if rows_changed > 0 then
            print("Drop added successfully.")
        else
            print("Failed to add drop.")
        end
    end)
end

--- Removes a drop from the database by id.
local function remove_drop(id)
    MySQL.Async.execute(DELETE_DROP, { id }, function(rows_changed)
        if rows_changed > 0 then
            print("Drop removed successfully.")
        else
            print("No drop found with the specified ID.")
        end
    end)
end

--- Retrieves drop data by id.
local function get_drop(id, callback)
    MySQL.Async.fetchScalar(GET_DROP, { id }, function(result)
        if result then
            callback(json.decode(result))
        else
            callback(nil)
        end
    end)
end

--- Retrieves all drop data from the database.
local function get_all_drops(callback)
    MySQL.Async.fetchAll(GET_ALL_DROPS, {}, function(results)
        if results and #results > 0 then
            local drops = {}
            for _, row in ipairs(results) do
                local decoded_data = json.decode(row.drop_data) or {}
                drops[#drops + 1] = {
                    id = row.id,
                    owner = row.owner,
                    drop_data = decoded_data
                }
            end
            callback(drops)
        else
            print("No drops found or error retrieving drops.")
            callback(nil)
        end
    end)
end

--- @section Assign local functions

db.add_drop = add_drop
db.remove_drop = remove_drop
db.get_drop = get_drop
db.get_all_drops = get_all_drops