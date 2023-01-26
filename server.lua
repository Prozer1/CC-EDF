function update_pastebin()
    -- PASTEBIN --
    local startup_link = ""
    local utils_link = "q420mMBY"
    local api_link = "n8rdaW4w"
    local global_db_link = "cdCqpcGm"

    -- CHECK DEPENDENCY FILES --
    if fs.exists("startup") then
        fs.delete("startup")
    end
    if fs.exists("utils") then
        fs.delete("utils")
    end
    if fs.exists("api") then
        fs.delete("api")
    end
    if fs.exists("global_db") then
        fs.delete("global_db")
    end
    -- GET PASTEBIN --
    shell.run("pastebin get "..startup_link.." startup")
    shell.run("pastebin get "..utils_link.." utils")
    shell.run("pastebin get "..api_link.." api")
    shell.run("pastebin get "..global_db_link.." global_db")
end

-- IMPORT DEPS --
function update_import()
    utils = require("utils")
    api = require("api")
    global_db = dofile('global_db')
end
client_list = global_db["client_list"]
pc_id_per_user = global_db["pc_id"]
pc_id_shops = global_db["pc_id_function"]["shop"]
all_pc_id = api.get_list_pcs_id()

function get_all_total_sales()
    local stored = {}
    for _, id in pairs(all_pc_id) do
        for _, shop_id in pairs(pc_id_shops) do
            for _, client in pairs(client_list) do
                if id == pc_id_per_user[client] and id == shop_id then
                    local response = api.call(id, "sales.txt")
                    local line = response.readLine()
                    line = response.readLine()
                    val = utils.split(line, ":")[2]
                    stored[client]["total_sold"] = stored[client]["total_sold"] + tonumber(val)
                end
            end
        end
    end
end
