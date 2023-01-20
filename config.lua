-- Version
local version = 1.5
--client list
local client_list = {"Shorty", "Mr", "Prozer", "Lord", "Test", "Creunix", "Blyatman", "Yolo"}
local limits = {Shorty=11000,Mr=2200, Prozer=3300, Lord=4400, Test=123456789000, Creunix=99000, Blyatman=123456, Yolo=32154}
local peripheral_number = {Shorty=1,Mr=8,Prozer=9,Lord=5, Test=0, Creunix=4, Blyatman=2, Yolo=3}
local client_color = {Shorty=colors.gray, Mr=colors.blue, Prozer=colors.red, Lord=colors.orange, Test=colors.yellow, Creunix=colors.lightBlue, Blyatman=colors.pink, Yolo=colors.brown}
local total_client = {}

local config = {}

function config.get_clients()
    return version, client_list, limits, peripheral_number
end

function config.get_client_color(client_name)
    return client_color[client_name]
end

function config.load_total()
    sr = fs.open("total.txt", "r")
    if sr == nil then
        sw = fs.open("total.txt", "w")
        return total_client
    end
    for i, client in pairs(client_list) do
        name = sr.readLine()
        value = sr.readLine()
        if value == nil then
            value = 0
        end
        total_client[client] = tonumber(value)
    end
    sr.close()
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