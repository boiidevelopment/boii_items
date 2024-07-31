--- Database
--- @script server/scripts/database.lua

--- @section Database queries

--- @field CREATE_DROPS_TABLE string: Table schema for dropped items.
local CREATE_DROPS_TABLE = [[
    CREATE TABLE IF NOT EXISTS `dropped_items` (
    `id` VARCHAR(255) NOT NULL,
    `owner` VARCHAR(255) NOT NULL,
    `drop_data` JSON NOT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
]]

--- @field INSERT_DROP string: SQL query to insert a new drop.
local INSERT_DROP = 'INSERT INTO `dropped_items` (`id`, `owner`, `drop_data`) VALUES (?, ?, ?)'

--- @field DELETE_DROP string: SQL query to remove a drop by id.
local DELETE_DROP = 'DELETE FROM `dropped_items` WHERE `id` = ?'

--- @field GET_DROP string: SQL query to retrieve a drop by id.
local GET_DROP = 'SELECT `drop_data` FROM `dropped_items` WHERE `id` = ?'

--- @field GET_ALL_DROPS string: SQL query to retrieve all drops.
local GET_ALL_DROPS = 'SELECT * FROM `dropped_items`'

--- @section Local functions

--- Creates a table for dropped items if it doesn't exist.
local function create_table()
    MySQL.update(CREATE_DROPS_TABLE, {})
end
create_table()

--- Adds a new drop to the database.
--- @param id string: The unique identifier of the drop.
--- @param owner string: The owner of the drop.
--- @param drop_data table: The data associated with the drop.
function add_drop(id, owner, drop_data)
    MySQL.Async.execute(INSERT_DROP, { id, owner, json.encode(drop_data) }, function(rows_changed)
        if not rows_changed > 0 then
            print("Failed to add drop.")
        end
    end)
end

--- Removes a drop from the database by id.
--- @param id string: The unique identifier of the drop to remove.
function remove_drop(id)
    MySQL.Async.execute(DELETE_DROP, { id }, function(rows_changed)
        if not rows_changed > 0 then
            print("No drop found with the specified ID.")
        end
    end)
end

--- Retrieves drop data by id.
--- @param id string: The unique identifier of the drop to retrieve.
--- @param callback function: The function to call with the retrieved drop data.
function get_drop(id, callback)
    MySQL.Async.fetchScalar(GET_DROP, { id }, function(result)
        if result then
            callback(json.decode(result))
        else
            callback(nil)
        end
    end)
end

--- Retrieves all drop data from the database.
--- @param callback function: The function to call with the retrieved drop data.
function get_all_drops(callback)
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
            callback(nil)
        end
    end)
end