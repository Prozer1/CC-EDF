--client list
local global_db = dofile('global_db')
local client_list = global_db["client_list"]
local limits = global_db["rf_limits"]
local peripheral_number = global_db["energy_detector_number"]
local client_color = global_db["client_display_color"]
local total_client = {}

local config = {}

function config.get_clients()
    return client_list, limits, peripheral_number
end

function config.get_client_color(client_name)
    return client_color[client_name]
end

function config.load_total()
    sr = fs.open("total.txt", "r")
    if sr == nil then
        sw = fs.open("total.txt", "w")
        for i, client in pairs(client_list) do
            total_client[client] = 0
        end
        sw.close()
    else
        for i, client in pairs(client_list) do
            name = sr.readLine()
            value = sr.readLine()
            if value == nil then
                value = 0
            end
            total_client[client] = tonumber(value)
        end
        sr.close()
    end
    return total_client
end

function config.update_total(new_table)
    sw = fs.open("total.txt", "w")
    for i, client in pairs(client_list) do
        sw.writeLine(client)
        sw.writeLine(new_table[client])
    end
    sw.close()
    total_client = config.load_total()
    return total_client
end
return config